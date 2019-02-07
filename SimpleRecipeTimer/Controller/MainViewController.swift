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
    fileprivate let recipeCellId = "RecipeCellId"
    var recipeCollection: [RecipeEntity] = []
    fileprivate var indexPathNumber = 0
    fileprivate var timer: Timer?
    fileprivate var transitionDelegate = OverlayTransitionDelegate()
    fileprivate var horizontalDelegate = HorizontalTransitionDelegate()
    fileprivate var dismissInteractor: OverlayInteractor!
    fileprivate var sections: Int = 0
    fileprivate lazy var rightNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Delete", attributes: Theme.Font.Nav.Item), for: .normal)//revert back to add recipe
        button.addTarget(self, action: #selector(handleDeleteRecipe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate lazy var leftNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Test Random Data", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleTest), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.dragInteractionEnabled = true
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var navView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()
    
    //MARK: - ViewController Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewControllerView()
        self.loadDataFromCoreData()//TODO: - load from background thread
        self.prepareSubviews()
        self.prepareAutoLayout()
        self.startTimer()
//        self.testCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
    }
    
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
        self.stopTimer()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            navView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    private func prepareViewControllerView() {
        self.view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        self.view.layer.cornerRadius = Theme.View.CornerRadius
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func prepareSubviews() {
        self.view.addSubview(navView)
        navView.addSubview(leftNavItemButton)
        navView.addSubview(rightNavItemButton)
        self.view.addSubview(collView)

        //register cells
        self.collView.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellId)
    }
    
    func prepareAutoLayout() {
        leftNavItemButton.centerYAnchor.constraint(equalTo: self.navView.centerYAnchor).isActive = true
        leftNavItemButton.leadingAnchor.constraint(equalTo: self.navView.leadingAnchor, constant: 10).isActive = true
        
        rightNavItemButton.centerYAnchor.constraint(equalTo: self.navView.centerYAnchor).isActive = true
        rightNavItemButton.trailingAnchor.constraint(equalTo: self.navView.trailingAnchor, constant: -10).isActive = true
        
        collView.topAnchor.constraint(equalTo: navView.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        navView.bottomAnchor.constraint(equalTo: collView.topAnchor, constant: 0).isActive = true
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
        self.recipeCollection = rEntityArr
    }
    
    func updateAllRecipes() {
        for recipe in recipeCollection {
            guard let s = recipe.searchLeadingStep() else {
                return
            }
            print(s.stepName)
            print(s.timeRemaining)
            recipe.updateStepInRecipe(s)
        }
    }
//        let step = recipe.searchLeadingStep()
//
//        guard let s = step else {
//            return
//        }
//
//        recipe.updateCurr(stepEntity: s)
//    func testCoreData() {
////        CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)
////        CoreDataHandler.printAllRecordsIn(entity: RecipeEntity.self)
//    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RecipeViewController(recipe: recipeCollection[indexPath.item], delegate: self)
        horizontalDelegate.dismissInteractor  = HorizontalTransitionInteractor(viewController: vc)
        vc.transitioningDelegate = horizontalDelegate
        vc.modalPresentationStyle = .custom
        vc.indexPath = indexPath
        self.stopTimer()
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeCollection.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numSections = 1
        return numSections
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
        let itemSpacing: CGFloat = 10
        return UIEdgeInsets(top: 5, left: itemSpacing, bottom: 5, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 20 //20 for left and right side
        let itemsPerRow: CGFloat = 1
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsPerRow)
        return CGSize(width: width, height: width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
    }
}

//MARK: - UI
extension MainViewController {
    @objc func handleTest() {
        let recipeNumber = 20
        for i in 0..<recipeNumber {
            let stepNumber = 15
            
            let rEntity = RecipeEntity(name: "Recipe\(i)")
            for i in 0..<stepNumber {
                let secondNumber = 5
                let sEntity = StepEntity(name: "Step\(i)", hours: 0, minutes: 0, seconds: secondNumber, priority: Int16(i))
                if (i == 0) {
                    sEntity.isLeading = true
                    sEntity.updateExpiry()
                    rEntity.currStepName = sEntity.stepName
                    rEntity.currStepPriority = Int16(0)
                }
                rEntity.addToStep(sEntity)
            }
            rEntity.sumStepsForExpectedElapsedTime()
            rEntity.updateCurrStepInRecipe()
            self.addToRecipeCollection(r: rEntity)
        }
        collView.performBatchUpdates({
            let insertIndexPaths = Array(0..<recipeCollection.count).map { IndexPath(item: $0, section: 0) }
            collView.insertItems(at: insertIndexPaths)
        }, completion: nil)
        CoreDataHandler.saveContext()
    }
    
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
    
    @objc func handleDeleteRecipe() {
        let deleteIndexPaths = Array(0..<recipeCollection.count).map { IndexPath(item: $0, section: 0) }
        recipeCollection.removeAll()
        collView.performBatchUpdates({
            collView.deleteItems(at: deleteIndexPaths)
        }, completion: nil)
        CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)
        CoreDataHandler.saveContext()
    }
}

extension MainViewController: TimerProtocol {
    func startTimer() {
        if (timer == nil) {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
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
                    r.updateRecipeTime()
                    cell.updateTimeLabel(timeRemaining: r.timeRemainingForCurrentStepToString())
                }
            }
        }
    }
}
