//
//  ViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import AVFoundation

//import SwipeCellKit

enum ScrollingState {
    case Show
    case Hide
    case Idle
}

class MainViewController: ViewControllerBase {
    var recipeCollection: [RecipeEntity] = []

    fileprivate var player: AVAudioPlayer?
    fileprivate let recipeCellId = "RecipeCellId"
    fileprivate var addButtonState: ScrollingState = .Idle
    fileprivate var indexPathNumber = 0
    fileprivate var timer: Timer?
    fileprivate var transitionDelegate = OverlayTransitionDelegate()
    fileprivate var horizontalDelegate = HorizontalTransitionDelegate()
    fileprivate var dismissInteractor: OverlayInteractor!
    fileprivate var sections: Int = 0
    
    fileprivate lazy var rightNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Clear All", attributes: Theme.Font.Nav.Item), for: .normal)//revert back to add recipe
        button.addTarget(self, action: #selector(handleDeleteRecipe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var leftNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "About", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleAbout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var addRecipeButton: StandardButton = {
        let button = StandardButton(title: "Add Recipe")
        button.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var leftNavItemButtonA: UIButton = {
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

    fileprivate lazy var navView: NavView? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - ViewController Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        //The super class will call prepare_ functions
//        testData()

    }
    
    func testData() {
        if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
            print("Successfully deleted all records")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
    }
    
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
        stopTimer()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            guard let nav = navView else {
                return
            }
            nav.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        CoreDataHandler.loadContext()

        self.view.backgroundColor = Theme.Background.Color.NavBackgroundColor
        self.view.layer.cornerRadius = Theme.View.CornerRadius
        self.navigationController?.navigationBar.isHidden = true

        CoreDataHandler.getPrivateContext().perform {
            self.loadDataFromCoreData()
        }
        self.startTimer()
    }
    
     override func prepareView() {
        super.prepareView()
        navView = NavView(frame: .zero, leftNavItem: leftNavItemButton, rightNavItem: rightNavItemButton)
        guard let nav = navView else {
            return
        }
        view.addSubview(nav)
        view.addSubview(collView)
        view.addSubview(addRecipeButton)
        //register cells
        collView.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellId)
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        guard let nav = navView else {
            return
        }
        
        leftNavItemButton.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
        leftNavItemButton.leadingAnchor.constraint(equalTo: nav.leadingAnchor, constant: 10).isActive = true
        
        rightNavItemButton.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
        rightNavItemButton.trailingAnchor.constraint(equalTo: nav.trailingAnchor, constant: -10).isActive = true
        
        collView.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        nav.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nav.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nav.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        nav.bottomAnchor.constraint(equalTo: collView.topAnchor, constant: 0).isActive = true
        
        addRecipeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        addRecipeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addRecipeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
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
        DispatchQueue.main.async {
            self.collView.insertItems(at: [IndexPath(item: self.recipeCollection.count - 1, section: 0)])
        }
        
    }
    
    func loadDataFromCoreData() {
        //TODO: - load in background
        
        guard let rEntityArr = CoreDataHandler.fetchEntity(in: RecipeEntity.self) else {
            return
        }
        recipeCollection = sortRecipeCollection(in: rEntityArr)
    }
    
    func sortRecipeCollection(in rEntityArr: [RecipeEntity]) -> [RecipeEntity] {
        return rEntityArr.sorted { (x, y) -> Bool in
            return (x.createdDate?.compare(y.createdDate!) == .orderedAscending)
        }
    }

}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RecipeViewControllerWithTableView(recipe: recipeCollection[indexPath.item], delegate: self, indexPath: indexPath)
//        horizontalDelegate.dismissInteractor  = HorizontalTransitionInteractor(viewController: vc) // to be worked on. issue with timer when swiping to dismiss
        vc.transitioningDelegate = horizontalDelegate
        vc.modalPresentationStyle = .custom
        stopTimer()
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeCollection.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
        let itemSpacing: CGFloat = 0.0
        let verticalSpacing: CGFloat = 10.0
        return UIEdgeInsets(top: verticalSpacing, left: itemSpacing, bottom: verticalSpacing, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 8.0 //20 for left and right side
        let itemsPerRow: CGFloat = 5.0
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsPerRow)
        return CGSize(width: width, height: width / 3.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
    }
}

//MARK: - UI
extension MainViewController {
    /**
     # Adds Sample Data (not to be released during production)
     
     For testing purposes only. It creates a group of recipes with steps of random data. All variables are filled and used to sample the UI and flow.
    */
    @objc func handleTest() {
        let recipeNumber = 10
        CoreDataHandler.getPrivateContext().perform {
            for i in 0..<recipeNumber {
                let stepNumber = Int.random(in: 0..<8)
                
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
            CoreDataHandler.saveContext()
            DispatchQueue.main.async {
                self.collView.performBatchUpdates({
                    let insertIndexPaths = Array(0..<self.recipeCollection.count).map { IndexPath(item: $0, section: 0) }
                    self.collView.insertItems(at: insertIndexPaths)
                }, completion: nil)
            }
        }

    }
    
    @objc func handleAbout() {
        let vc = AboutViewController(delegate:self)
        present(vc, animated: true, completion: nil)
    }
    
    @objc func handleAddRecipe() {
        let vc = AddRecipeViewController(delegate:self)
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        dismissInteractor = OverlayInteractor()
        dismissInteractor.attachToViewController(viewController: vc, withView: vc.view, presentViewController: nil)
        vc.interactor = dismissInteractor
        transitionDelegate.dismissInteractor = dismissInteractor
        present(vc, animated: true, completion: nil)
    }
    
    @objc func handleDeleteRecipe() {
        let deleteIndexPaths = Array(0..<recipeCollection.count).map { IndexPath(item: $0, section: 0) }
        recipeCollection.removeAll()
        collView.performBatchUpdates({
            collView.deleteItems(at: deleteIndexPaths)
        }, completion: nil)
        if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
            CoreDataHandler.saveContext()
        }
    }
}

extension MainViewController: TimerProtocol {
    func startTimer() {
        if (timer == nil) {
            timer?.invalidate()
            let timerInterval = 0.1
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
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

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        executeState(state: .Hide)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        executeState(state: .Show)
    }
    
    func executeState(state: ScrollingState) {
        switch state {
        case .Show:
            showStepButtonAnimation()
        case .Hide:
            hideStepButtonAnimation()
        case .Idle:
            break
        }
    }
    
    func hideStepButtonAnimation() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.addRecipeButton.center.y = self.view.frame.maxY + 50.0
        }, completion: nil)
    }
    
    func showStepButtonAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.addRecipeButton.center.y = self.view.frame.maxY - 50.0
        }, completion: nil)
    }
}
