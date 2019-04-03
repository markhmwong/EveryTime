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
    private lazy var navView: NavView? = nil
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var player: AVAudioPlayer?
    private var delegate: MainViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: MainViewController) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var rightNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: Theme.Font.Nav.Item), for: .normal)//revert back to add recipe
        button.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var leftNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Settings", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleAbout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: Bundle.appName(), attributes: Theme.Font.Nav.AppName)
        return label
    }()
    
    /// Test data button
    private lazy var leftNavItemButtonA: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Test Random Data", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleTest), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = delegate
        view.delegate = delegate
        view.dragInteractionEnabled = true
        view.backgroundColor = Theme.Background.Color.Clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupView() {
        navView = NavView(frame: .zero, leftNavItem: leftNavItemButton, rightNavItem: rightNavItemButton)
        guard let nav = navView else {
            return
        }
        addSubview(collView)
        nav.addSubview(appNameLabel)
        addSubview(nav)        
        collView.register(MainViewCell.self, forCellWithReuseIdentifier: CollectionCellIds.RecipeCell.rawValue)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            guard let nav = navView else {
                return
            }
            nav.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }

    func setupAutoLayout() {
        guard let nav = navView else {
            return
        }
        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        nav.anchorView(top: navTopConstraint, bottom: collView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        nav.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true

        leftNavItemButton.anchorView(top: nil, bottom: nil, leading: nav.leadingAnchor, trailing: nil, centerY: nav.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
        rightNavItemButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: nav.trailingAnchor, centerY: nav.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -10.0), size: .zero)
        appNameLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: nav.centerYAnchor, centerX: nav.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
        
        collView.anchorView(top: nav.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
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
        DispatchQueue.main.async {
            self.collView.insertItems(at: [IndexPath(item: self.delegate.recipeCollection.count - 1, section: 0)])
        }
    }
    
    func stepComplete(_ date: Date) {
        playSound()
        let index = delegate.searchForIndex(date)
        if (index != -1) {
            let cell = collView.cellForItem(at: IndexPath(row: index, section: 0)) as! MainViewCell
            //animate bg colour
            cell.animateCellForCompleteStep()
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
    
    @objc func handleAbout() {
        delegate.handleAbout()
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
            DispatchQueue.main.async {
                self.collView.performBatchUpdates({
                    let insertIndexPaths = Array(0..<self.delegate.recipeCollection.count).map { IndexPath(item: $0, section: 0) }
                    self.collView.insertItems(at: insertIndexPaths)
                }, completion: nil)
            }
        }
    }
}
