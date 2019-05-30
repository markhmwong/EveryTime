//
//  RecipeEditViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 26/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeEditViewController: ViewControllerBase {
    
    weak var delegate: RecipeViewControllerWithTableView?
    
    var viewModel: RecipeEditViewModel?
    
    lazy var mainView: RecipeEditView = {
        let view = RecipeEditView(delegate: self)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(delegate: RecipeViewControllerWithTableView, viewModel: RecipeEditViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.fillSuperView()
        
    }
    
    func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    func dismissCurrentViewController() {
        dismiss(animated: true, completion: nil)
    }
}

class RecipeEditViewModel {
    
    var recipe: RecipeEntity
    
    var cellId: String = "recipeOptionCellId"
    
    var theme: ThemeManager
    
    init(recipe: RecipeEntity, theme: ThemeManager) {
        self.recipe = recipe
        self.theme = theme
    }
    
}

class RecipeEditView: UIView {
    
    weak var delegate: RecipeEditViewController?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    enum OptionsSection: Int, CaseIterable {
        //        case colour
        case Name
        case Color
//        case Sound
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil,titleLabel: titleLabel, topScreenAnchor: self.topAnchor)
        view.backgroundFillerColor(color: delegate?.viewModel?.theme.currentTheme.navigation.backgroundColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Edit Recipe", attributes: delegate?.viewModel?.theme.currentTheme.navigation.title)
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: delegate?.viewModel?.theme.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: RecipeEditViewController) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        guard let vm = delegate?.viewModel else { return }
        addSubview(tableView)
        addSubview(navView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: vm.cellId)
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true
        
        tableView.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)

    }
    
    @objc func handleDismiss() {
        
        saveRecipe()
        
        guard let d = delegate else {
            return
        }
        d.handleDismiss()
    }
    
    func saveRecipe() {
        guard let vm = delegate?.viewModel else { return }
        vm.recipe.recipeName = nameTextField.text
        CoreDataHandler.saveContext()
    }
}

extension RecipeEditView: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return OptionsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sectionNumber = OptionsSection.init(rawValue: section) {
            switch sectionNumber {
            case OptionsSection.Name:
                return "Recipe Name"
            case OptionsSection.Color:
                return "Recipe Colour"
//            case OptionsSection.Sound:
//                return "Sound"
            }
        }
        return "unknown section"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let viewModel = delegate?.viewModel else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeOptionCellId", for: indexPath)
            cell.textLabel?.text = "error with viewmodel"
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellId, for: indexPath)
        
        if (indexPath.section == OptionsSection.Name.rawValue) {
            nameTextField.attributedPlaceholder = NSAttributedString(string: "An interesting name..", attributes: viewModel.theme.currentTheme.tableView.mainViewStepName)
            nameTextField.attributedText = NSAttributedString(string: "\(viewModel.recipe.recipeName ?? "Recipe Name")", attributes: viewModel.theme.currentTheme.tableView.mainViewStepName)
            nameTextField.defaultTextAttributes = viewModel.theme.currentTheme.tableView.mainViewStepName
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(nameTextField)
            nameTextField.anchorView(top: cell.topAnchor, bottom: cell.bottomAnchor, leading: cell.leadingAnchor, trailing: cell.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: .zero)
        }
        
        if (indexPath.section == OptionsSection.Color.rawValue) {
            cell.accessoryType = .disclosureIndicator
            let view = UIView()
            view.backgroundColor = delegate?.viewModel?.recipe.colorUnarchive()
            view.translatesAutoresizingMaskIntoConstraints = false
            cell.backgroundView = view
            view.anchorView(top: cell.topAnchor, bottom: cell.bottomAnchor, leading: cell.leadingAnchor, trailing: cell.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 15.0, left: 20.0, bottom: -15.0, right: -80.0), size: CGSize(width: 0, height: 40))
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        if (indexPath.section == OptionsSection.Color.rawValue) {
            let vc = RecipeColorViewController(delegate: delegate, viewModel: RecipeColorViewModel(theme: delegate.viewModel!.theme, recipe: delegate.viewModel!.recipe))
            delegate.present(vc, animated: true, completion: nil)
        }
    }
}
