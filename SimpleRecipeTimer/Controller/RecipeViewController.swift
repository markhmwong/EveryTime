//
//  RecipeController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 30/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RecipeVCDelegate, TimerProtocol {

    //MARK: - Class Variables -
    var timer: Timer?
    let stepCellId = "stepCellId"
    var recipe: RecipeEntity!
//    var stepArr: [Step] = []
    var stepSet: Set<StepEntity>!
    var stepArr: [StepEntity] = []
    var stepCompleteTracker: Int = 0
    var mainViewController: MainViewController?
//    var runningStepArr: [IndexPath] = [] //list of indexPaths
    
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        //        view.dragDelegate = self
        view.dragInteractionEnabled = true
        view.backgroundColor = UIColor.green
        return view
    }()
    
    //MARK: - Init -
    init(recipe: RecipeEntity, delegate: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewController = delegate
        self.recipe = recipe
        self.stepSet = recipe.step as? Set<StepEntity>
        self.stepArr = recipe.sortSteps()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Collection View methods -
    
    //MARK: delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stepsVC = StepsViewController(stepModel: stepArr[indexPath.item])
        stepsVC.recipeViewControllerDelegate = self
        self.navigationController?.pushViewController(stepsVC, animated: true)
    }
    
    //MARK: layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStepHandler))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler))

        self.prepareCollectionView()
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startTimer()
    }
    
    func prepareCollectionView() {
        self.view.addSubview(collView)        
        //MARK: COLLECTIONVIEW CONSTRAINTS
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        
        //MARK: CELL REGISTRATION
        collView.register(StepCell.self, forCellWithReuseIdentifier: stepCellId)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let mvc = mainViewController else {
            //TODO: Error
            return
        }
        
        self.stopTimer()
        DispatchQueue.main.async {
            mvc.willReloadTableData()
        }
    }
    
    //MARK: - UI Methods -
    @objc func doneHandler() {
        self.dismiss(animated: true) {
            self.stopTimer()
        }
    }
    
    @objc func addStepHandler() {
        let addStepViewController = AddStepViewController()
        addStepViewController.recipeViewControllerDelegate = self
        self.navigationController?.present(UINavigationController(rootViewController: addStepViewController), animated: false, completion: nil)
    }
    
    //MARK: Timer Protocol
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
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

        for cell in cells {
            if let s = cell.entity {
                let primaryPauseState = s.isPausedPrimary
                //checks if primary level pause is true - primary level being the Step (individual clocks) level
                if (!primaryPauseState) {
                    s.updateTotalElapsedTime()
                    cell.updateTimeLabel(time:s.timeRemaining())
                } else {
                    //paused
                    cell.updateTimeLabel(time:s.timeRemainingPausedState())
                }
            }
        }
        
        //TODO: - Stop timer if all clocks have been completed
        
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
