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
        
        let build: String = "1.11"
        
        let patchNotes: [String] = [
            "To be done. Apple Watch. Forward and back stepping. Whats new view controller pop up"
        ]
    }
    
    struct WhatsNew1_1_13: WhatsNewProtocol {
        
        let date: String = "April 9, 2019"
        
        let version: String = "1.1.13"
        
        let build: String = "1.11"
        
        let patchNotes: [String] = [
            "Minor UI changes",
            "The Recipe view now contains a button to show a larger view of the header view that shows the current timer and the next timer. Along with controls to adjust the timer.",
            "When creating a new Recipe, you can now chose whether the timer begins immediately or a time of your choosing.",
            "Names of the recipes/steps can now be edited",
            "A Whats New section in the Settings to keep updated on the latest changes to the app.",
            "When creating a new Recipe you can now copy an existing step that was already made.",
        ]
    }
    
}
