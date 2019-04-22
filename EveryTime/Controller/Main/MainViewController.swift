//
//  ViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//
    
import UIKit
import AVFoundation
import StoreKit

enum ScrollingState {
    case Show
    case Hide
    case Idle
}

enum CollectionCellIds: String {
    case RecipeCell = "RecipeCellId"
}

class MainViewController: ViewControllerBase {
    var cellSize: CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return 2.8
        default:
            return 3.0
        }
    }
    var dataSource: [RecipeEntity] = []
    var horizontalDelegate = HorizontalTransitionDelegate()
    var timer: Timer?

    private var addButtonState: ScrollingState = .Idle
    private var indexPathNumber = 0
    private var transitionDelegate = OverlayTransitionDelegate()
    private var dismissInteractor: OverlayInteractor!
    private var sections: Int = 0
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    lazy var mainView: MainViewView = {
       let view = MainViewView(delegate: self)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


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

    override func prepareViewController() {
        super.prepareViewController()
        CoreDataHandler.loadContext()
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white//Theme.Background.Color.NavBackgroundColor
        view.layer.cornerRadius = Theme.View.CornerRadius
        navigationController?.navigationBar.isHidden = true
        startTimer()
    }

     override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
        loadDataFromCoreData()

    }

    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        
        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
    }
    
//    func prepareWhatsNew() {
//        let whatsNewViewModel = WhatsNewViewModel()
//        let whatsNewVC = WhatsNewViewController(viewModel: whatsNewViewModel)
//
//        addChild(whatsNewVC)
//    }
    
    // must be paused at all layers - recipe, step
    func pauseEntireRecipe(recipe: RecipeEntity) {
        recipe.pauseStepArr()
    }

    func unpauseEntireRecipe(recipe: RecipeEntity) {
        recipe.unpauseStepArr()
    }

    func addToRecipeCollection(r: RecipeEntity) {
        dataSource.append(r)
    }

    func loadDataFromCoreData() {
        CoreDataHandler.getContext().perform {
            guard let rEntityArr = CoreDataHandler.fetchEntity(in: RecipeEntity.self) else {
                return
            }
            self.dataSource = self.sortRecipeCollection(in: rEntityArr)
            self.mainView.willReloadTableData()
        }
    }
    
    func sortRecipeCollection(in rEntityArr: [RecipeEntity]) -> [RecipeEntity] {
        return rEntityArr.sorted { (x, y) -> Bool in
            return (x.createdDate?.compare(y.createdDate!) == .orderedAscending)
        }
    }
    
    func updateCellPauseState(indexPath: IndexPath, recipe: RecipeEntity) {
        let bg = !recipe.isPaused ? Theme.View.RecipeCell.RecipeCellPauseButtonActive : Theme.View.RecipeCell.RecipeCellPauseButtonInactive
        let textColor = !recipe.isPaused ? Theme.Font.Color.TextColour : Theme.Font.Color.TextColourDisabled
        let highlightAlpha: CGFloat = !recipe.isPaused ? 0.25 : 0.85
        
        let cell = mainView.collView.cellForItem(at: indexPath) as! MainViewCell
        DispatchQueue.main.async {
            cell.updateStepLabel()
            cell.updatePauseHighlight()
            cell.updatePauseButtonView(textColor, highlightAlpha, bg)
        }
    }
    
    //binary search through all recipes
    func searchForIndex(_ date: Date) -> Int {
        var left = 0
        var right = dataSource.count - 1
        while (left <= right) {
            let middle = left + (right - left) / 2
            if (dataSource[middle].createdDate! == date)  {
                    return middle
                }
            if (dataSource[middle].createdDate! < date) {
                   left = middle + 1
                } else {
                    right = middle - 1
                }
        }
        return -1
    }
    
    func showWhatsNew() {
//        let model = WhatsNew(version: <#T##String#>, build: <#T##String#>, patchNotes: <#T##[String]#>)
//        let whatsNew = WhatsNewFactory.getWhatsNew(whatsNew: <#T##WhatsNew#>)
        
    }
}

//MARK: - UI
extension MainViewController {
    func handleAbout() {
        let vc = SettingsViewController(delegate:self, viewModel: SettingsViewModel(dataSource: SettingsDataSource.dataSource))
        present(vc, animated: true, completion: nil)
    }
    
    func handleAddRecipe() {
        let vc = AddRecipeViewController(delegate:self)
//        let vc = AddRecipeViewController(delegate:self)
//        vc.transitioningDelegate = transitionDelegate
//        vc.modalPresentationStyle = .custom
//        dismissInteractor = OverlayInteractor()
//        dismissInteractor.attachToViewController(viewController: vc, withView: vc.view, presentViewController: nil)
//        vc.interactor = dismissInteractor
        vc.modalPresentationStyle = .overCurrentContext
//        transitionDelegate.dismissInteractor = dismissInteractor
        present(vc, animated: true, completion: nil)
    }

    func handleDeleteAllRecipe() {
        let alert = UIAlertController(title: "Are you sure?", message: "This will delete every recipes", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let deleteIndexPaths = Array(0..<self.dataSource.count).map { IndexPath(item: $0, section: 0) }
           self.dataSource.removeAll()
            self.mainView.collView.performBatchUpdates({
                self.mainView.collView.deleteItems(at: deleteIndexPaths)
            }, completion: nil)
            if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
                CoreDataHandler.saveContext()
            }
        }))
       present(alert, animated: true, completion: nil)
    }
    
    func deleteAllRecipes() {
        let deleteIndexPaths = Array(0..<self.dataSource.count).map { IndexPath(item: $0, section: 0) }
        self.dataSource.removeAll()
        self.mainView.collView.performBatchUpdates({
            self.mainView.collView.deleteItems(at: deleteIndexPaths)
        }, completion: nil)
        if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
            CoreDataHandler.saveContext()
        }
    }
    
    ///Called from RecipeViewController
    func handleDeleteARecipe(_ date: Date) {
        let index = searchForIndex(date)

        if (index != -1) {
            let recipeName = dataSource[index].recipeName
            let recipeDate = dataSource[index].createdDate
            let id = "\(recipeName!).\(recipeDate)"
            LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            
            dataSource.remove(at: index)
            DispatchQueue.main.async {
                self.mainView.collView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
            CoreDataHandler.deleteEntity(entity: RecipeEntity.self, createdDate: date)
        }
        startTimer()
    }
}




