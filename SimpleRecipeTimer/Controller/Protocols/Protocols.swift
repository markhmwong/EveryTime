//
//  Protocols.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 6/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

protocol RecipeVCDelegate {
    func didReturnValues(step: Step)
    func willReloadTableData()
}

protocol TimerProtocol {
    var timer: Timer? { get set }
    func startTimer()
    func stopTimer()
    func update()
}
