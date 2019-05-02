//
//  RecipeViewControllerWithTableView.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import AVFoundation

enum BottomViewState: Int {
    case ShowStepOptions
    case ShowAddStep
}

class RecipeViewControllerWithTableViewViewModel {
    
    var stepArr: [StepEntity] = []

}

class RecipeViewControllerWithTableView: RecipeViewControllerBase, RecipeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var viewModel: RecipeViewControllerWithTableViewViewModel?
    
    var transitionDelegate = OverlayTransitionDelegate()
    
    var horizontalDelegate = HorizontalTransitionDelegate()
    
    var dismissInteractor: OverlayInteractor!
    
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    
    var paddedView: UIView!
    
    var indexPathSelectedFromMainView: IndexPath?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var bottomViewState: BottomViewState?
    
    private let screenSize = UIScreen.main.bounds.size
    
    private let rowHeight: CGFloat = 120.0
    
    private var addButtonState: ScrollingState = .Idle
    
    private var stepSelected: Int = 0
    
    private var sortedStepSet: [StepEntity] = []
    
    private lazy var navView: NavView? = nil
    
    private var step: StepEntity?
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.0
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view: UITableView = UITableView()
        view.delegate = self
        view.isEditing = false
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()

    private var headerView: HeaderView = {
       let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()    
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Settings", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pauseRecipeButton: StandardButton = {
        let button = StandardButton(title: "Pause")
        button.addTarget(self, action: #selector(handlePauseRecipe), for: .touchUpInside)
        return button
    }()
    
    private lazy var border: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var largeDisplay: LargeDisplayViewController?
    
    //animations uiviewpropertyanimator
    lazy var recipeOptionsViewController: RecipeOptionsModalViewController = RecipeOptionsModalViewController(delegate:self)
    
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
    
    init(recipe: RecipeEntity, delegate: MainViewController, indexPath: IndexPath) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewControllerDelegate = delegate
        self.recipe = recipe
        self.viewModel = RecipeViewControllerWithTableViewViewModel()
        self.viewModel?.stepArr = recipe.sortStepsByPriority()
        self.indexPathSelectedFromMainView = indexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        
        //will need to move
        view.addSubview(overlayView)
        overlayView.fillSuperView()
        recipeOptionsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(recipeOptionsViewController)
        view.addSubview(recipeOptionsViewController.view)

        let heightOfRecipeOptionsModal = heightForRecipeModal()
        
        recipeOptionsViewController.view.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: -10.0, right: -10.0), size: CGSize(width: 0.0, height: heightOfRecipeOptionsModal))
        
        bottomConstraint = recipeOptionsViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        bottomConstraint.isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        setNeedsStatusBarAppearanceUpdate()
        bottomViewState = .ShowAddStep
        sortedStepSet = recipe.sortStepsByPriority()
    }


    override func prepareView() {
        super.prepareView()
        navView = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: settingsButton)
        guard let nav = navView else {
            return
        }
        view.addSubview(nav)
        view.addSubview(tableView)
        view.addSubview(pauseRecipeButton)

        
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        headerView.updateHeaderTitleLabel(title: recipe.recipeName ?? "Unknown Name")
        headerView.updateHeaderStepTimeLabel(time: "\(recipe.timeRemainingForCurrentStepToString())")
        headerView.updateHeaderStepTitleLabel(title: recipe.currStepName ?? "Unknown Name")
        
        let sortedSet = recipe.sortStepsByPriority() //replace with viewmodel's array
        if (sortedSet.count - 1 > recipe.currStepPriority) {
            let nextStep: StepEntity = sortedSet[Int(recipe.currStepPriority) + 1]
            DispatchQueue.main.async {
                self.headerView.updateHeaderNextStepTimeLabel(time: nextStep.timeRemainingToString())
                self.headerView.updateHeaderNextStepTitleLabel(title: nextStep.stepName ?? "unknown")
            }
        } else {
            DispatchQueue.main.async {
                self.headerView.updateHeaderNextStepTimeLabel(time: "")
                self.headerView.updateHeaderNextStepTitleLabel(title: "")
            }
        }
        
        if (recipe.isPaused) {
            DispatchQueue.main.async {
                self.navView?.rightNavItem?.alpha = 1.0
                self.navView?.rightNavItem?.isEnabled = true
                self.pauseRecipeButton.updateButtonTitle(with: "Start")
            }
        } else {
            DispatchQueue.main.async {
                self.navView?.rightNavItem?.isEnabled = false
                self.navView?.rightNavItem?.alpha = 0.3
                self.pauseRecipeButton.updateButtonTitle(with: "Pause")
            }
        }
        tableView.register(RecipeViewCell.self, forCellReuseIdentifier: stepCellId)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let safeAreaInsets = self.view.safeAreaInsets
        guard let nav = navView else {
            return
        }
        nav.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        guard let nav = navView else {
            return
        }
        
        tableView.anchorView(top: nav.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        
        let navTopConstraint = !appDelegate.hasTopNotch ? view.topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch

        nav.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        nav.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightByNotch).isActive = true
        pauseRecipeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        pauseRecipeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseRecipeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func stepCount() -> Int {
        return viewModel?.stepArr.count ?? 0
    }
    
    func modifyTime(_ seconds: Double) {
        do {
            try recipe.adjustTime(by: seconds, selectedStep: stepSelected)
            recipe.sumStepsForExpectedElapsedTime() //updates totalTimeRemaining to update the pending local notification
            
            let id = "\(recipe.recipeName!).\(recipe.createdDate!)"
            LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(item: self.stepSelected, section: 0)], with: .none)
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
            if let indexPath = self.indexPathSelectedFromMainView {
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
        let maxItems = tableView.numberOfRows(inSection: 0) - 1
        let currIndex = indexPath.item
        guard let r = recipe else {
            return
        }
        if (currIndex < maxItems) {
            if let nextEntity = viewModel?.stepArr[currIndex + 1] {
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
        
        step.priority = Int16(vm.stepArr.count)
        self.recipe.addToStep(step)
        self.viewModel?.stepArr.append(step)
        CoreDataHandler.saveContext()
        startTimer()
    }
    
    func willReloadTableData() {
        self.tableView.reloadData()
    }
}

extension RecipeViewControllerWithTableView: UITableViewDelegate, UITableViewDataSource {
    //switches the objects between cells. Allows the user to reorganise the order.
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
            if (indexPath.row == self.recipe.currStepPriority) {
                let sortedSet = self.recipe.sortStepsByPriority()
                let timeElapsedInStep = sortedSet[indexPath.row].totalTime - self.recipe.currStepTimeRemaining
                self.recipe.startDate?.addTimeInterval(timeElapsedInStep)
            }
            
            let id = "\(self.recipe.recipeName!).\(self.recipe.createdDate!)"
            
            if let vm = self.viewModel {
                self.recipe.removeFromStep(vm.stepArr[indexPath.row])
                vm.stepArr.remove(at: indexPath.row)
                self.recipe.reoganiseStepsInArr(fromIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.recipe.sumStepsForExpectedElapsedTime()
                LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
                CoreDataHandler.saveContext()
                complete(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reset = UIContextualAction(style: .normal, title: "reset") { (action, view, complete) in
            var indexPathsToReloadArr: [IndexPath] = []
            self.recipe.wasReset = true
            indexPathsToReloadArr = self.recipe.resetEntireRecipeTo(toStep: self.stepSelected)
            self.startTimer()
            
            let id = "\(self.recipe.recipeName!).\(self.recipe.createdDate!)"
            LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
            
            CoreDataHandler.saveContext()
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: indexPathsToReloadArr, with: .none)
                self.executeBottomViewState(.ShowAddStep)
                complete(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [reset])
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard let vm = viewModel else {
            return
        }
        
        let sourceObj = vm.stepArr[sourceIndexPath.row]
        let destinationObj = vm.stepArr[destinationIndexPath.row]
        
        let tempDestinationPriority = destinationObj.priority
        destinationObj.priority = sourceObj.priority
        sourceObj.priority = tempDestinationPriority
        
        vm.stepArr.remove(at: sourceIndexPath.row)
        vm.stepArr.insert(sourceObj, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.stepArr.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellId, for: indexPath) as! RecipeViewCell
        if let vm = viewModel {
            cell.entity = vm.stepArr[indexPath.item]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return view.bounds.height / 10
        default:
            return view.bounds.height / 13
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.headerView.enableStepOptions()
        }
        stepSelected = indexPath.row
        guard let vm = viewModel else {
            return
        }
        recipeOptionsViewController.isEditOptionEnabled()
        step = vm.stepArr[stepSelected]

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        changeBottomViewStateWhileDragging()
    }
    
    func heightForRecipeModal() -> CGFloat {
        let heightOfRecipeOptionsModal = heightForCell() * CGFloat(self.recipeOptionsViewController.dataSource.count)
        return heightOfRecipeOptionsModal
    }
    
    func heightForCell() -> CGFloat {
        return self.recipeOptionsViewController.tableView.rowHeight
    }
}

extension RecipeViewControllerWithTableView: TimerProtocol {
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
        //updates specific cell only - issue it won't continue to the next cell when the application is in the background

        if (!recipe.isPaused) {
            
            let sortedSet = recipe.sortStepsByPriority() //needs update
            let tp = recipe.timePassedSinceStart() + recipe.pauseTimeInterval
            var elapsedTime: Double = 0.0
            
            let visibleCellIndexPaths = self.tableView.indexPathsForVisibleRows?.sorted { (x, y) -> Bool in
                return x < y
            }
            guard let visibleCell = visibleCellIndexPaths else {
                return
            }
            
            for step in sortedSet {
                elapsedTime = elapsedTime + step.totalTime
                let time = elapsedTime - tp
                recipe.currStepName = step.stepName
                recipe.currStepPriority = step.priority
                
                if (time >= 0.0 && step.isComplete == false) {
                    //step incomplete
                    recipe.currStepTimeRemaining = time
                    step.timeRemaining = time
                    step.updateExpiry()
                    step.updateTimeRemaining()
                    
                    if (sortedSet.count - 1 > recipe.currStepPriority) {
                        let nextStep: StepEntity = sortedSet[Int(recipe.currStepPriority) + 1]
                        DispatchQueue.main.async {
                            self.headerView.updateHeaderNextStepTimeLabel(time: nextStep.timeRemainingToString())
                            self.headerView.updateHeaderNextStepTitleLabel(title: nextStep.stepName ?? "Unknown")
                            if (self.largeDisplay != nil) {
                                self.largeDisplay?.viewModel?.nextStepStr = nextStep.stepName
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.headerView.updateHeaderNextStepTimeLabel(time: "")
                            self.headerView.updateHeaderNextStepTitleLabel(title: "")
                            if (self.largeDisplay != nil) {
                                self.largeDisplay?.viewModel?.nextStepStr = ""
                            }
                        }
                    }

                    DispatchQueue.main.async {
                        self.headerView.updateHeaderStepTimeLabel(time: step.timeRemainingToString())
                        self.headerView.updateHeaderStepTitleLabel(title: step.stepName ?? "Unknown")
                    }
                    
                    /// Updates full screen labels
                    if (largeDisplay != nil) {
                        largeDisplay?.viewModel?.currTimeStr = step.timeRemainingToString()
                        largeDisplay?.viewModel?.currStepStr = step.stepName ?? "Unknown"
                        largeDisplay?.viewModel?.currRecipeStr = recipe.recipeName ?? "Unknown"
                        largeDisplay?.viewModel?.stepsComplete = recipe.stepsComplete() // remove sort
                        
                    }
                    let priorityIndexPath = IndexPath(item: Int(step.priority), section: 0)
                    if (visibleCell.contains(priorityIndexPath)) {
                        let stepCell = tableView.cellForRow(at: priorityIndexPath) as! RecipeViewCell
                        DispatchQueue.main.async {
                            stepCell.updateTimeLabel(time:step.timeRemainingToString())
                            stepCell.updateCompletionStatusLabel()
                        }
                    }
                    break
                } else {
                    //step complete
                    recipe.currStepTimeRemaining = 0.0
                    step.timeRemaining = 0.0
                    step.isComplete = true
                    
                    //shows last step when complete
                    if (sortedSet.count - 1 == recipe.currStepPriority) {
                        DispatchQueue.main.async {
                            self.headerView.updateHeaderStepTimeLabel(time: "00h 00m 00s")
                            self.headerView.updateHeaderStepTitleLabel(title: self.recipe.currStepName ?? "Unknown")
                        }
                    }
                    
                    /// Update steps complete count
                    if (largeDisplay != nil) {
                        largeDisplay?.viewModel?.totalSteps = recipe.stepSetSize()
                        largeDisplay?.viewModel?.stepsCompleteString = { largeDisplay?.viewModel?.stepsCompleteString }()
                    }
                    
                    let priorityIndexPath = IndexPath(item: Int(step.priority), section: 0)
                    if (visibleCell.contains(priorityIndexPath)) {
                        let stepCell = tableView.cellForRow(at: priorityIndexPath) as! RecipeViewCell
                        DispatchQueue.main.async {
                            stepCell.updateTimeLabel(time:step.timeRemainingToString())
                            stepCell.updateCompletionStatusLabel()
                        }
                    }
                    
                    // a check to see if the entire recipe is complete
                    if (sortedSet.count - 1 == Int(recipe.currStepPriority)) {
                        stopTimer()
                    }
                }
            }
            
            if (recipe.currStepTimeRemaining <= 0.1 && sortedSet.count != 0) {
                let s = sortedSet[Int(recipe.currStepPriority)]
                if (s.isComplete == false) {
                    playSound()
                }
            }
        }
    }
}

extension RecipeViewControllerWithTableView: UIScrollViewDelegate {
    
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
    
    //functions to hide the step button when scrolling
    func hideStepButtonAnimation() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.pauseRecipeButton.center.y = self.view.frame.maxY + 50.0
        }, completion: nil)
    }
    
    func showStepButtonAnimation() {
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.pauseRecipeButton.center.y = self.view.frame.maxY - 50.0
        }, completion: nil)
    }
}

extension RecipeViewControllerWithTableView {
    
    func didEditStep(step: StepEntity, rowToUpdate: Int) {
        let targetStep = recipe.sortStepsByPriority()[rowToUpdate]
        
        targetStep.timeRemaining = step.timeRemaining
        targetStep.timeAdjustment = 0.0
        targetStep.totalTime = step.totalTime
        targetStep.stepName = step.stepName
        
        CoreDataHandler.saveContext()
        headerView.updateHeaderNextStepTimeLabel(time: step.timeRemainingToString())
        tableView.reloadRows(at: [IndexPath(row: rowToUpdate, section: 0)], with: .none)
    }
    
    func showTimerOptions() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.pauseRecipeButton.center.y = self.view.frame.maxY + 50.0
        }, completion: nil)
    }
    
    func hideTimerOptions() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.pauseRecipeButton.center.y = self.view.frame.maxY + 50.0
        }, completion: nil)
    }
    
    func changeBottomViewStateWhileDragging() {
        guard let viewState = bottomViewState else {
            return
        }
        if (viewState == .ShowStepOptions) {
            executeBottomViewState(.ShowAddStep)
        }
    }
    
    func showBottomViewWhenCellSelected() {
        guard let viewState = bottomViewState else {
            return
        }
        
        if (viewState == .ShowAddStep) {
            executeBottomViewState(.ShowStepOptions)
        }
    }

    
    func executeBottomViewState(_ viewState: BottomViewState) {
        switch viewState {
        case .ShowStepOptions:
            hideStepButtonAnimation()
            showTimerOptions()
        case .ShowAddStep:
            hideTimerOptions()
            showStepButtonAnimation()
        }
        bottomViewState = viewState
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
        self.recipe.wasReset = true
        indexPathsToReloadArr = recipe.resetEntireRecipeTo(toStep: stepSelected)
        startTimer()
        
        let id = "\(self.recipe.recipeName!).\(self.recipe.createdDate!)"
        LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
        LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : recipe.recipeName!], timeRemaining: recipe.totalTimeRemaining)
        
        CoreDataHandler.saveContext()
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: indexPathsToReloadArr, with: .none)
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
            self.recipe.wasReset = true

            let id = "\(self.recipe.recipeName!).\(self.recipe.createdDate!)"
            if (self.recipe.isPaused) {
                //remove the notification because the recipe is paused, we don't need the notification to be pending to be delivered.
                LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            } else {
                //reset localnotification
                LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
            }
            
            self.startTimer()
            CoreDataHandler.saveContext()
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: indexPathsToReloadArr, with: .none)
                self.executeBottomViewState(.ShowAddStep)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleDismiss() {
        dismissCurrentViewController()
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
                    
                    self.bottomConstraint.constant = -self.heightForRecipeModal() - 10.0 //+ self.heightForCell()
                    self.recipeOptionsViewController.view.layer.cornerRadius = 8.0
                case RecipeOptionsState.closed:
                    
                    self.recipeOptionsViewController.view.layer.cornerRadius = 0.0
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
        let translation = recognizer.translation(in: recipeOptionsViewController.view)
        
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
    
    @objc func handleSettings() {
        if (overlayTapGestureRecognizer == nil) {
            overlayTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOverlayDismisser(recognizer:)))
            guard let tapGesture = overlayTapGestureRecognizer else {
                return
            }
            tapGesture.cancelsTouchesInView = false
            overlayView.addGestureRecognizer(tapGesture)
        }
        
        // to be looked at
        if (panGestureRecognizer == nil) {
            panGestureRecognizer = UIPanGestureRecognizer()
            guard let panGesture = panGestureRecognizer else {
                return
            }
            panGesture.delegate = recipeOptionsViewController
            panGesture.cancelsTouchesInView = false
            
            panGesture.addTarget(self, action: #selector(handleCardPan(recognizer:)))
//            recipeOptionsViewController.view.addGestureRecognizer(panGesture)
        }

        recipeOptionsVisible = true
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
    }
    
    func handleShuffle() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        
        self.tableView.isEditing = !self.tableView.isEditing
        self.headerView.saveButtonEnable()
    }
    
    func handleEditStep() {
        recipeOptionsVisible = false
        animateTransitionIfNeeded(state: recipeOptionsCurrentState)
        
        if let index = tableView.indexPathForSelectedRow {
            let selectedRow = index.row
            guard let step = viewModel?.stepArr[selectedRow] else {
                return
            }
            let vc = EditStepViewControllerInExistingRecipe(delegate: self, selectedRow: selectedRow, viewModel: AddStepViewModel(userSelectedValues: step))
            present(vc, animated: true, completion: nil)
        } else {
            print("to be compeleted - select a cell warning")
        }
    }
    
    func handleLargeDisplay() {
        largeDisplay = LargeDisplayViewController(delegate: self)

        guard let ld = largeDisplay else {
            return
        }
        ld.viewModel = LargeDisplayViewModel(delegate: largeDisplay, time: recipe.timeRemainingForCurrentStepToString(), stepName: recipe.currStepName ?? "Unknown Name", recipeName: recipe.recipeName ?? "Unknown Name", recipeEntity: recipe, sortedSet: sortedStepSet)
        present(ld, animated: true, completion: nil)
    }
    
    func dismissFullScreenDisplay() {
        dismiss(animated: true) {
            self.largeDisplay = nil
        }
    }
    
    func handleSave() {
        self.tableView.isEditing = !self.tableView.isEditing
        headerView.saveButtonDisable()
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
        
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "Step", hour: 0, min: 0, sec: 0))
        let vc = AddStepViewController(delegate: self, viewModel: viewModel)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }

    @objc func handlePauseRecipe() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        if (recipe.isPaused) {
            DispatchQueue.main.async {
                self.settingsButton.isEnabled = false
                self.settingsButton.alpha = 0.3
                self.pauseRecipeButton.updateButtonTitle(with: "Pause")
            }
            recipe.unpauseStepArr()
        } else {
            DispatchQueue.main.async {
                self.settingsButton.isEnabled = true
                self.settingsButton.alpha = 1.0
                self.pauseRecipeButton.updateButtonTitle(with: "Start")
            }
            recipe.pauseStepArr()
        }
        CoreDataHandler.saveContext()
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
