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
    case UpgradeHeader = "UpgradeHeaderId"
}

class MainViewController: ViewControllerBase {
    
    var horizontalDelegate = HorizontalTransitionDelegate()

    private var transitionDelegate = OverlayTransitionDelegate()
    
    private var dismissInteractor: OverlayInteractor!
    
    var viewModel: MainViewModel?
    
    lazy var mainView: MainViewView = {
        let view = MainViewView(delegate: self)
        view.backgroundColor = viewModel?.theme?.currentTheme.generalBackgroundColour
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    convenience init(viewModel: MainViewModel? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    ///The super class will call prepare_ functions. They don't need to be called
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.isStatusBarHidden = true
        //testData()
    }

    func testData() {
        if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
//            print("Successfully deleted all records")
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
        navigationController?.navigationBar.isHidden = true
        startTimer()
    }

     override func prepareView() {
        super.prepareView()
        
        guard let vm = viewModel else {
            return
        }
        vm.checkIfPro()
        view.addSubview(mainView)
        vm.loadDataFromCoreData()
    }

    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
    }
    
    // must be paused at all layers - recipe, step
    func pauseEntireRecipe(recipe: RecipeEntity) {
        guard let vm = viewModel else {
            return
        }
        
        vm.pauseRecipe(recipe: recipe)
    }

    func unpauseEntireRecipe(recipe: RecipeEntity) {
        guard let vm = viewModel else {
            return
        }
        
        vm.stopRecipe(recipe: recipe)
    }

    func addToRecipeCollection(r: RecipeEntity) {
        guard let vm = viewModel else {
            return
        }
        vm.dataSource.append(r)
    }

    // MARK: - Uupdates the recipe time label when returning from the Recipe View
    func updateCellPauseState(indexPath: IndexPath, recipe: RecipeEntity) {
        guard let theme = viewModel?.theme else {
            return
        }
        
        
        let pauseBackground = recipe.isPaused ? theme.currentTheme.tableView.pauseButtonBackgroundActive : theme.currentTheme.tableView.pauseButtonBackgroundInactive
        let textColor = !recipe.isPaused ? theme.currentTheme.tableView.cellTextColor : theme.currentTheme.tableView.pausedTextColor
        
        let cell = mainView.collView.cellForItem(at: indexPath) as! MainViewCell
        DispatchQueue.main.async {
            cell.updateStepLabel()
            cell.updateRecipeLabel()
            cell.updateColorTag()
            cell.updatePauseButtonView(textColor, pauseBackground)
        }
    }
    
    func reloadMainViewIfThemeChanges() {
        guard let theme = viewModel?.theme else {
            return
        }
        mainView.refreshNavView()
        
        mainView.collView.backgroundColor = theme.currentTheme.tableView.backgroundColor
        DispatchQueue.main.async {
            self.mainView.collView.reloadItems(at: self.mainView.collView.indexPathsForVisibleItems)
        }
    }
    
    func resetCurrentStep(rEntity: RecipeEntity) {
        guard let vm = viewModel else { return }
        vm.resetCurrentStepFor(recipeEntity: rEntity)
    }
}

//MARK: - UI
extension MainViewController {
    func handleSettings() {
        mainView.showSettings()
    }
    
    func handleAddRecipe() {
        
        guard let theme = viewModel?.theme else { return }
        let addRecipeViewModel = AddRecipeViewModel(dataSource: [], mainDelegate: self, delegate: nil, theme: theme)
        let vc = AddRecipeViewController(delegate:self, viewModel: addRecipeViewModel)
        addRecipeViewModel.delegate = vc
        present(vc, animated: true, completion: nil)
        
//        let vc = AddRecipeViewController(delegate:self)
//        vc.transitioningDelegate = transitionDelegate
//        vc.modalPresentationStyle = .custom
//        dismissInteractor = OverlayInteractor()
//        dismissInteractor.attachToViewController(viewController: vc, withView: vc.view, presentViewController: nil)
//        vc.interactor = dismissInteractor
//        transitionDelegate.dismissInteractor = dismissInteractor
        
    }
    
    ///Deprecated
    func handleDeleteAllRecipe() {
        guard let vm = viewModel else {
            return
        }
        vm.handleDeleteAllRecipe()
    }
    
    func deleteAllRecipes() {
        guard let vm = viewModel else {
            return
        }
        let indexPathsToDelete = vm.clearLocalStorage()
        mainView.deleteRecipesFromCollectionView(indexPaths: indexPathsToDelete)
    }
    
    ///Called from RecipeViewController to delete the Recipe from the recipe view
    func handleDeleteARecipe(_ date: Date) {
        
        guard let vm = viewModel else {
            return
        }
        
        let index = vm.searchForIndex(date)

        if (index != -1) {
            
            let recipeName = vm.dataSource[index].recipeName
            if let recipeDate = vm.dataSource[index].createdDate {
                let id = "\(recipeName!).\(recipeDate)"
                LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
                
                vm.dataSource.remove(at: index)
                DispatchQueue.main.async {
                    self.mainView.collView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }
                if (CoreDataHandler.deleteEntity(entity: RecipeEntity.self, createdDate: date)) {
                }
            }
            
        }
        startTimer()
    }
}




