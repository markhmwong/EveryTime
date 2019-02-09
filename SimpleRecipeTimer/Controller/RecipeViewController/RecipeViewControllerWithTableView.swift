//
//  RecipeViewControllerWithTableView.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewControllerWithTableView: RecipeViewControllerBase {
    fileprivate let rowHeight: CGFloat = 80.0
    var transitionDelegate = OverlayTransitionDelegate()
    var horizontalDelegate = HorizontalTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    
    fileprivate lazy var tableView: UITableView = {
        let view: UITableView = UITableView()
        view.delegate = self
        view.isEditing = true
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
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
        prepareViewController()
        prepareView()
        prepareAutoLayout()
        startTimer()
    }
    
    override func prepareViewController() {
        super.prepareViewController()
    }
    
    override func prepareView() {
        super.prepareView()
        self.view.addSubview(navView)
        self.view.addSubview(tableView)
        navView.addSubview(dismissButton)
        tableView.register(MainStepTableViewCell.self, forCellReuseIdentifier: stepCellId)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            //safeAreaInsets = 44
            navView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true
        }
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        
        dismissButton.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 10).isActive = true
        
        tableView.topAnchor.constraint(equalTo: navView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        navView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
        //top anchor within updateViewConstraints()
    }
    
    @objc func handleDismiss() {
        guard let mvc = mainViewControllerDelegate else {
            //TODO: Error
            return
        }
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
            nextEntity.isLeading = true
            nextEntity.isComplete = false
            nextEntity.updateExpiry()
            r.updateStepInRecipe(nextEntity)
        }
    }
}

extension RecipeViewControllerWithTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceObj = self.stepArr[sourceIndexPath.row]
        let destinationObj = self.stepArr[destinationIndexPath.row]
        
        //switch dates
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
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
        
            stepArr.remove(at: indexPath.row)
            recipe.reoganiseStepsInArr(stepArr, fromIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
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
            
            let stepPriorityToUpdate = Int(recipe.currStepPriority) //when parallel timers are enabled, we'll update multiple times
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
