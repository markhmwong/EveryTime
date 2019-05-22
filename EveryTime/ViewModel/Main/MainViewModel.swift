//
//  MainViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 2/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class MainViewModel {
    
    var cellSize: CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return 2.8
        default:
            return 3.0
        }
    }
    
    var dataSource: [RecipeEntity] = []

    var timer: Timer?

    weak var delegate: MainViewController?
    
    var theme: ThemeManager?
    
    init(delegate: MainViewController?, theme: ThemeManager) {
        self.delegate = delegate
        self.theme = theme
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
    
    func sortRecipeCollection(in rEntityArr: [RecipeEntity]) -> [RecipeEntity] {
        return rEntityArr.sorted { (x, y) -> Bool in
            return (x.createdDate?.compare(y.createdDate!) == .orderedAscending)
        }
    }
    
    func loadDataFromCoreData() {
        
        CoreDataHandler.getContext().perform {
            guard let rEntityArr = CoreDataHandler.fetchEntity(in: RecipeEntity.self) else {
                return
            }
            
            self.dataSource = self.sortRecipeCollection(in: rEntityArr)
            self.delegate?.mainView.willReloadTableData()
        }
    }
    
    func pauseRecipe(recipe: RecipeEntity) {
        recipe.pauseStepArr()
    }
    
    func stopRecipe(recipe: RecipeEntity) {
        recipe.unpauseStepArr()
    }
    
    func resetCurrentStepFor(recipeEntity: RecipeEntity) {
        recipeEntity.resetEntireRecipeTo(toStep: Int(recipeEntity.currStepPriority))
    }
    
    func loopRecipe(recipe: RecipeEntity) {
        
    }
    
    func handleDeleteAllRecipe() {
        let alert = UIAlertController(title: "Are you sure?", message: "This will delete every recipes", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in

            
            let deleteIndexPaths = Array(0..<self.dataSource.count).map { IndexPath(item: $0, section: 0) }
            self.dataSource.removeAll()
            self.delegate?.mainView.collView.performBatchUpdates({
                self.delegate?.mainView.collView.deleteItems(at: deleteIndexPaths)
            }, completion: nil)
            if (CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)) {
                CoreDataHandler.saveContext()
            }
        }))
        self.delegate?.present(alert, animated: true, completion: nil)
    }
    
    func clearLocalStorage() -> [IndexPath] {
        let deleteIndexPaths = Array(0..<dataSource.count).map { IndexPath(item: $0, section: 0) }
        dataSource.removeAll()
        return deleteIndexPaths
    }
}
