//
//  RecipeViewControllerWithTableView+ScrollView.swift
//  EveryTime
//
//  Created by Mark Wong on 3/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit


extension RecipeViewControllerWithTableView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        executeState(state: .Hide)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        executeState(state: .Show)
    }
    
    func executeState(state: ScrollingState) {
        let offset: CGFloat = 50.0
        switch state {
        case .Show:
            mainView.handleStepButtonAnimation(offset: -offset)
        case .Hide:
            mainView.handleStepButtonAnimation(offset: offset)
        case .Idle:
            break
        }
    }
    
    func changeBottomViewStateWhileDragging() {
        
        guard let viewState = viewModel?.bottomViewState else {
            return
        }
        
        if (viewState == .ShowStepOptions) {
            executeBottomViewState(.ShowAddStep)
        }
    }
    
    func executeBottomViewState(_ viewState: BottomViewState) {
        let offset: CGFloat = 50.0
        switch viewState {
        case .ShowStepOptions:
            mainView.handleStepButtonAnimation(offset: offset)
        case .ShowAddStep:
            mainView.handleStepButtonAnimation(offset: -offset)
        }
        
        guard let vm = viewModel else {
            return
        }
        vm.bottomViewState = viewState
    }
}
