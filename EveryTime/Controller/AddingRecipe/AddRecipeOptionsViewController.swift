//
//  ADDRecipeSettingsViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 14/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum RecipeOptions: Int {
    case AutoStart
    //pause between steps
}

extension AddRecipeOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let rowSettings = RecipeOptions(rawValue: indexPath.row)
        cell.textLabel!.text = viewModel.options[rowSettings!]
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(!(recipeEntity!.isPaused), animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(handleSwitchChanged), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitle
    }
}

class AddRecipeOptionsViewController: UIViewController {

    var recipeEntity: RecipeEntity?
    
    let sectionHeaderTitle = "Options"
    
    let cellId = "cellId"
    
    var viewModel: AddRecipeSettingsViewModel = AddRecipeSettingsViewModel(options: [RecipeOptions.AutoStart : "Auto Start"])
    
    weak var delegate: AddRecipeViewController_B?
    
    lazy var tableView: UITableView = {
       let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Options", attributes: Theme.Font.Nav.Title)
        return label
    }()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(delegate: AddRecipeViewController_B, recipeEntity: RecipeEntity?) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.recipeEntity = recipeEntity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.addSubview(navView)
        navView.addSubview(titleLabel)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        let navTopConstraint = !appDelegate.hasTopNotch ? view.topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightByNotch).isActive = true
        tableView.anchorView(top: navView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        titleLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: navView.centerYAnchor, centerX: navView.centerXAnchor, padding: .zero, size: .zero)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.view.safeAreaInsets
            navView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
        
    }
    
    @objc func handleDismiss() {
        delegate?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSwitchChanged(_ sender : UISwitch) {
        print(sender.isOn)
        
        let settingType = RecipeOptions(rawValue: sender.tag)!
        
        switch settingType {
        case RecipeOptions.AutoStart:
            //set recipe entity auto start option
            recipeEntity?.isPaused = !sender.isOn
        }
        
    }
}
