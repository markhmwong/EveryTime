//
//  ViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import SwipeCellKit

class MainViewController: UIViewController {
    let recipeCellId = "RecipeCellId"
    var recipeCollection: [RecipeEntity] = []
    var indexPathNumber = 0
    var timer: Timer?
    var rightNavItemButton: UIButton = UIButton()
    var transitionDelegate = OverlayTransitionDelegate()
    var horizontalDelegate = HorizontalTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
//    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil

    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.dragInteractionEnabled = true
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()

    var navView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()
    
    //MARK: - ViewController Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewControllerView()
        self.loadDataFromCoreData()//TODO: - load from background thread
        self.prepareSubviews()
        self.startTimer()
//        self.testCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            //safeAreaInsets = 44
            navView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    func prepareViewControllerView() {
        self.view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        self.view.layer.cornerRadius = Theme.View.CornerRadius
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func prepareSubviews() {
        navView.translatesAutoresizingMaskIntoConstraints = false
        navView.backgroundColor = UIColor.clear
        navView.layer.masksToBounds = true
        navView.clipsToBounds = true
        self.view.addSubview(navView)

        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        rightNavItemButton.setAttributedTitle(NSAttributedString(string: "Add", attributes: Theme.Font.Nav.Item), for: .normal)
        rightNavItemButton.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
        rightNavItemButton.translatesAutoresizingMaskIntoConstraints = false
        navView.addSubview(rightNavItemButton)
        rightNavItemButton.centerYAnchor.constraint(equalTo: self.navView.centerYAnchor).isActive = true
        rightNavItemButton.trailingAnchor.constraint(equalTo: self.navView.trailingAnchor, constant: -8).isActive = true
        
        self.view.addSubview(collView)
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.topAnchor.constraint(equalTo: navView.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddRecipe))
        
        navView.bottomAnchor.constraint(equalTo: collView.topAnchor, constant: 0).isActive = true

        //register cells
        self.collView.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellId)
    }

    //MARK: - UI
    @objc func handleAddRecipe() throws {
        let vc = AddRecipeViewController(delegate:self)
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        dismissInteractor = OverlayInteractor()
        dismissInteractor.attachToViewController(viewController: vc, withView: vc.view, presentViewController: nil)
        vc.interactor = dismissInteractor
        transitionDelegate.dismissInteractor = dismissInteractor
        self.present(vc, animated: true, completion: nil)
    }
    
    func willReloadCellData(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.collView.reloadItems(at: [indexPath])
        }
    }
    
    func willReloadTableData() {
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
    }
    
    // must be paused at all layers - recipe, step
    func pauseEntireRecipe(recipe: RecipeEntity) {
        recipe.pauseStepArr()
    }
    
    func unpauseEntireRecipe(recipe: RecipeEntity) {
        recipe.unpauseStepArr()
    }
    
    func addToRecipeCollection(r: RecipeEntity) {
        recipeCollection.append(r)
    }
    
    func addToCollectionView() {
        collView.insertItems(at: [IndexPath(item: recipeCollection.count - 1, section: 0)])
    }
    
    func loadDataFromCoreData() {
        //TODO: - load in background
        guard let rEntityArr = CoreDataHandler.fetchEntity(in: RecipeEntity.self) else {
            return
        }
        for rEntity in rEntityArr {
            rEntity.updateElapsedTimeByPriority()
        }
        self.recipeCollection = rEntityArr
    }
    
    func testCoreData() {
//        CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)
//        CoreDataHandler.printAllRecordsIn(entity: RecipeEntity.self)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RecipeViewController(recipe: recipeCollection[indexPath.item], delegate: self)
        horizontalDelegate.dismissInteractor  = HorizontalTransitionInteractor(viewController: vc)
        vc.transitioningDelegate = horizontalDelegate
        vc.modalPresentationStyle = .custom
        vc.indexPath = indexPath
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeCollection.count
    }

    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCellId, for: indexPath) as! RecipeCell
        cell.mainViewController = self
        cell.entity = recipeCollection[indexPath.row]
        cell.cellForIndexPath = indexPath
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemSpacing: CGFloat = 6
        return UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 8
        let itemsInOneLine: CGFloat = 2
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine)
        return CGSize(width: floor(width/itemsInOneLine), height: width / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
    }
}

extension MainViewController: TimerProtocol {
    func startTimer() {
        if (timer == nil) {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func update() {
        let cells = self.collView.visibleCells as! [RecipeCell]
        for cell in cells {
            if let r = cell.entity {
                if (!r.isPaused) {
                    r.updateRecipeElapsedTime()
                    cell.updateTimeLabel(timeRemaining: r.timeRemaining())
                }
            }
        }
    }
}
