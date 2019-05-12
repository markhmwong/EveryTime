//
//  AddRecipeMainView.swift
//  EveryTime
//
//  Created by Mark Wong on 14/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeMainView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    let stepCellId = "stepCellId"
    
    enum AddRecipeSections: Int {
        case Name
        case Settings
        case Steps
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let vm = delegate?.viewModel else {
            return
        }
        
        let sourceObj = vm.dataSource[sourceIndexPath.row]
        let destinationObj = vm.dataSource[destinationIndexPath.row]
        
        //switch dates
        let tempDestinationPriority = destinationObj.priority
        destinationObj.priority = sourceObj.priority
        sourceObj.priority = tempDestinationPriority
        
        vm.dataSource.remove(at: sourceIndexPath.row)
        vm.dataSource.insert(sourceObj, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = AddRecipeSections(rawValue: section) else {
            return 0
        }
        
        switch section {
            case AddRecipeSections.Name:
                return 1
            case AddRecipeSections.Settings:
                return 1
            case AddRecipeSections.Steps:
                guard let vm = delegate?.viewModel else {
                    return 0
                }
                return vm.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let section = AddRecipeSections(rawValue: section) else {
            return "Unknown Section"
        }
        switch section {
            case AddRecipeSections.Name:
                return "Recipe Name"
            case AddRecipeSections.Settings:
                return ""
            case AddRecipeSections.Steps:
                return "Steps"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = AddRecipeSections(rawValue: section) else {
            return "Unknown Section"
        }
        
        switch section {
        case AddRecipeSections.Name:
            return ""
        case AddRecipeSections.Settings:
            return "Change the behavior of the Recipe"
        case AddRecipeSections.Steps:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let section = AddRecipeSections(rawValue: indexPath.section) {
            guard let delegate = delegate else {
                return
            }
            
            switch section {
            case AddRecipeSections.Name:
                () //do nothing
            case AddRecipeSections.Settings:
                let recipeEntity = delegate.viewModel?.recipeEntity
                
                let vc = AddRecipeSettingsViewController(delegate: delegate, recipeEntity: recipeEntity, viewModel: AddRecipeSettingsViewModel(options: [RecipeOptions.AutoStart : "Auto Start"], theme: delegate.viewModel?.theme))
                delegate.present(vc, animated: true, completion: nil)
            case AddRecipeSections.Steps:

                
                guard let step = delegate.viewModel?.dataSource[indexPath.row] else {
                    return
                }
                let vc = EditStepViewController(delegate: delegate, selectedRow: indexPath.row, viewModel: AddStepViewModel(userSelectedValues: step, theme: delegate.viewModel?.theme))
                delegate.present(vc, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let section = AddRecipeSections(rawValue: indexPath.section) {
            switch section {
                case AddRecipeSections.Name:
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
                    recipeNameTextField = UITextField()
                    recipeNameTextField?.attributedPlaceholder = NSAttributedString(string: "An interesting name..", attributes: delegate?.viewModel?.theme?.currentTheme.tableView.mainViewStepName)
                    recipeNameTextField?.attributedText = NSAttributedString(string: "\(delegate?.viewModel?.recipeEntity.recipeName ?? "Recipe Name")", attributes: delegate?.viewModel?.theme?.currentTheme.tableView.mainViewStepName)
                    recipeNameTextField?.textAlignment = .left
                    recipeNameTextField?.translatesAutoresizingMaskIntoConstraints = false
                    cell.contentView.addSubview(recipeNameTextField!)
                    recipeNameTextField?.fillSuperView()
                    return cell
                case AddRecipeSections.Settings:
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
                    cell.textLabel?.attributedText = NSAttributedString(string: "Options", attributes: delegate?.viewModel?.theme?.currentTheme.tableView.mainViewStepName)
                    return cell
                case AddRecipeSections.Steps:
                    let cell = tableView.dequeueReusableCell(withIdentifier: stepCellId, for: indexPath) as! StepTableViewCell
                    cell.delegate = delegate
                    let step = delegate?.viewModel?.dataSource[indexPath.row]
                    cell.nameLabel.attributedText = NSAttributedString(string: "\(step?.stepName ?? "Unknown")", attributes: delegate?.viewModel?.theme?.currentTheme.tableView.mainViewStepName)
                    cell.timeLabel.attributedText = NSAttributedString(string: "\(step?.timeRemainingToString() ?? "Unknown")", attributes: delegate?.viewModel?.theme?.currentTheme.tableView.mainViewStepName)
                    cell.step = step
                    return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel!.text = "Unknown Cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let section = AddRecipeSections(rawValue: indexPath.section) {
            switch section {
            case AddRecipeSections.Name:
                return 50.0
            case AddRecipeSections.Settings:
                return 50.0
            case AddRecipeSections.Steps:
                return 70.0
            }
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == AddRecipeSections.Steps.rawValue) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let vm = delegate?.viewModel else {
                return
            }
            vm.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.isEditing = true
        view.allowsSelectionDuringEditing = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = delegate?.viewModel?.theme?.currentTheme.tableView.backgroundColor
        return view
    }()
    
    lazy var headerView: AddRecipeHeaderView = {
        let view = AddRecipeHeaderView(parentView: self)
        view.backgroundColor = Theme.Background.Color.NavTopFillBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: addStepButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "New Recipe", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.title)
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Finish", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addStepButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Add Step", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleAddStep), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: AddRecipeViewController?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var recipeNameTextField: UITextField?
    
    var theme: ThemeManager?
    
    init(delegate: AddRecipeViewController, theme: ThemeManager?) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.theme = theme
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(navView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(StepTableViewCell.self, forCellReuseIdentifier: stepCellId)
        addSubview(tableView)
        navView.addSubview(titleLabel)

        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true
        
        tableView.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        
        titleLabel.centerYAnchor.constraint(equalTo: navView.centerYAnchor, constant: 0.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    @objc func handleDismiss() {
        //check if there are steps if there aren't cancel
        //check if there are steps, and ask if the user wants to continue
        
        guard let d = delegate else {
            return
        }
        d.handleDismiss()
    }
    
    @objc func handleAddStep() {
        let priority = Int16((delegate?.viewModel?.dataSource.count)!)
        let vc = AddRecipeAddStepViewController(delegate: delegate, viewModel: AddStepViewModel(userSelectedValues: StepEntity(name: "Step \(priority)", hours: 0, minutes: 0, seconds: 0, priority: priority - 1), theme: delegate?.viewModel?.theme))
//        delegate?.modalPresentationStyle = .overCurrentContext
        delegate?.present(vc, animated: true, completion: nil)
    }
    
    func reloadTableSteps() {
//        tableView.reloadSections(IndexSet(arrayLiteral: AddRecipeSections.Steps.rawValue), with: .right)
        guard let vm = delegate?.viewModel else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: vm.dataSource.count - 1, section: AddRecipeSections.Steps.rawValue)], with: .right)
    }
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.modalPresentationStyle = .overCurrentContext
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    func showSaveAlertBox(_ message: String) {
        
        guard let delegate = delegate else {
            return
        }
        
        let alert = UIAlertController(title: "Save your Recipe?", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            delegate.saveAndDismiss()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { (action) in
            delegate.cancel()
        }))
        alert.modalPresentationStyle = .overCurrentContext
        delegate.present(alert, animated: true, completion: nil)
    }
    
    func selectedRowIndex() -> IndexPath? {
        guard let selected = tableView.indexPathForSelectedRow else {
            print("no row selected")
            return nil
        }
        
        return selected
    }
}

