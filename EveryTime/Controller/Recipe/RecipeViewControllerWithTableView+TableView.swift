//
//  RecipeViewControllerWithTableView+TableView.swift
//  EveryTime
//
//  Created by Mark Wong on 3/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension RecipeViewControllerWithTableView: UITableViewDelegate, UITableViewDataSource {
    //switches the objects between cells. Allows the user to reorganise the order.
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
            if (indexPath.row == self.recipe.currStepPriority) {
                let sortedSet = self.recipe.sortStepsByPriority()
                let timeElapsedInStep = sortedSet[indexPath.row].totalTime - self.recipe.currStepTimeRemaining
                self.recipe.startDate?.addTimeInterval(timeElapsedInStep)
            }
            
            let id = "\(self.recipe.recipeName!).\(self.recipe.createdDate!)"
            
            if let vm = self.viewModel {
                self.recipe.removeFromStep(vm.dataSource[indexPath.row])
                vm.dataSource.remove(at: indexPath.row)
                self.recipe.reoganiseStepsInArr(fromIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.recipe.sumStepsForExpectedElapsedTime()
                LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
                CoreDataHandler.saveContext()
                complete(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reset = UIContextualAction(style: .normal, title: "reset") { (action, view, complete) in
            var indexPathsToReloadArr: [IndexPath] = []
            
            guard let vm = self.viewModel else {
                return
            }
            
            self.recipe.wasReset = true
            indexPathsToReloadArr = self.recipe.resetEntireRecipeTo(toStep: vm.stepSelected)
            self.startTimer()
            
            let id = "\(self.recipe.recipeName!).\(self.recipe.createdDate!)"
            LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : self.recipe.recipeName!], timeRemaining: self.recipe.totalTimeRemaining)
            
            CoreDataHandler.saveContext()
            DispatchQueue.main.async {
                self.mainView.tableView.reloadRows(at: indexPathsToReloadArr, with: .none)
                self.executeBottomViewState(.ShowAddStep)
                complete(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [reset])
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard let vm = viewModel else {
            return
        }
        
        let sourceObj = vm.dataSource[sourceIndexPath.row]
        let destinationObj = vm.dataSource[destinationIndexPath.row]
        
        let tempDestinationPriority = destinationObj.priority
        destinationObj.priority = sourceObj.priority
        sourceObj.priority = tempDestinationPriority
        
        vm.dataSource.remove(at: sourceIndexPath.row)
        vm.dataSource.insert(sourceObj, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            recipeControlsView = RecipeControlsView(delegate: self, theme: viewModel?.theme)
            return recipeControlsView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainView.stepCellId, for: indexPath) as! RecipeViewCell
        if let vm = viewModel {
            cell.theme = vm.theme
            cell.selectedBackgroundView?.backgroundColor = vm.theme?.currentTheme.tableView.selectedCellColor
            cell.entity = vm.dataSource[indexPath.item]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return view.bounds.height / 10
        default:
            return view.bounds.height / 13
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let vm = viewModel else {
            return 120.0
        }
        return vm.rowHeight
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = viewModel else {
            return
        }
        
        DispatchQueue.main.async {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//            self.mainView.headerView.enableStepOptions()
            self.recipeControlsView.enableStepOptions()
        }
        
        vm.stepSelected = indexPath.row
        recipeOptionsViewController?.isEditOptionEnabled()
        vm.setStep()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        changeBottomViewStateWhileDragging()
    }
    
    func heightForRecipeModal() -> CGFloat {
        guard let recipeOptions = recipeOptionsViewController else { return 0.0 }
        let heightOfRecipeOptionsModal = heightForCell() * CGFloat( recipeOptions.dataSource.count)
        return heightOfRecipeOptionsModal
    }
    
    func heightForCell() -> CGFloat {
        guard let recipeOptions = recipeOptionsViewController else { return 0.0 }
        return recipeOptions.tableView.rowHeight
    }
}


