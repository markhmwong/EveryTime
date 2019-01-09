//
//  StepsProtocol.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 1/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import Foundation

protocol StepsProtocol {
    var isPausedPrimary: Bool { get set }
    var isRepeated: Bool { get set }
    var startDate: Date { get set }
}

protocol StepsTimeProtocol {
    func updateExpiry()
    func updatePauseState()
    func resetTimer()
}
