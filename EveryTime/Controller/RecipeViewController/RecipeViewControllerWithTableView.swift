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
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var bottomViewState: BottomViewState?
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate let rowHeight: CGFloat = 120.0
    fileprivate var addButtonState: ScrollingState = .Idle
    fileprivate var stepSelected: Int = 0
    fileprivate lazy var navView: NavView? = nil
    fileprivate var headerView: UIView?
    fileprivate var step: StepEntity?

    fileprivate lazy var tableView: UITableView = {
        let view: UITableView = UITableView()
        view.delegate = self
        view.isEditing = false
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
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
    fileprivate lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Settings", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.0
        button.layer.cornerRadius = 5.0
        button.layer.backgroundColor = UIColor.green.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        return button
    }()
    
    fileprivate lazy var addStepButton: StandardButton = {
        let button = StandardButton(title: "Add Step")
        button.addTarget(self, action: #selector(handleAddStep), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var additionalTimeButton: StandardButton = {
        let button = StandardButton(title: "+15")
        button.addTarget(self, action: #selector(handleAdditionalTime), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var subtractTimeButton: StandardButton = {
        let button = StandardButton(title: "-15")
        button.addTarget(self, action: #selector(handleMinusTime), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var resetTimeButton: StandardButton = {
        let button = StandardButton(title: "Reset")
        button.addTarget(self, action: #selector(handleResetStepTime), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var headerStepTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var headerStepTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var headerNextStepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var headerNextStepTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var headerNextStepTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var border: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var paddedView: UIView!

    
    init(recipe: RecipeEntity, delegate: MainViewController, indexPath: IndexPath) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewControllerDelegate = delegate
        self.recipe = recipe
        self.stepSet = recipe.step as? Set<StepEntity>
        self.stepArr = recipe.sortStepsByPriority()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        setNeedsStatusBarAppearanceUpdate()
        bottomViewState = .ShowAddStep
    }


    override func prepareView() {
        super.prepareView()
        
        if (UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_6Plus_6sPlus_7Plus_8Plus.rawValue || UIDevice.current.screenType.rawValue ==  UIDevice.ScreenType.iPhones_6_6s_7_8.rawValue) {
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3.0))
        } else {
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3.5))
        }
        
        
        guard let headerView = headerView else {
            return
        }
        if (recipe.isPaused) {
            editButton.isEnabled = true
        } else {
            editButton.isEnabled = false
            editButton.alpha = 0.3
        }
        
        additionalTimeButton.isEnabled = false
        additionalTimeButton.alpha = 0.4
        resetTimeButton.isEnabled = false
        resetTimeButton.alpha = 0.4
        subtractTimeButton.isEnabled = false
        subtractTimeButton.alpha = 0.4

        paddedView = UIView()
        navView = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: editButton)
        guard let nav = navView else {
            return
        }
        view.addSubview(nav)
        view.addSubview(tableView)
        view.addSubview(addStepButton)
        
        paddedView.translatesAutoresizingMaskIntoConstraints = false
        paddedView.backgroundColor = UIColor.white
        paddedView.layer.cornerRadius = 8.0
        headerView.addSubview(paddedView)


        //custom table view header
        headerView.backgroundColor = UIColor.clear
        headerTitleLabel.attributedText = NSAttributedString(string: recipe.recipeName ?? "No name", attributes: Theme.Font.Recipe.HeaderTableView)
        headerView.addSubview(headerTitleLabel)
        headerStepTimeLabel.attributedText = NSAttributedString(string: "00h 00m 00s" , attributes: Theme.Font.Recipe.HeaderTableViewContent)
        headerView.addSubview(headerStepTimeLabel)
        headerStepTitleLabel.attributedText = NSAttributedString(string: recipe.currStepName ?? " ", attributes: Theme.Font.Recipe.HeaderTableViewContent)
        headerView.addSubview(headerStepTitleLabel)
        headerNextStepTitleLabel.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.HeaderTableViewContent)
        headerView.addSubview(headerNextStepTitleLabel)
        headerNextStepTimeLabel.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.HeaderTableViewContent)
        headerView.addSubview(headerNextStepTimeLabel)
        headerNextStepLabel.attributedText = NSAttributedString(string: "Next Step", attributes: Theme.Font.Recipe.HeaderTableViewContentSubTitle)
        headerView.addSubview(headerNextStepLabel)
        
        paddedView.addSubview(additionalTimeButton)
        paddedView.addSubview(subtractTimeButton)
        paddedView.addSubview(resetTimeButton)
        //save button in header
        headerView.addSubview(saveButton)
        tableView.tableHeaderView = headerView
        
        headerView.backgroundColor = UIColor.clear
    
        tableView.register(RecipeViewCell.self, forCellReuseIdentifier: stepCellId)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.view.safeAreaInsets
            
            guard let nav = navView else {
                return
            }
            nav.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }

    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        guard let nav = navView, let headerView = headerView else {
            return
        }

        tableView.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).identifier = "tableview bottomanchor"
        
        headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        headerTitleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15).isActive = true
        
        headerStepTimeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30).isActive = true
        headerStepTimeLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 20).isActive = true
        
        headerStepTitleLabel.leadingAnchor.constraint(equalTo: headerStepTimeLabel.leadingAnchor).isActive = true
        headerStepTitleLabel.topAnchor.constraint(equalTo: headerStepTimeLabel.bottomAnchor, constant: 0.0).isActive = true
        
        headerNextStepLabel.leadingAnchor.constraint(equalTo: headerStepTitleLabel.leadingAnchor).isActive = true
        headerNextStepLabel.topAnchor.constraint(equalTo: headerStepTitleLabel.bottomAnchor, constant: 10.0).isActive = true
        
        headerNextStepTimeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30).isActive = true
        headerNextStepTimeLabel.topAnchor.constraint(equalTo: headerNextStepLabel.bottomAnchor, constant: 10).isActive = true
        
        headerNextStepTitleLabel.leadingAnchor.constraint(equalTo: headerNextStepTimeLabel.leadingAnchor).isActive = true
        headerNextStepTitleLabel.topAnchor.constraint(equalTo: headerNextStepTimeLabel.bottomAnchor, constant: 0.0).isActive = true
        
        additionalTimeButton.trailingAnchor.constraint(equalTo: paddedView.leadingAnchor, constant: (screenSize.width / 8) * 2).isActive = true
        additionalTimeButton.bottomAnchor.constraint(equalTo: paddedView.bottomAnchor, constant: -10).isActive = true
        additionalTimeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.18).isActive = true
        
        resetTimeButton.centerXAnchor.constraint(equalTo: paddedView.centerXAnchor, constant: 0).isActive = true
        resetTimeButton.bottomAnchor.constraint(equalTo: paddedView.bottomAnchor, constant: -10).isActive = true
        resetTimeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.18).isActive = true

        subtractTimeButton.leadingAnchor.constraint(equalTo: paddedView.trailingAnchor, constant: -(screenSize.width / 8) * 2).isActive = true
        subtractTimeButton.bottomAnchor.constraint(equalTo: paddedView.bottomAnchor, constant: -10).isActive = true
        subtractTimeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.18).isActive = true

        saveButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true
        saveButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        
        if (!appDelegate.hasTopNotch) {
            nav.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        nav.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nav.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nav.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Theme.View.Nav.Height).isActive = true
        nav.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
        //nav view top anchor within updateViewConstraints()
        
        addStepButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        addStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addStepButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
        
        paddedView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10.0).isActive = true
        paddedView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10.0).isActive = true
        paddedView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10.0).isActive = true
        paddedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0).isActive = true //there's a warning if we use the headerView.trailingAnchor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func modifyTime(_ seconds: Double) {
//        let id = "\(self.recipe.recipeName!).\(self.recipe.createdDate!)"
//        LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
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
            mvc.startTimer()
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
        return view.bounds.height / 13
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //issue when deleting the running timer, the time passed persists to the next step
            //we alter the startDate
            if (indexPath.row == recipe.currStepPriority) {
                let sortedSet = recipe.sortStepsByPriority()
                let timeElapsedInStep = sortedSet[indexPath.row].totalTime - recipe.currStepTimeRemaining
                recipe.startDate?.addTimeInterval(timeElapsedInStep)
            }
            
            
            let id = "\(recipe.recipeName!).\(recipe.createdDate!)"
            recipe.removeFromStep(stepArr[indexPath.row])
            stepArr.remove(at: indexPath.row)
            recipe.reoganiseStepsInArr(fromIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            recipe.sumStepsForExpectedElapsedTime()
            LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : recipe.recipeName!], timeRemaining: recipe.totalTimeRemaining)
            CoreDataHandler.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        additionalTimeButton.isEnabled = true
        resetTimeButton.isEnabled = true
        subtractTimeButton.isEnabled = true
        DispatchQueue.main.async {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.additionalTimeButton.alpha = 1.0
            self.resetTimeButton.alpha = 1.0
            self.subtractTimeButton.alpha = 1.0
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
            
            let sortedSet = recipe.sortStepsByPriority()
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
                        self.headerNextStepTimeLabel.attributedText = NSAttributedString(string: nextStep.timeRemainingToString(), attributes: Theme.Font.Recipe.HeaderTableViewContent)
                        self.headerNextStepTitleLabel.attributedText = NSAttributedString(string: nextStep.stepName ?? "unknown", attributes: Theme.Font.Recipe.HeaderTableViewContentTitle)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.headerNextStepTimeLabel.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.HeaderTableViewContent)
                            self.headerNextStepTitleLabel.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.HeaderTableViewContentTitle)
                        }
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.headerStepTimeLabel.attributedText = NSAttributedString(string: step.timeRemainingToString(), attributes: Theme.Font.Recipe.HeaderTableViewContent)
                        self.headerStepTitleLabel.attributedText = NSAttributedString(string: step.stepName ?? "unknown", attributes: Theme.Font.Recipe.HeaderTableViewContentTitle)
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
            self.addStepButton.center.y = self.view.frame.maxY + 50.0
        }, completion: nil)
    }
    
    func showStepButtonAnimation() {
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.addStepButton.center.y = self.view.frame.maxY - 50.0
        }, completion: nil)


    }
}

extension RecipeViewControllerWithTableView {
    
    func showTimerOptions() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.addStepButton.center.y = self.view.frame.maxY + 50.0
        }, completion: nil)
        
    }
    
    func hideTimerOptions() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.addStepButton.center.y = self.view.frame.maxY + 50.0
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
        let alert = UIAlertController(title: "Are you sure?", message: "Reset cannot be undone", preferredStyle: .alert)
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
        
        let optionMenu = UIAlertController(title: "Recipe Options", message: "These options affect the recipe as whole.", preferredStyle: .actionSheet)
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
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.tableView.isEditing = !self.tableView.isEditing
            self.saveButton.alpha = 1.0
            self.saveButton.isEnabled = true
        }
        
        optionMenu.addAction(editAction)
        optionMenu.addAction(resetAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        self.tableView.isEditing = !self.tableView.isEditing
        saveButton.alpha = 0.0
        saveButton.isEnabled = false
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
    
    @objc func handleAdditionalTime() {
        let seconds = 15.0
        modifyTime(seconds)
    }
    
    @objc func handleMinusTime() {
        let seconds = -15.0
        modifyTime(seconds)
    }
}
