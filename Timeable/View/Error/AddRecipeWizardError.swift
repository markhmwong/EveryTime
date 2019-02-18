//
//  AddRecipeWizardError.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 14/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

enum AddRecipeWizardError: Error {
    case empty(message: String)
    case invalidCharacters(message: String)
    case invalidTextField(message: String)
    case invalidLength(message: String)
    case invalidRange(message: String)
}
