//
//  MainViewController+UICollectionView.swift
//  EveryTime
//
//  Created by Mark Wong on 22/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainViewCell
        cell.animateCellForSelection()
        
        if let vm = viewModel {
            if let theme = vm.theme {
                let vc = RecipeViewControllerWithTableView(recipe: vm.dataSource[indexPath.item], delegate: self, indexPath: indexPath, viewModel: RecipeViewModel(theme: theme))
                
                //        horizontalDelegate.dismissInteractor  = HorizontalTransitionInteractor(viewController: vc) // to be worked on. issue with timer when swiping to dismiss
                vc.transitioningDelegate = horizontalDelegate
                vc.modalPresentationStyle = .custom
                
                stopTimer()
                self.present(vc, animated: true, completion: nil)
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellIds.RecipeCell.rawValue, for: indexPath) as! MainViewCell
        cell.theme = viewModel?.theme
        cell.resetButton.tintColor = viewModel?.theme?.currentTheme.tableView.cellTextColor
        cell.backgroundColor = viewModel?.theme?.currentTheme.tableView.cellBackgroundColor
        cell.mainViewController = self
        cell.entity = viewModel?.dataSource[indexPath.row]
        cell.cellForIndexPath = indexPath
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemSpacing: CGFloat = 0.0
        let verticalSpacing: CGFloat = 0.0//10.0
        return UIEdgeInsets(top: verticalSpacing, left: itemSpacing, bottom: verticalSpacing, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 0.0//8.0 //20 for left and right side
        let itemsPerRow: CGFloat = 0.0//5.0
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsPerRow)
        
        guard let vm = viewModel else {
            return CGSize(width: width, height: width / 2.6)
        }
        
        return CGSize(width: width, height: width / vm.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
