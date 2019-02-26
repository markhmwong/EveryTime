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
    case StepOptions
    case AddStep
}

class RecipeViewControllerWithTableView: RecipeViewControllerBase, RecipeViewControllerDelegate {
    var transitionDelegate = OverlayTransitionDelegate()
    var horizontalDelegate = HorizontalTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    
    fileprivate var bottomViewState: BottomViewState?
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate let rowHeight: CGFloat = 120.0
    fileprivate var addButtonState: ScrollingState = .Idle
    fileprivate var stepSelected: Int = 0
    fileprivate lazy var navView: NavView? = nil
    fileprivate let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 10))

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
        button.setAttributedTitle(NSAttributedString(string: "Edit", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Delete", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    fileprivate lazy var addStepButton: StandardButton = {
        let button = StandardButton(title: "Add Step")
        button.addTarget(self, action: #selector(handleAddStep), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let resetButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Reset", attributes: Theme.Font.Nav.Item), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        return button
    }()
    
    fileprivate let timerOptionsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let extraOptionsAddTime: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "+15s", attributes: Theme.Font.Recipe.TextFieldAttribute), for: .normal)
        button.addTarget(self, action: #selector(handleAdditionalTime), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let extraOptionsResetTime: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Reset", attributes: Theme.Font.Recipe.TextFieldAttribute), for: .normal)
        button.addTarget(self, action: #selector(handleResetStepTime), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let extraOptionsMinusTime: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "-15s", attributes: Theme.Font.Recipe.TextFieldAttribute), for: .normal)
        button.addTarget(self, action: #selector(handleMinusTime), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let timerOptionsViewTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Step Options", attributes: Theme.Font.Recipe.StepSubTitle)
        return label
    }()
    
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
        bottomViewState = .AddStep
    }
    fileprivate lazy var border: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view

    }()

    override func prepareView() {
        super.prepareView()
        
        if (recipe.isPaused) {
            editButton.isEnabled = true
        } else {
            editButton.isEnabled = false
            editButton.alpha = 0.3
            
        }
        
        navView = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: editButton)
        guard let nav = navView else {
            return
        }
        view.addSubview(nav)
        view.addSubview(tableView)
        view.addSubview(addStepButton)
        view.addSubview(timerOptionsView)
        
        timerOptionsView.addSubview(border)
        timerOptionsView.addSubview(timerOptionsViewTitle)
        timerOptionsView.addSubview(extraOptionsAddTime)
        timerOptionsView.addSubview(extraOptionsResetTime)
        timerOptionsView.addSubview(extraOptionsMinusTime)
        
        //custom table view header
        headerView.backgroundColor = UIColor.clear
        titleLabel.attributedText = NSAttributedString(string: recipe.recipeName ?? "No name", attributes: Theme.Font.Recipe.HeaderTableView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(resetButton)
        tableView.tableHeaderView = headerView
        
        tableView.register(MainStepTableViewCell.self, forCellReuseIdentifier: stepCellId)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        guard let nav = navView else {
            return
        }
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            //safeAreaInsets = 44
            nav.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets.top).isActive = true
        }
    }

    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        guard let nav = navView else {
            return
        }

        tableView.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).identifier = "tableview bottomanchor"
        
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        resetButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        nav.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nav.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nav.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        nav.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
        //nav view top anchor within updateViewConstraints()
        
        addStepButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        addStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addStepButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true

        timerOptionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timerOptionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        timerOptionsView.heightAnchor.constraint(equalToConstant: screenSize.height / 7.5).isActive = true
        timerOptionsView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        timerOptionsViewTitle.centerXAnchor.constraint(equalTo: timerOptionsView.centerXAnchor).isActive = true
        timerOptionsViewTitle.topAnchor.constraint(equalTo: timerOptionsView.topAnchor, constant: 10).isActive = true
        
        extraOptionsAddTime.trailingAnchor.constraint(equalTo: timerOptionsView.leadingAnchor, constant: (screenSize.width / 8) * 2).isActive = true
        extraOptionsAddTime.centerYAnchor.constraint(equalTo: timerOptionsView.centerYAnchor).isActive = true
        
        extraOptionsMinusTime.leadingAnchor.constraint(equalTo: timerOptionsView.trailingAnchor, constant: -(screenSize.width / 8) * 2).isActive = true
        extraOptionsMinusTime.centerYAnchor.constraint(equalTo: timerOptionsView.centerYAnchor).isActive = true
        extraOptionsResetTime.centerXAnchor.constraint(equalTo: timerOptionsView.centerXAnchor, constant: 0).isActive = true
        extraOptionsResetTime.centerYAnchor.constraint(equalTo: timerOptionsView.centerYAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo: timerOptionsView.topAnchor).isActive = true
        border.leadingAnchor.constraint(equalTo: timerOptionsView.leadingAnchor).isActive = true
        border.trailingAnchor.constraint(equalTo: timerOptionsView.trailingAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func modifyTime(_ seconds: Double) {
        do {
            try recipe.adjustTime(by: seconds, selectedStep: stepSelected)
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

        if (currIndex < maxItems) {
            let nextEntity = stepArr[currIndex + 1]
            
            guard let r = recipe else {
                return
            }
            playSound()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellId, for: indexPath) as! MainStepTableViewCell
        cell.entity = stepArr[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 10
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            recipe.removeFromStep(stepArr[indexPath.row])
            stepArr.remove(at: indexPath.row)
            recipe.reoganiseStepsInArr(fromIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        stepSelected = indexPath.row
        let step = stepArr[stepSelected]
        if (step.isComplete) {
            DispatchQueue.main.async {
                self.extraOptionsResetTime.alpha = 1.0
                self.extraOptionsResetTime.isEnabled = true
            }
        } else {
            // can't reset a step that has not begun yet. that's skipping steps.
            DispatchQueue.main.async {
                self.extraOptionsResetTime.alpha = 0.4
                self.extraOptionsResetTime.isEnabled = false
            }
        }
        
        showBottomViewWhenCellSelected()
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
        //updates specific cell only
        if (!recipe.isPaused) {
            let visibleCellIndexPaths = self.tableView.indexPathsForVisibleRows?.sorted { (x, y) -> Bool in
                return x < y
            }
            
            guard let visibleCell = visibleCellIndexPaths else {
                return
            }
            
            let stepPriorityToUpdate = Int(recipe.currStepPriority) //when parallel timers are enabled, we'll update multiple timers
            let currPriorityIndexPath = IndexPath(item: stepPriorityToUpdate, section: 0)
            
            //updating current leading step entity
            //on screen
            let s = stepArr[stepPriorityToUpdate]
            if (s.timeRemaining.isLessThanOrEqualTo(0.0) && s.isComplete == true) {
                //to next step
                updateCurrentStep(step: s) //because the current active step is no longer valid
                updateNewLeadingTimer(indexPath: currPriorityIndexPath)
            } else {
                s.updateTotalTimeRemaining()
            }
            
            if (visibleCell.contains(IndexPath(item: stepPriorityToUpdate, section: 0))) {
                let stepCell = tableView.cellForRow(at: currPriorityIndexPath) as! MainStepTableViewCell
                DispatchQueue.main.async {
                    stepCell.updateTimeLabel(time:s.timeRemainingToString())
                    stepCell.updateCompletionStatusLabel()
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
        let height = screenSize.height / 7.5
        let distance = (height / 2  )
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.addStepButton.center.y = self.view.frame.maxY + 50.0
            self.timerOptionsView.center.y = self.view.frame.maxY - distance
        }, completion: nil)
    }
    
    func hideTimerOptions() {
        let height = screenSize.height / 7.5
        let distance = (height / 2  )
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.addStepButton.center.y = self.view.frame.maxY + 50.0
            self.timerOptionsView.center.y = self.view.frame.maxY + distance
        }, completion: nil)
    }
    
    func changeBottomViewStateWhileDragging() {
        guard let viewState = bottomViewState else {
            return
        }
        if (viewState == .StepOptions) {
            print("addstep")
            executeBottomViewState(.AddStep)
        }
    }
    
    func changeBottomViewState() {
        guard let viewState = bottomViewState else {
            return
        }
        switch viewState {
        case .StepOptions:
            bottomViewState = .AddStep
            executeBottomViewState(bottomViewState!)
        case .AddStep:
            bottomViewState = .StepOptions
            executeBottomViewState(bottomViewState!)
        }
    }
    
    func showBottomViewWhenCellSelected() {
        guard let viewState = bottomViewState else {
            return
        }
        
        if (viewState == .AddStep) {
            executeBottomViewState(.StepOptions)
        }
    }

    
    func executeBottomViewState(_ viewState: BottomViewState) {
        switch viewState {
        case .StepOptions:
            hideStepButtonAnimation()
            showTimerOptions()
        case .AddStep:
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
    @objc func handleResetStepTime() {
        recipe.resetEntireRecipeTo(toStep: stepSelected)
        CoreDataHandler.saveContext()
        var indexPathArr: [IndexPath] = []
        DispatchQueue.main.async {
            
            for i in self.stepSelected..<self.stepArr.count {
                indexPathArr.append(IndexPath(row: i, section: 0))
            }
            self.tableView.reloadRows(at: indexPathArr, with: .none)
        }
    }
    
    /**
     # Full Recipe reset
     */
    @objc func handleReset() {
        recipe.resetEntireRecipeTo()
        recipe.wasReset = true
        CoreDataHandler.saveContext()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func handleDismiss() {
        dismissCurrentViewController()
    }
    
    @objc func handleEdit() {
        tableView.isEditing = !tableView.isEditing
        if (tableView.isEditing) {
            CoreDataHandler.saveContext()
            DispatchQueue.main.async {
                self.editButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: Theme.Font.Nav.Item), for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                self.editButton.setAttributedTitle(NSAttributedString(string: "Edit", attributes: Theme.Font.Nav.Item), for: .normal)
            }
        }
    }
    
    @objc func handleDelete() {
        dismiss(animated: true) {
            //
            guard let mvc = mainViewControllerDelegate {
                return
            }
            mvc.handleDeleteRecipe()
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
    
    @objc func handleAdditionalTime() {
        let seconds = 15.0
        modifyTime(seconds)
    }
    
    @objc func handleMinusTime() {
        let seconds = -15.0
        modifyTime(seconds)
    }
}
