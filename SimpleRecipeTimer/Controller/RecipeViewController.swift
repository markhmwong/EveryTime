//
//  RecipeController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 30/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,  RecipeVCDelegate, TimerProtocol {

    //MARK: - Class Variables -
    var timer: Timer?
    let stepCellId = "stepCellId"
    var recipe: RecipeEntity!
    var stepSet: Set<StepEntity>!
    var stepArr: [StepEntity] = []
    var stepCompleteTracker: Int = 0
    var mainViewControllerDelegate: MainViewController?
    var screenSize = UIScreen.main.bounds.size
    var transitionDelegate = OverlayTransitionDelegate()
    var horizontalDelegate = HorizontalTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    var indexPath: IndexPath? = nil
    
    fileprivate var addStepButton: UIButton?
    fileprivate var nav: UIView?
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(dismissHandler), for: .touchUpInside)
        return button
    }()
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        //        view.dragDelegate = self
        view.dragInteractionEnabled = true
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()
    
    //MARK: - Init -
    init(recipe: RecipeEntity, delegate: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewControllerDelegate = delegate
        self.recipe = recipe
        self.stepSet = recipe.step as? Set<StepEntity>
        self.stepArr = recipe.sortStepsByPriority()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Collection View methods -
    
    //MARK: delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StepsViewController(stepModel: stepArr[indexPath.item])
        horizontalTransitionInteractor = HorizontalTransitionInteractor(viewController: vc)
        horizontalDelegate.dismissInteractor  = horizontalTransitionInteractor
        vc.transitioningDelegate = horizontalDelegate
        vc.modalPresentationStyle = .custom
        vc.recipeViewControllerDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenSize.width, height: 50)
    }
    
    //MARK: datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stepArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCellId, for: indexPath) as! StepCell
        cell.entity = stepArr[indexPath.item]
        return cell
    }
    
    //MARK: - Controller Lifecycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        self.prepareSubviews()
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startTimer()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let safeAreaInsets = self.view.safeAreaInsets
        if (safeAreaInsets.top > 0) {
            //safeAreaInsets = 44
            nav!.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true
        }
    }
    
    func prepareSubviews() {
        nav = UIView()
        
        guard let navView = nav else {
            return
        }
        
        navView.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        navView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navView)

        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        navView.addSubview(dismissButton)
        dismissButton.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 10).isActive = true
        
        addStepButton = UIButton()
        addStepButton?.setAttributedTitle(NSAttributedString(string: "Delete", attributes: Theme.Font.Nav.Item), for: .normal)
        addStepButton?.addTarget(self, action: #selector(handleDeleteRecipe), for: .touchUpInside)
        addStepButton?.translatesAutoresizingMaskIntoConstraints = false
        navView.addSubview(addStepButton!)
        addStepButton?.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        addStepButton?.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: -10).isActive = true
                
        let recipeName = UILabel()
        recipeName.attributedText = NSAttributedString(string: recipe.recipeName!, attributes: Theme.Font.Nav.RecipeTitle)
        recipeName.translatesAutoresizingMaskIntoConstraints = false
        navView.addSubview(recipeName)
        recipeName.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        recipeName.centerXAnchor.constraint(equalTo: navView.centerXAnchor).isActive = true
        
        
        self.view.addSubview(collView)        
        //MARK: COLLECTIONVIEW CONSTRAINTS
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.topAnchor.constraint(equalTo: navView.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        collView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        
        //MARK: CELL REGISTRATION
        collView.register(StepCell.self, forCellWithReuseIdentifier: stepCellId)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let mvc = mainViewControllerDelegate else {
            //TODO: Error
            return
        }
        
        self.stopTimer()
        DispatchQueue.main.async {
            mvc.willReloadTableData()
        }
    }
    
    //MARK: - UI Methods -
    @objc func dismissHandler() {
        guard let mvc = mainViewControllerDelegate else {
            return
        }
        mvc.dismiss(animated: true) {
            self.stopTimer()
        }
    }
    
    @objc func handleDeleteRecipe() {
        //delete entity by date
        guard let createdDate = recipe.createdDate else {
            return
        }
        CoreDataHandler.deleteEntity(entity: RecipeEntity.self, createdDate: createdDate)
        guard let mvc = mainViewControllerDelegate else {
            return
        }
        guard let index = indexPath else {
            return
        }
        
        mvc.recipeCollection.remove(at: index.item)
        mvc.collView.deleteItems(at: [index])
        mvc.dismiss(animated: true, completion: nil)

        
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
    
    //MARK: Timer Protocol
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }

    @objc func update() {
        //steps to update
        let cells = self.collView.visibleCells as! [StepCell]
        
        for (_, cell) in cells.enumerated() {
            guard let s = cell.entity else {
                return
            }

            if let index = collView.indexPath(for: cell) {
                
                if (s.isLeading) {
                    if (!s.isStepComplete()) {
                        s.updateTotalElapsedTime()
                    } else {
                        
                        //set next leading timer
                        let numItems = collView.numberOfItems(inSection: 0)
                        if (numItems < index.item + 1) {
                            let stepCell = collView.cellForItem(at: IndexPath(item: index.item + 1, section: index.section)) as! StepCell
                            guard let nextEntity = stepCell.entity else {
                                return
                            }
                            nextEntity.isLeading = true
                            nextEntity.updateExpiry()
                        }

                    }
                } else {
                    //is running parallel
                }
                
                cell.updateTimeLabel(time:s.timeRemaining())
            }
        }
    }

    //MARK: - RecipeVCDelegate Protocol Functions -
    func didReturnValues(step: StepEntity) {
        self.recipe.addToStep(step)
        self.stepArr.append(step)
        CoreDataHandler.saveContext()
    }
    
    func willReloadTableData() {
        self.collView.reloadData()
    }
}
