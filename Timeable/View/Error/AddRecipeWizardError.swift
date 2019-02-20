//
//  AddRecipeWizardError.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 14/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

enum AddRecipeWizardError: Error {
    case Empty(message: String)
    case InvalidCharacters(message: String)
    case InvalidTextField(message: String)
    case InvalidLength(message: String)
    case InvalidRange(message: String)
}

enum StepOptionsError: Error {
    case StepAlreadyComplete(message: String)
}
