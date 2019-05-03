//
//  WhatsNew.swift
//  EveryTime
//
//  Created by Mark Wong on 8/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

protocol WhatsNewProtocol {
    
    var date: String { get }

    var version: String { get }
    
    var build: String { get }
    
    var patchNotes: [String] { get }
    
}

struct WhatsNewFactory {
    
    static let whatsNewDictionary: [ String : WhatsNewProtocol ] = [
        "1.1.15" : WhatsNewDetails.WhatsNew1_1_15(),
        "1.1.14" : WhatsNewDetails.WhatsNew1_1_14(),
        "1.1.13" : WhatsNewDetails.WhatsNew1_1_13()
    ]
    
    static func getLatestWhatsNew(version: String = AppMetaData.version!) -> WhatsNewProtocol {
        let appVersion = AppMetaData.version!
        return whatsNewDictionary[appVersion]!
    }
}

/// List patch notes from least important first
struct WhatsNewDetails {
    
    struct WhatsNew1_1_15: WhatsNewProtocol {
        
        let date: String = ""
        
        let version: String = "1.1.15"
        
        let build: String = "1.15"
        
        let patchNotes: [String] = [
            "Internal Cleaning",
        ]
    }
    
    struct WhatsNew1_1_14: WhatsNewProtocol {
        
        let date: String = "May 2, 2019"
        
        let version: String = "1.1.14"
        
        let build: String = "1.14"
        
        let patchNotes: [String] = [
            "Minor UI Changes - You may notice slight changes to fonts, colours and layout. Any major changes will be listed",
            "Existing and new steps can now be edited",
            "New Recipe options menu",
            "Steps have the ability to either skip a step or return to the previous step while in full screen mode",
            "While creating a new Recipe, it is now easier to recreate existing steps by using the copy button",
            "New Recipes will now show the correct step name rather than an unknown",
        ]
    }
    
    struct WhatsNew1_1_13: WhatsNewProtocol {
        
        let date: String = "April 16, 2019"
        
        let version: String = "1.1.13"
        
        let build: String = "1.13"
        
        let patchNotes: [String] = [
            "Minor UI changes throughout the app to improve consistency and clarity",
            "Email feedback now available",
            "Full Screen - A full screen view of the Recipe. The new feature contains a minimal design of larger text for clarity with details of the current step and next step.",
            "Auto Start - When creating a new Recipe, you can now chose whether the timer begins immediately or a time of your choosing.",
            "Whats New - A Whats New section in Settings to keep updated on the latest changes to the app.",
            "UI Changes - Adding a recipe now made easier",
        ]
    }
    
}
