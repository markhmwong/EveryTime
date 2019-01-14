//
//  Protocols.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 6/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

protocol RecipeVCDelegate {
    func didReturnValues(step: StepEntity)
    func willReloadTableData()
}

protocol TimerProtocol {
    func startTimer()
    func stopTimer()
    func update()
}
