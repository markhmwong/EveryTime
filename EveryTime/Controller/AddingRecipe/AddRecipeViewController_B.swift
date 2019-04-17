//
//  AddRecipeViewController_B.swift
//  EveryTime
//
//  Created by Mark Wong on 12/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeViewController_B: UIViewController {
    
    var viewModel: AddRecipeViewController_BViewModel?
    
    weak var delegate: MainViewController?
    
    lazy var mainView: AddRecipeMainView = {
        let view = AddRecipeMainView(delegate: self)
        view.backgroundColor = Theme.Background.Color.NavTopFillBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(delegate: MainViewController) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        viewModel = AddRecipeViewController_BViewModel(dataSource: [], mainDelegate: delegate, delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(mainView)
        mainView.fillSuperView()
    }
    
    func didReturnValuesFromAddingStep(step: StepEntity) {
        //Add step to table (dataSource)
        viewModel?.dataSource.append(step)
        mainView.reloadTableSteps()

    }
    
    func handleDismiss() {
        guard let vm = viewModel else {
            return
        }
        
        guard let delegate = delegate else {
            return
        }
        
        //check steps
        if (vm.dataSource.count != 0) {
            mainView.showSaveAlertBox("You've made some progress on your Recipe.")
        } else {
            delegate.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func saveAndDismiss() {
        
        guard let vm = viewModel else {
            return
        }
        
        guard let delegate = delegate else {
            return
        }
        
        //check recipe label
        do {
            try vm.checkTextField()
            vm.recipeEntity.recipeName = mainView.recipeNameTextField?.text
        } catch AddRecipeWizardError.Empty(let message) {
            mainView.showAlertBox(message)
        } catch AddRecipeWizardError.InvalidCharacters(let message) {
            mainView.showAlertBox(message)
        } catch AddRecipeWizardError.InvalidLength(let message) {
            mainView.showAlertBox(message)
        } catch {
            mainView.showAlertBox("unexpected error")
        }
        
        //add entire step array to recipeEntity
        vm.recipeEntity.addToStep(NSSet(array: vm.dataSource))
        vm.recipeEntity.startDate = Date()
        vm.recipeEntity.pauseStartDate = vm.recipeEntity.startDate
        //save
        

        CoreDataHandler.saveContext()
        delegate.addToRecipeCollection(r: vm.recipeEntity)
        delegate.mainView.addToCollectionView()
        delegate.startTimer()
        delegate.dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        guard let delegate = delegate else {
            return
        }
        
        delegate.dismiss(animated: true, completion: nil)
    }
}
