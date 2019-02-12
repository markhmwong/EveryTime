//
//  RecipeViewControllerWithTableView.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewControllerWithTableView: RecipeViewControllerBase, RecipeViewControllerDelegate {
    var transitionDelegate = OverlayTransitionDelegate()
    var horizontalDelegate = HorizontalTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    let screenSize = UIScreen.main.bounds.size
    fileprivate let rowHeight: CGFloat = 80.0
    fileprivate var addButtonState: ScrollingState = .Idle

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
//    fileprivate lazy var navView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()

    fileprivate lazy var navView: NavView? = nil
    
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
    fileprivate lazy var addStepButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Add A Timer", attributes: Theme.Font.Nav.AddButton), for: .normal)
        button.addTarget(self, action: #selector(handleAddStep), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.Font.Color.AddButtonColour
        button.layer.cornerRadius = 3.0
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        return button
    }()
    fileprivate lazy var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Name"
        label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
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
        prepareViewController()
        prepareView()
        prepareAutoLayout()
        startTimer()
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        //set background color
    }
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 10))
    let titleLabel = UILabel()
    
    override func prepareView() {
        super.prepareView()
        navView = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: editButton)
        guard let nav = navView else {
            return
        }
        self.view.addSubview(nav)
        self.view.addSubview(recipeNameLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(addStepButton)
//        navView.addSubview(dismissButton)
        tableView.register(MainStepTableViewCell.self, forCellReuseIdentifier: stepCellId)
        
        //custom table view header
        headerView.backgroundColor = UIColor.clear
        titleLabel.attributedText = NSAttributedString(string: recipe.recipeName!, attributes: Theme.Font.Recipe.HeaderTableView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        tableView.tableHeaderView = headerView
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        guard let nav = navView else {
            return
        }
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            //safeAreaInsets = 44
            nav.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true
        }
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        guard let nav = navView else {
            return
        }
        
        recipeNameLabel.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        recipeNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recipeNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        nav.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nav.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nav.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        nav.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
        //nav view top anchor within updateViewConstraints()
        
        addStepButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        addStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addStepButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func handleDismiss() {
//        guard let mvc = mainViewControllerDelegate else {
//            //TODO: Error
//            return
//        }
        dismissCurrentViewController()
    }
    
    @objc func handleEdit() {
        tableView.isEditing = !tableView.isEditing
        
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
        self.tableView.reloadData()
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
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.addStepButton.center.y = self.view.frame.maxY - 50.0
            }, completion: nil)
        case .Hide:
            UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.addStepButton.center.y = self.view.frame.maxY + 50.0
            }, completion: nil)
        case .Idle:
            break
        }
    }
}


