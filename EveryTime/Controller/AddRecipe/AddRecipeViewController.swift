//
//  AddRecipeViewController_B.swift
//  EveryTime
//
//  Created by Mark Wong on 12/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {
    
    var viewModel: AddRecipeViewModel?
    
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
        viewModel = AddRecipeViewModel(dataSource: [], mainDelegate: delegate, delegate: self)
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
    
    func didEditStep(step: StepEntity, rowToUpdate: Int) {
        viewModel?.dataSource[rowToUpdate] = step
        mainView.tableView.reloadRows(at: [IndexPath(row: rowToUpdate, section: 2)], with: .none)
    }
    
    func handleDismiss() {
        guard let vm = viewModel, let delegate = delegate else {
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
        guard let vm = viewModel, let delegate = delegate else {
            return
        }
        
        //check recipe label
        do {
            try vm.checkTextField()
            //add entire step array to recipeEntity
            vm.recipeEntity.recipeName = mainView.recipeNameTextField?.text
            
            let firstStep = vm.dataSource[0]
            vm.recipeEntity.currStepName = firstStep.stepName ?? "Step Name"
            vm.recipeEntity.addToStep(NSSet(array: vm.dataSource))
            vm.recipeEntity.startDate = Date()
            vm.recipeEntity.pauseStartDate = vm.recipeEntity.startDate
            //save
            CoreDataHandler.saveContext()
            delegate.addToRecipeCollection(r: vm.recipeEntity)
            delegate.mainView.addToCollectionView()
            delegate.startTimer()
            delegate.dismiss(animated: true, completion: nil)
        } catch AddRecipeWizardError.Empty(let message) {
            mainView.showAlertBox(message)
        } catch AddRecipeWizardError.InvalidCharacters(let message) {
            mainView.showAlertBox(message)
        } catch AddRecipeWizardError.InvalidLength(let message) {
            mainView.showAlertBox(message)
        } catch {
            mainView.showAlertBox("unexpected error")
        }
    }
    
    func cancel() {
        guard let delegate = delegate else {
            return
        }
        
        delegate.dismiss(animated: true, completion: nil)
    }
    
    func copyWith(step: StepEntity) {
        
        guard let vm = viewModel else {
            return
        }
        
        let (h,m,s) = step.getRawValues()
        let newStep = StepEntity(name: step.stepName ?? "Step Name", hours: h, minutes: m, seconds: s, priority: Int16(vm.dataSource.count))
        vm.addStepToDataSource(step: newStep)
        mainView.reloadTableSteps()
    }
}
