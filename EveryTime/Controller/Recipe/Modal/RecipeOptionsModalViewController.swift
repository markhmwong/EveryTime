//
//  RecipeModalViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 27/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeOptionsModalViewController: ViewControllerBase, UIGestureRecognizerDelegate {
    
    enum OptionsMenu: Int {
        case Add
        case Edit
        case Shuffle
        case Reset
        case Delete
        case Close
    }
    
    weak var delegate: RecipeViewControllerWithTableView?
    
    let cellId = "recipeModalCellId"
    
    var dataSource = ["Add Step", "Edit Step", "Shuffle", "Reset", "Delete", "Close"]
    
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
    
    convenience init(delegate: RecipeViewControllerWithTableView) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
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
        tableView.rowHeight = 55.0
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
        let cell = tableView.cellForRow(at: IndexPath(item: OptionsMenu.Edit.rawValue, section: 0))

        cell?.isUserInteractionEnabled = isEditRowEnabled
        dataSource[OptionsMenu.Edit.rawValue] = "Edit Step"
        DispatchQueue.main.async {
            cell?.textLabel?.attributedText = NSAttributedString(string: self.dataSource[OptionsMenu.Edit.rawValue], attributes: Theme.Font.Nav.Item)
            self.tableView.reloadRows(at: [IndexPath(item: OptionsMenu.Edit.rawValue, section: 0)], with: .none)
        }
    }
}

extension RecipeOptionsModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row == OptionsMenu.Edit.rawValue && !isEditRowEnabled) {
            dataSource[OptionsMenu.Edit.rawValue] = "Edit Step - Select A Step"
            cell.textLabel?.attributedText = NSAttributedString(string: dataSource[OptionsMenu.Edit.rawValue], attributes: Theme.Font.Nav.Item)
            cell.textLabel?.alpha = 0.7
            cell.isUserInteractionEnabled = false
        }
        
        if (dataSource.count - 1 == indexPath.row) {
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.alpha = 0.7
            let backgroundView = UIView()
            let subview = UIView()
            subview.backgroundColor = Theme.Font.Color.StandardButtonColor
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
        cell.textLabel?.attributedText = NSAttributedString(string: dataSource[indexPath.row], attributes: Theme.Font.Nav.Item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //remove menu and perform action
        print("didselect")
        guard let option = OptionsMenu(rawValue: indexPath.row) else { return }
        
        switch option {
        case .Add:
            delegate?.handleAddStep()
        case .Delete:
            delegate?.handleDelete()
        case .Reset:
            delegate?.handleReset()
        case .Shuffle:
            delegate?.handleShuffle()
        case .Edit:
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
