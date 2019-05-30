//
//  RecipeModalViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 27/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeOptionsModalViewModel {
    
    var theme: ThemeManager?
    
    init(theme: ThemeManager?) {
        self.theme = theme
    }
}

class RecipeOptionsModalViewController: ViewControllerBase, UIGestureRecognizerDelegate {
    
    enum OptionsMenu: Int {
        case Add
        case EditStep
        case RecipeOptions
        case Shuffle
        case Reset
        case Delete
        case Close
    }
    
    var viewModel: RecipeOptionsModalViewModel?
    
    weak var delegate: RecipeViewControllerWithTableView?
    
    let cellId = "recipeModalCellId"
    
    var dataSource = ["Add Step", "Edit Step", "Recipe Options", "Shuffle Recipe", "Reset Recipe", "Delete Recipe", "Close"]
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var handleView: UIView = {
       let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isEditRowEnabled: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(delegate: RecipeViewControllerWithTableView, viewModel: RecipeOptionsModalViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        tableView.allowsSelection = true
        tableView.rowHeight = calculateRowHeightByDevice()
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        
        handleView.layer.cornerRadius = 5.0
        view.addSubview(handleView)
        handleView.anchorView(top: view.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: .init(top: -20.0, left: 10.0, bottom: 0.0, right: -10.0), size: .init(width: 50.0, height: 9.0))
    }
    
    func isEditOptionEnabled() {
        isEditRowEnabled = true
        let cell = tableView.cellForRow(at: IndexPath(item: OptionsMenu.EditStep.rawValue, section: 0))

        cell?.isUserInteractionEnabled = isEditRowEnabled
        dataSource[OptionsMenu.EditStep.rawValue] = "Edit Step"
        DispatchQueue.main.async {
            cell?.textLabel?.attributedText = NSAttributedString(string: self.dataSource[OptionsMenu.EditStep.rawValue], attributes: self.viewModel?.theme?.currentTheme.tableView.recipeCellStepName)
            self.tableView.reloadRows(at: [IndexPath(item: OptionsMenu.EditStep.rawValue, section: 0)], with: .none)
        }
    }
    
    func calculateRowHeightByDevice() -> CGFloat {
        switch UIDevice.current.screenType.rawValue {
            case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
                return UIScreen.main.bounds.height / 14.0
            case UIDevice.ScreenType.iPhones_6_6s_7_8.rawValue:
                return UIScreen.main.bounds.height / 14.0
            case UIDevice.ScreenType.iPhoneXSMax.rawValue, UIDevice.ScreenType.iPhoneXR.rawValue, UIDevice.ScreenType.iPhoneX_iPhoneXS.rawValue:
                return UIScreen.main.bounds.height / 18.0
            default:
                return view.bounds.height / 14.0
        }
    }
}

extension RecipeOptionsModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row == OptionsMenu.EditStep.rawValue && !isEditRowEnabled) {
            dataSource[OptionsMenu.EditStep.rawValue] = "Edit Step - Please select a Step"
            cell.textLabel?.attributedText = NSAttributedString(string: dataSource[OptionsMenu.EditStep.rawValue], attributes: viewModel?.theme?.currentTheme.tableView.recipeModalOption)
            cell.textLabel?.alpha = 0.5
            cell.isUserInteractionEnabled = false
        }
        
        if (dataSource.count - 1 == indexPath.row) {
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.alpha = 0.6
            let backgroundView = UIView()
            let subview = UIView()
            subview.backgroundColor = viewModel?.theme?.currentTheme.button.backgroundColor
            subview.layer.cornerRadius = 5.0
            subview.clipsToBounds = true
            subview.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.backgroundColor = .clear
            backgroundView.addSubview(subview)
            subview.anchorView(top: backgroundView.topAnchor, bottom: backgroundView.bottomAnchor, leading: backgroundView.leadingAnchor, trailing: backgroundView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 6.0, left: 6.0, bottom: -6.0, right: -6.0), size: .zero)
            cell.backgroundView = backgroundView
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.attributedText = NSAttributedString(string: dataSource[indexPath.row], attributes: viewModel?.theme?.currentTheme.tableView.recipeModalOption)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //remove menu and perform action
        guard let option = OptionsMenu(rawValue: indexPath.row) else { return }
        
        switch option {
        case .Add:
            delegate?.handleAddStep()
        case .RecipeOptions:
            delegate?.handleRecipeOptions()
        case .Delete:
            delegate?.handleDelete()
        case .Reset:
            delegate?.handleReset()
        case .Shuffle:
            delegate?.handleShuffle()
        case .EditStep:
            delegate?.handleEditStep()
        case .Close:
            delegate?.handleClose()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
