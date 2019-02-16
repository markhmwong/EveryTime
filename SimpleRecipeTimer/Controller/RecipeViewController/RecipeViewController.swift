//
//  RecipeController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 30/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewController: RecipeViewControllerBase, RecipeViewControllerDelegate {

    //MARK: - Class Variables -
    var screenSize = UIScreen.main.bounds.size
    var transitionDelegate = OverlayTransitionDelegate()
    var horizontalDelegate = HorizontalTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    var indexPath: IndexPath? = nil
    
    override var recipe: RecipeEntity! {
        didSet {
            recipeName.attributedText = NSAttributedString(string: recipe.recipeName!, attributes: Theme.Font.Nav.RecipeTitle)
        }
    }
    
    fileprivate lazy var recipeName: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: recipe.recipeName!, attributes: Theme.Font.Nav.RecipeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    fileprivate lazy var addStepButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Add Step", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleAddStep), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.Font.Color.AddButtonColour
        button.layer.cornerRadius = 3.0
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        return button
    }()
    
    fileprivate lazy var navView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate lazy var collView: UICollectionView = {
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
    
    //MARK: - Init -
    init(recipe: RecipeEntity, delegate: MainViewController, indexPath: IndexPath) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewControllerDelegate = delegate
        self.recipe = recipe
        self.stepSet = recipe.step as? Set<StepEntity>
        self.stepArr = recipe.sortStepsByPriority()
        self.indexPath = indexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    //MARK: - Controller Lifecycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The super class will call prepare_ functions
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCellsWhenViewAppears()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            navView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true
        }
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        self.view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
    }
    
    override func prepareView() {
        super.prepareView()
        self.view.addSubview(navView)
        navView.addSubview(dismissButton)
        navView.addSubview(addStepButton)
        navView.addSubview(recipeName)
        self.view.addSubview(collView)
        
        //MARK: CELL REGISTRATION
        collView.register(StepCell.self, forCellWithReuseIdentifier: stepCellId)
        
    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

    }
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
    }
    
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    override func prepareAutoLayout() {
        dismissButton.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 10).isActive = true
        
        addStepButton.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        addStepButton.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: -10).isActive = true
        
        recipeName.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        recipeName.centerXAnchor.constraint(equalTo: navView.centerXAnchor).isActive = true
        
        collView.topAnchor.constraint(equalTo: navView.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        navView.bottomAnchor.constraint(equalTo: collView.topAnchor, constant: 0).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let mvc = mainViewControllerDelegate else {
            //TODO: Error
            return
        }
        stopTimer()
        DispatchQueue.main.async {
            mvc.willReloadTableData()
        }
    }
    
    //MARK: - UI Methods -
    @objc func handleDismiss() {
        dismissCurrentViewController()
    }
    
    @objc func handleDeleteRecipe() {
        //delete entity by date
        guard let createdDate = recipe.createdDate else {
            return
        }
        CoreDataHandler.deleteEntity(entity: RecipeEntity.self, createdDate: createdDate)
        guard let mvc = mainViewControllerDelegate else {
            return
        }
        guard let index = indexPath else {
            return
        }
        
        mvc.recipeCollection.remove(at: index.item)
        mvc.collView.deleteItems(at: [index])
        dismissCurrentViewController()
    }
    
    func dismissCurrentViewController() {
        guard let mvc = mainViewControllerDelegate else {
            return
        }
        stopTimer()
        mvc.dismiss(animated: true) {
            mvc.startTimer()
        }
    }
    
    @objc func handleAddStep() {
        let vc = AddStepViewController()
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        dismissInteractor = OverlayInteractor()
        dismissInteractor.attachToViewController(viewController: vc, withView: vc.view, presentViewController: nil)
        vc.interactor = dismissInteractor
        transitionDelegate.dismissInteractor = dismissInteractor
        vc.recipeViewControllerDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func updateCurrentStep(step: StepEntity) {
        step.isLeading = false
        step.isComplete = true
        step.timeRemaining = 0.0
    }
    
    func updateNewLeadingTimer(indexPath: IndexPath) {
        let maxItems = collView.numberOfItems(inSection: 0) - 1
        let currIndex = indexPath.item

        if (currIndex < maxItems) {
            let nextEntity = stepArr[currIndex + 1]

            guard let r = recipe else {
                return
            }
            nextEntity.isLeading = true
            nextEntity.isComplete = false
            nextEntity.updateExpiry()
            r.updateStepInRecipe(nextEntity)
        }
    }

    //MARK: - RecipeVCDelegate Protocol Functions -
    func didReturnValues(step: StepEntity) {
        let priority = self.stepArr.count + 1
        step.priority = Int16(priority)
        self.recipe.addToStep(step)
        self.stepArr.append(step)
        CoreDataHandler.saveContext()
        self.startTimer()
    }
    
    func willReloadTableData() {
        self.collView.reloadData()
    }
}

extension RecipeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StepsViewController(stepEntity: stepArr[indexPath.item], viewControllerDelegate: self)
        horizontalTransitionInteractor = HorizontalTransitionInteractor(viewController: vc)
        horizontalDelegate.dismissInteractor  = horizontalTransitionInteractor
        vc.transitioningDelegate = horizontalDelegate
        vc.modalPresentationStyle = .custom
//        stopTimer()
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenSize.width, height: screenSize.width / 2)
    }
    
    //MARK: datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stepArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCellId, for: indexPath) as! StepCell
        cell.entity = stepArr[indexPath.item]
        return cell
    }
}

extension RecipeViewController: TimerProtocol {
    //MARK: Timer Protocol
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func update() {
        //updates specific cell only
        if (!recipe.isPaused) {
            let visibleCellIndexPaths = self.collView.indexPathsForVisibleItems.sorted { (x, y) -> Bool in
                return x < y
            }
            let stepPriorityToUpdate = Int(recipe.currStepPriority) //when parallel timers are enabled, we'll update multiple times
            let currPriorityIndexPath = IndexPath(item: stepPriorityToUpdate, section: 0)
            
            //updating current leading step entity
            //on screen
            
            let s = stepArr[stepPriorityToUpdate]
            if (s.timeRemaining.isLessThanOrEqualTo(0.0) && s.isComplete == true) {
                //to next step
                updateCurrentStep(step: s)
                updateNewLeadingTimer(indexPath: currPriorityIndexPath)
            } else {
                s.updateTotalTimeRemaining()
            }
            
            if (visibleCellIndexPaths.contains(IndexPath(item: stepPriorityToUpdate, section: 0))) {
                let stepCell = collView.cellForItem(at: currPriorityIndexPath) as! StepCell
                DispatchQueue.main.async {
                    stepCell.updateTimeLabel(time:s.timeRemainingToString())
                    stepCell.updateCompletionStatusLabel()
                }
            }
        }
        
//        //update visible cells except for current leading entity - leaving this here for now as certain edge cells that are offscreen aren't updated.
////        for indexPath in visibleCellIndexPaths {
////            if (indexPath.item != currPriorityIndexPath.item) {
////                let stepCell = collView.cellForItem(at: indexPath) as! StepCell
////                guard let s = stepCell.entity else {
////                    return
////                }
////                stepCell.updateTimeLabel(time:s.timeRemainingToString())
////                stepCell.updateDoneLabel()
////            }
////        }
    }
    
    func updateCellsWhenViewAppears() {
        
        let cellIndexPaths = self.collView.indexPathsForVisibleItems.sorted { (x, y) -> Bool in
            return x < y
        }
        for indexPath in cellIndexPaths {
            let stepCell = collView.cellForItem(at: indexPath) as! StepCell
            guard let s = stepCell.entity else {
                return
            }
            if (s.isLeading) {
                if (s.timeRemaining.isLessThanOrEqualTo(0.0) && s.isComplete == true) {
                    //to next step
                    updateCurrentStep(step: s)
                    updateNewLeadingTimer(indexPath: indexPath)
                    stepCell.updateCompletionStatusLabel()
                } else {
                    s.updateTotalTimeRemaining()
                }
            } else {
                //parallel timer next version
            }
            stepCell.updateTimeLabel(time:s.timeRemainingToString())
        }
    }
}
