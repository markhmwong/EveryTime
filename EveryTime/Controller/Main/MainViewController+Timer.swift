//
//  MainViewController+Timer.swift
//  EveryTime
//
//  Created by Mark Wong on 23/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

extension MainViewController: TimerProtocol {
    
    func startTimer() {
        
        guard let vm = viewModel else {
            return
        }
        
        if (vm.timer == nil) {
            vm.timer?.invalidate()
            let timerInterval = 0.1
            vm.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            RunLoop.current.add(vm.timer!, forMode: .common)
        }
    }
    
    func stopTimer() {
        
        guard let vm = viewModel else {
            return
        }
        
        if (vm.timer != nil) {
            vm.timer?.invalidate()
            vm.timer = nil
        }
    }
    
    @objc func update() {
        let cells = self.mainView.collView.visibleCells as! [MainViewCell] //change this to all cells not just visible
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
