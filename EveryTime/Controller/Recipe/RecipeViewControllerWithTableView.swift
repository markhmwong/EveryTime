//
//  RecipeViewControllerWithTableView.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer



class RecipeViewControllerWithTableView: RecipeViewControllerBase, RecipeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var viewModel: RecipeViewModel?
    
    lazy var recipeControlsView = RecipeControlsView(delegate: self, theme: viewModel?.theme)
    
    lazy var mainView: RecipeView = {
        let view = RecipeView(delegate: self)
        view.backgroundColor = viewModel?.theme?.currentTheme.generalBackgroundColour
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var transitionDelegate = OverlayTransitionDelegate()
    
    var horizontalDelegate = HorizontalTransitionDelegate()
    
    var dismissInteractor: OverlayInteractor!
    
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.0
        return view
    }()
    
    var largeDisplay: LargeDisplayViewController?
    
    //animations uiviewpropertyanimator
    var recipeOptionsViewController: RecipeOptionsModalViewController?
    
    var runningAnimations = [UIViewPropertyAnimator]()
    
    var runninggGestures = [UIGestureRecognizer]()
    
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var recipeOptionsVisible: Bool = false
    
    var recipeOptionsCurrentState: RecipeOptionsState {
        return recipeOptionsVisible ? RecipeOptionsState.open : RecipeOptionsState.closed
    }
    
    var overlayTapGestureRecognizer: UITapGestureRecognizer?
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var bottomConstraint = NSLayoutConstraint()
    
    enum RecipeOptionsState {
        case closed
        case open
    }
    
    init(recipe: RecipeEntity, delegate: MainViewController, indexPath: IndexPath, viewModel: RecipeViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewControllerDelegate = delegate
        self.recipe = recipe //move to viewModel
        self.viewModel = viewModel
        self.viewModel?.dataSource = recipe.sortStepsByPriority()
        self.viewModel?.indexPathSelectedFromMainView = indexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        view.addSubview(overlayView)
        overlayView.fillSuperView()
        
        recipeOptionsViewController = RecipeOptionsModalViewController(delegate:self, viewModel: RecipeOptionsModalViewModel(theme: viewModel?.theme))
        guard let recipeOptionsViewController = recipeOptionsViewController else { return }
        recipeOptionsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(recipeOptionsViewController)
        view.addSubview(recipeOptionsViewController.view)
        let heightOfRecipeOptionsModal = heightForRecipeModal()
        
        recipeOptionsViewController.view.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: -10.0, right: -10.0), size: CGSize(width: 0.0, height: heightOfRecipeOptionsModal))
        
        bottomConstraint = (recipeOptionsViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0))
        bottomConstraint.isActive = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        setNeedsStatusBarAppearanceUpdate()
        guard let vm = viewModel else {
            return
        }
        
        vm.bottomViewState = .ShowAddStep
        vm.sortedStepSet = recipe.sortStepsByPriority()
    }

    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)

        mainView.headerView.backgroundColor = viewModel?.theme?.currentTheme.generalBackgroundColour
        mainView.headerView.updateHeaderTitleLabel(title: recipe.recipeName ?? "Unknown Name")
        mainView.headerView.updateHeaderStepTimeLabel(time: "\(recipe.timeRemainingForCurrentStepToString())")
        mainView.headerView.updateHeaderStepTitleLabel(title: recipe.currStepName ?? "Unknown Name")
        
        let sortedSet = recipe.sortStepsByPriority() //replace with viewmodel's array
        if (sortedSet.count - 1 > recipe.currStepPriority) {
            let nextStep: StepEntity = sortedSet[Int(recipe.currStepPriority) + 1]
            DispatchQueue.main.async {
                self.mainView.headerView.updateHeaderNextStepTimeLabel(time: nextStep.timeRemainingToString())
                self.mainView.headerView.updateHeaderNextStepTitleLabel(title: nextStep.stepName ?? "unknown")
            }
        } else {
            DispatchQueue.main.async {
                self.mainView.headerView.updateHeaderNextStepTimeLabel(time: "")
                self.mainView.headerView.updateHeaderNextStepTitleLabel(title: "")
            }
        }
        
        mainView.handleRightNavItem(pauseState: recipe.isPaused)
        mainView.handlePauseButton(pauseState: !recipe.isPaused)
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.fillSuperView()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func stepCount() -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    
    func modifyTime(_ seconds: Double) {
        guard let vm = viewModel else {
            return
        }
        do {
            
            try recipe.adjustTime(by: seconds, selectedStep: vm.stepSelected)
            recipe.sumStepsForExpectedElapsedTime() //updates totalTimeRemaining to update the pending local notification
            
            let id = "\(recipe.recipeName!).\(recipe.createdDate!)"
            LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
            DispatchQueue.main.async {
                self.mainView.tableView.reloadRows(at: [IndexPath(item: vm.stepSelected, section: 0)], with: .none)
            }
        } catch StepOptionsError.StepAlreadyComplete(_) {
            //step has been complete, can't add additional time. please reset first
            showAlertBox("Step is complete. Please reset the recipe or a specific step.")
        } catch _ {
            showAlertBox("Step is complete. Please reset the recipe or a specific step.")
        }
    }
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold Up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissCurrentViewController() {
        guard let mvc = mainViewControllerDelegate else {
            return
        }
        stopTimer()
        mvc.dismiss(animated: true) {
            if let indexPath = self.viewModel?.indexPathSelectedFromMainView {
                mvc.updateCellPauseState(indexPath: indexPath, recipe: self.recipe)
                mvc.startTimer()
            }
        }
    }
    
    func updateCurrentStep(step: StepEntity) {
        step.isLeading = false
        step.isComplete = true
        step.timeRemaining = 0.0
    }
    
    func updateNewLeadingTimer(indexPath: IndexPath) {
        let maxItems = mainView.tableView.numberOfRows(inSection: 0) - 1
        let currIndex = indexPath.item
        guard let r = recipe else {
            return
        }
        if (currIndex < maxItems) {
            if let nextEntity = viewModel?.dataSource[currIndex + 1] {
                nextEntity.isLeading = true
                nextEntity.isComplete = false
                nextEntity.updateExpiry()
                r.updateStepInRecipe(nextEntity)
            }
        }
    }

    
    /**
     # Plays sound when a step completes
     
     AudioServicesPlayAlertSound handles the mute/silent switch on the iPhone. Sound will not play when the mute switch is ON, instead it will vibrate. This is expected behaviour.
     
     http://iphonedevwiki.net/index.php/AudioServices
     
     */
    func playSound() {
        AudioServicesPlayAlertSound(1309)
    }
    
    //MARK: - RecipeVCDelegate Protocol Functions -
    func didReturnValues(step: StepEntity) {
        
        guard let vm = viewModel else {
            return
        }
        
        step.priority = Int16(vm.dataSource.count)
        self.recipe.addToStep(step)
        self.viewModel?.dataSource.append(step)
        CoreDataHandler.saveContext()
        startTimer()
    }
    
    func willReloadTableData() {
        mainView.tableView.reloadData()
    }
    
    func didEditStep(step: StepEntity, rowToUpdate: Int) {
        let targetStep = recipe.sortStepsByPriority()[rowToUpdate]
        
        targetStep.timeRemaining = step.timeRemaining
        targetStep.timeAdjustment = 0.0
        targetStep.totalTime = step.totalTime
        targetStep.stepName = step.stepName
        
        CoreDataHandler.saveContext()
        mainView.headerView.updateHeaderNextStepTimeLabel(time: step.timeRemainingToString())
        mainView.tableView.reloadRows(at: [IndexPath(row: rowToUpdate, section: 0)], with: .none)
    }
}

/*
    Button Handlers
*/
extension RecipeViewControllerWithTableView {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleResetStepTime() {
        var indexPathsToReloadArr: [IndexPath] = []
        guard let vm = viewModel else {
            return
        }
        recipe.wasReset = true
        indexPathsToReloadArr = recipe.resetEntireRecipeTo(toStep: vm.stepSelected)
        startTimer()
        
        let id = "\(recipe.recipeName!).\(recipe.createdDate!)"
        LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
        LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : recipe.recipeName!], timeRemaining: recipe.totalTimeRemaining)
        
        CoreDataHandler.saveContext()
        DispatchQueue.main.async {
            self.mainView.tableView.reloadRows(at: indexPathsToReloadArr, with: .none)
            self.executeBottomViewState(.ShowAddStep)
        }
    }
    
    /**
     # Full Recipe reset
     */
    func handleReset() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        
        let alert = UIAlertController(title: "Are you sure?", message: "Resetting the whole recipe cannot be undone", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            var indexPathsToReloadArr: [IndexPath] = []
            indexPathsToReloadArr = self.recipe.resetEntireRecipeTo()
            self.recipe.wasReset = true //important for resets

            let id = LocalNotificationsService.shared.locationNotificationIdentifierFor(recipe: self.recipe)
            if (self.recipe.isPaused) {
                //remove the notification because the recipe is paused, we don't need the notification to be pending.
                LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            } else {
                //reset localnotification
                LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
            }
            
            self.startTimer()
            CoreDataHandler.saveContext()
            
            DispatchQueue.main.async {
                self.mainView.tableView.reloadRows(at: indexPathsToReloadArr, with: .none)
                self.executeBottomViewState(.ShowAddStep)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func animateTransitionIfNeeded(state: RecipeOptionsState) {
        let duration = 0.5
        guard runningAnimations.isEmpty else {
            return
        }
        
        let overlayAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0) {
            switch state {
                case RecipeOptionsState.open:
                    
                    self.overlayView.alpha = 0.5
                
                case RecipeOptionsState.closed:

                    self.overlayView.alpha = 0.0
                
            }

        }
        overlayAnimator.isUserInteractionEnabled = true
        overlayAnimator.addCompletion { (position) in
            
            switch position {
            case .start:
                self.recipeOptionsVisible = true
            case .end:
                self.recipeOptionsVisible = !self.recipeOptionsVisible
            case .current:
                ()
            }
            self.runningAnimations.removeAll()
        }

        overlayAnimator.startAnimation()
        runningAnimations.append(overlayAnimator)
        
        let popOverAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.75) {
            switch state {
                case RecipeOptionsState.open:
                    
                    self.bottomConstraint.constant = -self.heightForRecipeModal() - 15.0 //+ self.heightForCell()
                    self.recipeOptionsViewController?.view.layer.cornerRadius = 8.0
                case RecipeOptionsState.closed:
                    
                    self.recipeOptionsViewController?.view.layer.cornerRadius = 0.0
                    self.bottomConstraint.constant = 25.0
                
            }
            self.view.layoutIfNeeded()
        }
        popOverAnimator.startAnimation()
        runningAnimations.append(popOverAnimator)
    }
    
    func startInteractiveTransition(state:RecipeOptionsState, duration:TimeInterval) {
        animateTransitionIfNeeded(state: state)

        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func closeInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func removeGesturesFromView() {
        guard let tapGesture = overlayTapGestureRecognizer else {
            return
        }
        overlayView.removeGestureRecognizer(tapGesture)
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        default:
            ()
        }
    }

    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recipeOptionsViewController?.view)
        
        switch recognizer.state {
            case .began:
                startInteractiveTransition(state: recipeOptionsCurrentState, duration: 0.5)
            case .changed:
                
                var fractionComplete = translation.y / heightForRecipeModal()
                
                if (recipeOptionsVisible) {
                    fractionComplete *= -1
                }

                updateInteractiveTransition(fractionCompleted: fractionComplete)
            
            case .ended:
                closeInteractiveTransition()
            default:
                ()
        }
    }
    
    @objc func handleOverlayDismisser(recognizer: UITapGestureRecognizer) {
        
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        default:
            ()
        }
    }
    
    func showSettings() {
        if (overlayTapGestureRecognizer == nil) {
            overlayTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOverlayDismisser(recognizer:)))
            guard let tapGesture = overlayTapGestureRecognizer else {
                return
            }
            tapGesture.cancelsTouchesInView = false
            overlayView.addGestureRecognizer(tapGesture)
        }
        
        // to be looked at (incomplete)
        if (panGestureRecognizer == nil) {
            panGestureRecognizer = UIPanGestureRecognizer()
            guard let panGesture = panGestureRecognizer else {
                return
            }
            panGesture.delegate = recipeOptionsViewController
            panGesture.cancelsTouchesInView = false
            
            panGesture.addTarget(self, action: #selector(handleCardPan(recognizer:)))
        }

        recipeOptionsVisible = true
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
    }
    
    func handleShuffle() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        
        self.mainView.tableView.isEditing = !self.mainView.tableView.isEditing
        self.mainView.headerView.saveButtonEnable()
    }
    
    func handleEditStep() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        
        if let index = mainView.tableView.indexPathForSelectedRow {
            let selectedRow = index.row
            guard let step = viewModel?.dataSource[selectedRow] else {
                return
            }
            let vc = EditStepViewControllerInExistingRecipe(delegate: self, selectedRow: selectedRow, viewModel: AddStepViewModel(userSelectedValues: step, theme: viewModel?.theme))
            present(vc, animated: true, completion: nil)
        } else {
//            print("to be compeleted - select a cell warning")
        }
    }
    
    func handleLargeDisplay() {
        largeDisplay = LargeDisplayViewController(delegate: self, viewModel: LargeDisplayViewModel(time: recipe.timeRemainingForCurrentStepToString(), stepName: recipe.currStepName ?? "Unknown Name", recipeName: recipe.recipeName ?? "Unknown Name", recipeEntity: recipe, sortedSet: viewModel?.sortedStepSet, theme: viewModel?.theme))
        largeDisplay?.viewModel?.updateFullScreen(sortedSet: viewModel?.sortedStepSet)
        largeDisplay?.updateViewControls(pauseState: recipe.isPaused)
        
        guard let ld = largeDisplay else {
            return
        }
        present(ld, animated: true, completion: nil)
    }
    
    func dismissFullScreenDisplay() {
        dismiss(animated: true) {
            self.largeDisplay = nil
        }
    }
    
    func handleSave() {
        self.mainView.tableView.isEditing = !self.mainView.tableView.isEditing
        mainView.headerView.saveButtonDisable()
        CoreDataHandler.saveContext()
    }
    
    @objc func handleDelete() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting cannot be undone", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.dismiss(animated: true) {
                //
                guard let mvc = self.mainViewControllerDelegate else {
                    return
                }
                guard let date = self.recipe.createdDate else {
                    return
                }
                mvc.handleDeleteARecipe(date)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func handleClose() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
    }

    func handleAddStep() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        
        let vm = AddStepViewModel(userSelectedValues: StepValues(name: "Step", hour: 0, min: 0, sec: 0), theme: viewModel?.theme)
        let vc = AddStepViewController(delegate: self, viewModel: vm)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func handleEditRecipe() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)

        
    }

    func handlePauseRecipe() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        mainView.handleSettingsButton(pauseState: recipe.isPaused)
        mainView.handlePauseButton(pauseState: recipe.isPaused)
        
        if (recipe.isPaused) {
            recipe.unpauseStepArr()
        } else {
            recipe.pauseStepArr()
        }
    }
    
    func handleAdditionalTime() {
        let seconds = 15.0
        modifyTime(seconds)
    }
    
    func handleMinusTime() {
        let seconds = -15.0
        modifyTime(seconds)
    }
}
