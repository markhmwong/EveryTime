//
//  ThemeViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ThemeViewController: ViewControllerBase {
    
    weak var delegate: SettingsViewController?
    
    var viewModel: ThemeViewModel?
    
    private lazy var mainView: ThemeView = {
        let view = ThemeView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(delegate: SettingsViewController, viewModel: ThemeViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func prepareViewController() {
        super.prepareViewController()
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
        
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.fillSuperView()
    }
    
    func handleDismiss() {
        delegate?.mainView.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func changeTheme(indexPath: IndexPath) {
        guard let vm = viewModel else {
            return
        }
        vm.applyNewTheme(indexPath: indexPath)
    }
    
    /// Other views do refresh beecause UIAppearance only affects views that are about to appear,
    /// this current view must be refreshed in order to reflect the updated theme
    func refreshView() {
        mainView.removeFromSuperview()
        mainView = ThemeView(delegate: self)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)
        mainView.fillSuperView()
        view.layoutIfNeeded()
    }
}
