//
//  AddRecipeViewController_BViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 15/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeViewModel {
    
    var recipeEntity: RecipeEntity
    
    var dataSource: [StepEntity]
    
    var delegate: AddRecipeViewController?
    
    var theme: ThemeManager?
    
    init(dataSource: [StepEntity] = [], mainDelegate: MainViewController?, delegate: AddRecipeViewController?, theme: ThemeManager?) {
        self.dataSource = dataSource
        self.recipeEntity = RecipeEntity(name: "Recipe \(mainDelegate?.viewModel?.dataSource.count ?? 0)")
        self.delegate = delegate
        self.theme = theme
    }
    
    func checkTextField() throws {
        
        guard let name = delegate?.mainView.recipeNameTextField?.text else {
            throw AddRecipeWizardError.InvalidTextField(message: "empty recipe name")
        }
        
        let invalidCharacterSet = CharacterSet(charactersIn: "!@#$%^&*(()-_=+][{}';/?.,~`")
        if (name.rangeOfCharacter(from: invalidCharacterSet) != nil) {
            throw AddRecipeWizardError.InvalidCharacters(message: "invalid character(s)")
        }
        
        if (name.count > 20) {
            throw AddRecipeWizardError.InvalidLength(message: "name is too long")
        }
        
        if (name.isEmpty) {
            throw AddRecipeWizardError.Empty(message: "empty recipe name")
        }
    }
    
    
    func getStepAtIndex(index: Int) -> StepEntity? {
        if (index >= 0 && index <= dataSource.count) {
            return dataSource[index]
        } else {
            print("cannot get step at index")
            return nil
        }
    }
    
    func addStepToDataSource(step: StepEntity) {
        dataSource.append(step)
    }
}
