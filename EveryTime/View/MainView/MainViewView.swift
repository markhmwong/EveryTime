//
//  MainViewView.swift
//  EveryTime
//
//  Created by Mark Wong on 22/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewView: UIView {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var player: AVAudioPlayer?
    
    private var delegate: MainViewController!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var rightNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: delegate.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var leftNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Settings", attributes: delegate.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: Bundle.appName(), attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item)
        return label
    }()
    
    lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: leftNavItemButton, rightNavItem: rightNavItemButton, titleLabel: appNameLabel, topScreenAnchor: self.topAnchor)
        view.backgroundFillerColor(color: delegate?.viewModel?.theme?.currentTheme.navigation.backgroundColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Test data button
//    private lazy var leftNavItemButtonTest: UIButton = {
//        let button = UIButton()
//        button.setAttributedTitle(NSAttributedString(string: "Test Random Data", attributes: Theme.Font.Nav.Item), for: .normal)
//        button.addTarget(self, action: #selector(handleTest), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = delegate
        view.delegate = delegate
        view.dragInteractionEnabled = true
        view.backgroundColor = delegate?.viewModel?.theme?.currentTheme.tableView.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: MainViewController) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
        self.setupAutoLayout()
    }
    
    func setupView() {
        guard let theme = delegate?.viewModel?.theme else {
            return
        }
        theme.currentTheme.applyTheme()
        backgroundColor = theme.currentTheme.generalBackgroundColour
        addSubview(collView)
        addSubview(navView)
        collView.register(MainViewCell.self, forCellWithReuseIdentifier: CollectionCellIds.RecipeCell.rawValue)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets

            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    func setupNavViewLayout() {
        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: collView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true

    }

    func setupAutoLayout() {
        setupNavViewLayout()
        collView.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
    }
    
    func refreshNavView() {
        guard let theme = delegate.viewModel?.theme else { return }
        backgroundColor = theme.currentTheme.generalBackgroundColour
        navView.backgroundFillerColor(color: theme.currentTheme.navigation.backgroundColor)
        navView.rightNavItem?.setAttributedTitle(NSAttributedString(string: "Add", attributes: theme.currentTheme.navigation.item), for: .normal)
        navView.leftNavItem?.setAttributedTitle(NSAttributedString(string: "Settings", attributes: theme.currentTheme.navigation.item), for: .normal)
        navView.titleLabel?.attributedText = NSAttributedString(string: Bundle.appName(), attributes: theme.currentTheme.navigation.title)
    }
    
    func willReloadCellData(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.collView.reloadItems(at: [indexPath])
        }
    }
    
    func willReloadTableData() {
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
    }
    
    func addToCollectionView() {
        
        guard let vm = self.delegate.viewModel else {
            return
        }
        
        DispatchQueue.main.async {
            self.collView.insertItems(at: [IndexPath(item: vm.dataSource.count - 1, section: 0)])
        }
    }
    
    func stepComplete(_ date: Date) {
        playSound()
        
        guard let vm = delegate.viewModel else {
            return
        }
        
        let index = vm.searchForIndex(date)
        if (index != -1) {
            let cell = collView.cellForItem(at: IndexPath(row: index, section: 0)) as! MainViewCell
            //animate bg colour
//            cell.animateCellForCompleteStep()
        }
    }
    
    func playSound() {
        AudioServicesPlayAlertSound(1309)
    }
    
    @objc func handleDeleteAllRecipe() {
        delegate.handleDeleteAllRecipe()
    }
    
    @objc func handleAddRecipe() {
        delegate.handleAddRecipe()
    }
    
    @objc func handleSettings() {
        delegate.handleSettings()
    }
    
    
    /// Adds Sample Data (not to be released during production)
    /// For testing purposes only. It creates a group of recipes with steps of random data. All variables are filled and used to sample the UI and flow.
    @objc func handleTest() {
        let recipeNumber = 10
        //use to be getPrivateContext
        CoreDataHandler.getContext().perform {
            for i in 0..<recipeNumber {
                let stepNumber = Int.random(in: 0..<8)
                
                let rEntity = RecipeEntity(name: "Recipe\(i)")
                for i in 0..<stepNumber {
                    let secondNumber = 5
                    let sEntity = StepEntity(name: "Step\(i)", hours: 0, minutes: 0, seconds: secondNumber, priority: Int16(i))
                    if (i == 0) {
                        sEntity.isLeading = true
                        sEntity.updateExpiry()
                        rEntity.currStepName = sEntity.stepName
                        rEntity.currStepPriority = Int16(0)
                    }
                    rEntity.addToStep(sEntity)
                }
                rEntity.sumStepsForExpectedElapsedTime()
                rEntity.updateCurrStepInRecipe()
                self.delegate.addToRecipeCollection(r: rEntity)
            }
            CoreDataHandler.saveContext()
            
            guard let vm = self.delegate.viewModel else {
                return
            }
            
            DispatchQueue.main.async {
                self.collView.performBatchUpdates({
                    let insertIndexPaths = Array(0..<vm.dataSource.count).map { IndexPath(item: $0, section: 0) }
                    self.collView.insertItems(at: insertIndexPaths)
                }, completion: nil)
            }
        }
    }
    
    func deleteRecipesFromCollectionView(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.collView.performBatchUpdates({
                self.collView.deleteItems(at: indexPaths)
            }, completion: nil)
            if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
                CoreDataHandler.saveContext()
            }
        }
    }
    
    func showSettings() {
        guard let theme = delegate?.viewModel?.theme else {
            return
        }
        let vc = SettingsViewController(delegate:delegate, viewModel: SettingsViewModel(dataSource: SettingsDataSource.dataSource, theme: theme))
        DispatchQueue.main.async {
            self.delegate?.present(vc, animated: true, completion: nil)
        }
    }

}
