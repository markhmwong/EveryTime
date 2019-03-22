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
    private var addButtonState: ScrollingState = .Idle
    private var transitionDelegate = OverlayTransitionDelegate()
    private var dismissInteractor: OverlayInteractor!
    private var delegate: MainViewController!
    private let recipeCellId = "RecipeCellId"

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
    
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = delegate
        print(delegate)
        view.delegate = delegate
        view.dragInteractionEnabled = true
        view.backgroundColor = Theme.Background.Color.Clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Clear All", attributes: Theme.Font.Nav.Item), for: .normal)//revert back to add recipe
        button.addTarget(self, action: #selector(handleDeleteAllRecipe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var leftNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "About", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleAbout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var addRecipeButton: StandardButton = {
        let button = StandardButton(title: "Add Recipe")
        button.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
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
    
    func setupView() {
        print("setup view")
        navView = NavView(frame: .zero, leftNavItem: leftNavItemButton, rightNavItem: rightNavItemButton)
        guard let nav = navView else {
            return
        }
        addSubview(collView)
        nav.addSubview(appNameLabel)
        addSubview(nav)
        addSubview(addRecipeButton)
        
        collView.register(MainViewCell.self, forCellWithReuseIdentifier: recipeCellId)
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
        
        if (!appDelegate.hasTopNotch) {
            nav.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        nav.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nav.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nav.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Theme.View.Nav.Height).isActive = true
        nav.bottomAnchor.constraint(equalTo: collView.topAnchor, constant: 0).isActive = true
        
        leftNavItemButton.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
        leftNavItemButton.leadingAnchor.constraint(equalTo: nav.leadingAnchor, constant: 10).isActive = true
        
        rightNavItemButton.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
        rightNavItemButton.trailingAnchor.constraint(equalTo: nav.trailingAnchor, constant: -10).isActive = true
        
        addRecipeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -45).isActive = true
        addRecipeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addRecipeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
        
        appNameLabel.centerXAnchor.constraint(equalTo: nav.centerXAnchor).isActive = true
        appNameLabel.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
        
        collView.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
