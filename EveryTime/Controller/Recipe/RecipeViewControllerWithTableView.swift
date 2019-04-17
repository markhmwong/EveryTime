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

class RecipeViewControllerWithTableView: RecipeViewControllerBase, RecipeViewControllerDelegate {
    
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
    
    init(recipe: RecipeEntity, delegate: MainViewController, indexPath: IndexPath) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewControllerDelegate = delegate
        self.recipe = recipe
        self.stepSet = recipe.step as? Set<StepEntity>
        self.stepArr = recipe.sortStepsByPriority()
        self.indexPathSelectedFromMainView = indexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
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
        
        let sortedSet = recipe.sortStepsByPriority()
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
                self.pauseRecipeButton.updateButtonTitle(with: "Unpause")
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
        return stepArr.count
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
            let nextEntity = stepArr[currIndex + 1]
            nextEntity.isLeading = true
            nextEntity.isComplete = false
            nextEntity.updateExpiry()
            r.updateStepInRecipe(nextEntity)
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
        step.priority = Int16(stepArr.count)
        self.recipe.addToStep(step)
        self.stepArr.append(step)
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
            self.recipe.removeFromStep(self.stepArr[indexPath.row])
            self.stepArr.remove(at: indexPath.row)
            self.recipe.reoganiseStepsInArr(fromIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.recipe.sumStepsForExpectedElapsedTime()
            LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
            CoreDataHandler.saveContext()
            complete(true)
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
        let sourceObj = self.stepArr[sourceIndexPath.row]
        let destinationObj = self.stepArr[destinationIndexPath.row]
        
        let tempDestinationPriority = destinationObj.priority
        destinationObj.priority = sourceObj.priority
        sourceObj.priority = tempDestinationPriority
        
        stepArr.remove(at: sourceIndexPath.row)
        stepArr.insert(sourceObj, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellId, for: indexPath) as! RecipeViewCell
        cell.entity = stepArr[indexPath.item]
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
        step = stepArr[stepSelected]

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        changeBottomViewStateWhileDragging()
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
    
    @objc func handleSettings() {
        let optionMenu = UIAlertController(title: "Recipe Options", message: "These options affect the recipe as a whole.", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
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
            self.present(alert, animated: true, completion: nil)
        }
        let resetAction = UIAlertAction(title: "Reset", style: .default) { (action) in
            self.handleReset()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let editAction = UIAlertAction(title: "Shuffle Steps", style: .default) { (action) in
            self.tableView.isEditing = !self.tableView.isEditing
            self.headerView.saveButtonEnable()
        }
        let addStepAction = UIAlertAction(title: "Add Step", style: .default) { (action) in
            //add step
            self.handleAddStep()
        }

        optionMenu.addAction(addStepAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(resetAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
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

    func handleAddStep() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "Step", hour: 0, min: 0, sec: 0))
        let vc = AddStepViewController(delegate: self, viewModel: viewModel)
//        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .overCurrentContext
//        dismissInteractor = OverlayInteractor()
//        dismissInteractor.attachToViewController(viewController: vc, withView: vc.view, presentViewController: nil)
//        vc.interactor = dismissInteractor
//        transitionDelegate.dismissInteractor = dismissInteractor
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
                self.pauseRecipeButton.updateButtonTitle(with: "Unpause")
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
