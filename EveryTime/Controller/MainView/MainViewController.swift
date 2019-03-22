//
//  ViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//
    
import UIKit
import AVFoundation

enum ScrollingState {
    case Show
    case Hide
    case Idle
}

class MainViewController: ViewControllerBase {
        public var recipeCollection: [RecipeEntity] = []
        public var horizontalDelegate = HorizontalTransitionDelegate()
        public let recipeCellId = "RecipeCellId"

        private var player: AVAudioPlayer?
        private var addButtonState: ScrollingState = .Idle
        private var indexPathNumber = 0
        private var timer: Timer?
        private var transitionDelegate = OverlayTransitionDelegate()
        private var dismissInteractor: OverlayInteractor!
        private var sections: Int = 0
        private let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        private lazy var navView: NavView? = nil
    
        lazy var mainViewView: MainViewView = {
           let view = MainViewView(delegate: self)
            view.backgroundColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
//        private lazy var rightNavItemButton: UIButton = {
//            let button = UIButton()
//            button.setAttributedTitle(NSAttributedString(string: "Clear All", attributes: Theme.Font.Nav.Item), for: .normal)//revert back to add recipe
//            button.addTarget(self, action: #selector(handleDeleteAllRecipe), for: .touchUpInside)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            return button
//        }()
//
//        private lazy var leftNavItemButton: UIButton = {
//            let button = UIButton()
//            button.setAttributedTitle(NSAttributedString(string: "About", attributes: Theme.Font.Nav.Item), for: .normal)
//            button.addTarget(self, action: #selector(handleAbout), for: .touchUpInside)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            return button
//        }()
//
//        private lazy var addRecipeButton: StandardButton = {
//            let button = StandardButton(title: "Add Recipe")
//            button.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
//            return button
//        }()
    
//    private lazy var appNameLabel: UILabel = {
//       let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.attributedText = NSAttributedString(string: Bundle.appName(), attributes: Theme.Font.Nav.AppName)
//        return label
//    }()

//    private lazy var leftNavItemButtonA: UIButton = {
//        let button = UIButton()
//        button.setAttributedTitle(NSAttributedString(string: "Test Random Data", attributes: Theme.Font.Nav.Item), for: .normal)
//        button.addTarget(self, action: #selector(handleTest), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//   }()
    
//    lazy var collView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.dataSource = self
//        view.delegate = self
//        view.dragInteractionEnabled = true
    ////                    view.backgroundColor = Theme.Background.Color.Clear

//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    ///The super class will call prepare_ functions. They don't need to be called
    override func viewDidLoad() {
            super.viewDidLoad()
            UIApplication.shared.isStatusBarHidden = true
    //        testData()
    }

    func testData() {
        if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
                print("Successfully deleted all records")
            }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            stopTimer()
    }

    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
    }

    override func endAppearanceTransition() {
        super.endAppearanceTransition()
            stopTimer()
    }
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        if (appDelegate.hasTopNotch) {
//                let safeAreaInsets = self.view.safeAreaInsets
//    
//                guard let nav = navView else {
//                        return
//                    }
//                nav.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
//            }
//    }

    override func prepareViewController() {
        super.prepareViewController()
        CoreDataHandler.loadContext()
        
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white//Theme.Background.Color.NavBackgroundColor
        view.layer.cornerRadius = Theme.View.CornerRadius
        navigationController?.navigationBar.isHidden = true
        loadDataFromCoreData()
        startTimer()
    }

     override func prepareView() {
        super.prepareView()
        view.addSubview(mainViewView)
        mainViewView.willReloadTableData()
        print("after")
//        navView = NavView(frame: .zero, leftNavItem: leftNavItemButton, rightNavItem: rightNavItemButton)
//        guard let nav = navView else {
//                return
//        }
//        nav.addSubview(appNameLabel)
//        view.addSubview(nav)
//        view.addSubview(collView)
//        view.addSubview(addRecipeButton)
        //register cells
//        collView.register(MainViewCell.self, forCellWithReuseIdentifier: recipeCellId)
    }

    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        
        mainViewView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))

        
//        guard let nav = navView else {
//                return
//            }
//
//        if (!appDelegate.hasTopNotch) {
//            nav.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        }
//        nav.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        nav.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        nav.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Theme.View.Nav.Height).isActive = true
//        nav.bottomAnchor.constraint(equalTo: collView.topAnchor, constant: 0).isActive = true

//        leftNavItemButton.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
//        leftNavItemButton.leadingAnchor.constraint(equalTo: nav.leadingAnchor, constant: 10).isActive = true
//
//        rightNavItemButton.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
//        rightNavItemButton.trailingAnchor.constraint(equalTo: nav.trailingAnchor, constant: -10).isActive = true

//        collView.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
//        collView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        collView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

//        addRecipeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
//        addRecipeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        addRecipeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
//
//        appNameLabel.centerXAnchor.constraint(equalTo: nav.centerXAnchor).isActive = true
//        appNameLabel.centerYAnchor.constraint(equalTo: nav.centerYAnchor).isActive = true
    }
//
//    func willReloadCellData(indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            self.collView.reloadItems(at: [indexPath])
//        }
//    }
//
//    func willReloadTableData() {
//        DispatchQueue.main.async {
//            self.collView.reloadData()
//        }
//    }
    
    // must be paused at all layers - recipe, step
    func pauseEntireRecipe(recipe: RecipeEntity) {
        recipe.pauseStepArr()
    }

    func unpauseEntireRecipe(recipe: RecipeEntity) {
        recipe.unpauseStepArr()
    }

    func addToRecipeCollection(r: RecipeEntity) {
        recipeCollection.append(r)
    }

//    func addToCollectionView() {
//        DispatchQueue.main.async {
//            self.collView.insertItems(at: [IndexPath(item: self.recipeCollection.count - 1, section: 0)])
//        }
//    }

    func loadDataFromCoreData() {
        CoreDataHandler.getContext().perform {
            guard let rEntityArr = CoreDataHandler.fetchEntity(in: RecipeEntity.self) else {
                return
            }
            self.recipeCollection = self.sortRecipeCollection(in: rEntityArr)
            print("recipeCollection.count \(self.recipeCollection.count)")
        }
    }
    
    func sortRecipeCollection(in rEntityArr: [RecipeEntity]) -> [RecipeEntity] {
        return rEntityArr.sorted { (x, y) -> Bool in
            return (x.createdDate?.compare(y.createdDate!) == .orderedAscending)
        }
    }

//    func stepComplete(_ date: Date) {
//        playSound()
//        let index = searchForIndex(date)
//        if (index != -1) {
//            let cell = collView.cellForItem(at: IndexPath(row: index, section: 0)) as! MainViewCell
//            //animate bg colour
//            cell.animateCellForCompleteStep()
//        }
//    }
    
    //binary search
    func searchForIndex(_ date: Date) -> Int {
        var left = 0
        var right = recipeCollection.count - 1
        while (left <= right) {
                let middle = left + (right - left) / 2
                if (recipeCollection[middle].createdDate! == date)  {
                        return middle
                    }
                if (recipeCollection[middle].createdDate! < date) {
                       left = middle + 1
                    } else {
                        right = middle - 1
                    }
            }
        return -1
    }
    
    /**
      # Plays sound when a step completes
 
      AudioServicesPlayAlertSound handles the mute/silent switch on the iPhone. Sound will not play when the mute switch is ON, instead it will vibrate. This is expected behaviour.
 
      http://iphonedevwiki.net/index.php/AudioServices
 
      */
//    func playSound() {
//        AudioServicesPlayAlertSound(1309)
//    }
}



//MARK: - UI
extension MainViewController {
        /**
          # Adds Sample Data (not to be released during production)
     
          For testing purposes only. It creates a group of recipes with steps of random data. All variables are filled and used to sample the UI and flow.
         */
//        @objc func handleTest() {
//            let recipeNumber = 10
//            CoreDataHandler.getPrivateContext().perform {
//                for i in 0..<recipeNumber {
//                    let stepNumber = Int.random(in: 0..<8)
//
//                    let rEntity = RecipeEntity(name: "Recipe\(i)")
//                    for i in 0..<stepNumber {
//                        let secondNumber = 5
//                        let sEntity = StepEntity(name: "Step\(i)", hours: 0, minutes: 0, seconds: secondNumber, priority: Int16(i))
//                        if (i == 0) {
//                            sEntity.isLeading = true
//                            sEntity.updateExpiry()
//                            rEntity.currStepName = sEntity.stepName
//                            rEntity.currStepPriority = Int16(0)
//                        }
//                        rEntity.addToStep(sEntity)
//                    }
//                    rEntity.sumStepsForExpectedElapsedTime()
//                    rEntity.updateCurrStepInRecipe()
//                    self.addToRecipeCollection(r: rEntity)
//                }
//                CoreDataHandler.saveContext()
//                DispatchQueue.main.async {
//                    self.collView.performBatchUpdates({
//                        let insertIndexPaths = Array(0..<self.recipeCollection.count).map { IndexPath(item: $0, section: 0) }
//                        self.collView.insertItems(at: insertIndexPaths)
//                    }, completion: nil)
//                }
//            }
//        }
    
    func handleAbout() {
        let vc = AboutViewController(delegate:self)
        present(vc, animated: true, completion: nil)
    }
    
    func handleAddRecipe() {
        let vc = AddRecipeViewController(delegate:self)
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        dismissInteractor = OverlayInteractor()
        dismissInteractor.attachToViewController(viewController: vc, withView: vc.view, presentViewController: nil)
        vc.interactor = dismissInteractor
        transitionDelegate.dismissInteractor = dismissInteractor
        present(vc, animated: true, completion: nil)
    }

    func handleDeleteAllRecipe() {
        let alert = UIAlertController(title: "Are you sure?", message: "This will delete every recipes", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let deleteIndexPaths = Array(0..<self.recipeCollection.count).map { IndexPath(item: $0, section: 0) }
           self.recipeCollection.removeAll()
            self.mainViewView.collView.performBatchUpdates({
                self.mainViewView.collView.deleteItems(at: deleteIndexPaths)
            }, completion: nil)
            if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
                CoreDataHandler.saveContext()
            }
        }))
       present(alert, animated: true, completion: nil)
    }
    
    ///Called from RecipeViewController
    func handleDeleteARecipe(_ date: Date) {
        let index = searchForIndex(date)

        if (index != -1) {
            let recipeName = recipeCollection[index].recipeName
            let recipeDate = recipeCollection[index].createdDate
            let id = "\(recipeName!).\(recipeDate)"
            LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            
            recipeCollection.remove(at: index)
            DispatchQueue.main.async {
                self.mainViewView.collView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
            CoreDataHandler.deleteEntity(entity: RecipeEntity.self, createdDate: date)
        }
        startTimer()
    }
}

extension MainViewController: TimerProtocol {
    func startTimer() {
            if (timer == nil) {
                    timer?.invalidate()
                    let timerInterval = 0.1
                    timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer!, forMode: .common)
                }
        }

    func stopTimer() {
            if (timer != nil) {
                    timer?.invalidate()
                        timer = nil
                }
        }

    @objc func update() {
        let cells = self.mainViewView.collView.visibleCells as! [MainViewCell] //change this to all cells not just visible
        for cell in cells {
            if let r = cell.entity {
                if (!r.isPaused) {
                    r.updateRecipeTime(delegate: self)
                    cell.updateTimeLabel(timeRemaining: r.timeRemainingForCurrentStepToString())
                }
            }
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        executeState(state: .Hide)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        executeState(state: .Show)
    }

    func executeState(state: ScrollingState) {
        switch state {
            case .Show:
                    showStepButtonAnimation()
            case .Hide:
                    hideStepButtonAnimation()
            case .Idle:
                    break
            }
    }

    func hideStepButtonAnimation() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.mainViewView.addRecipeButton.center.y = self.view.frame.maxY + 50.0
          }, completion: nil)
    }

    func showStepButtonAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.mainViewView.addRecipeButton.center.y = self.view.frame.maxY - 50.0
            }, completion: nil)
    }
}
