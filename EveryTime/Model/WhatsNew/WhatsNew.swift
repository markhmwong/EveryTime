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
        "1.1.14" : WhatsNewDetails.WhatsNew1_1_14(),
        "1.1.13" : WhatsNewDetails.WhatsNew1_1_13()
    ]
    
    static func getLatestWhatsNew(version: String = AppMetaData.version!) -> WhatsNewProtocol {
        let appVersion = AppMetaData.version!
        return whatsNewDictionary[appVersion]!
    }
}

struct WhatsNewDetails {
    
    struct WhatsNew1_1_14: WhatsNewProtocol {
        
        let date: String = ""
        
        let version: String = "1.1.14"
        
        let build: String = "1.12"
        
        let patchNotes: [String] = [
            "To be done. Apple Watch. Forward and back stepping. Whats new view controller pop up"
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
