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
        "1.1.19" : WhatsNewDetails.WhatsNew1_1_19(),
        "1.1.18" : WhatsNewDetails.WhatsNew1_1_18(),
        "1.1.17" : WhatsNewDetails.WhatsNew1_1_17(),
        "1.1.16" : WhatsNewDetails.WhatsNew1_1_16(),
        "1.1.15" : WhatsNewDetails.WhatsNew1_1_15(),
        "1.1.14" : WhatsNewDetails.WhatsNew1_1_14(),
        "1.1.13" : WhatsNewDetails.WhatsNew1_1_13(),
    ]
    
    static func getLatestWhatsNew(version: String = AppMetaData.version!) -> WhatsNewProtocol {
        let appVersion = AppMetaData.version!
        return whatsNewDictionary[appVersion]!
    }
}

/// List patch notes as least important to most important.
struct WhatsNewDetails {
    
    struct WhatsNew1_1_19: WhatsNewProtocol {
        
        let date: String = "May 24, 2019"
        
        let version: String = "1.1.19"
        
        let build: String = "1.20"
        
        let patchNotes: [String] = [
            "Minor UI adjustments",
            "A tip jar was added",
            "A new grape theme is now available",
        ]
    }
    
    struct WhatsNew1_1_18: WhatsNewProtocol {
        
        let date: String = "May 22, 2019"
        
        let version: String = "1.1.18"
        
        let build: String = "1.19"
        
        let patchNotes: [String] = [
            "Two new themes, White and Orange (Paid)",
            "Reset button now on the main screen. This resets the current Step the Recipe is running",
            "Recipe controls have now stick to the top when scrolling",
        ]
    }
    
    struct WhatsNew1_1_17: WhatsNewProtocol {
        
        let date: String = "May 21, 2019"
        
        let version: String = "1.1.17"
        
        let build: String = "1.18"
        
        let patchNotes: [String] = [
            "Other Minor UI Changes - The highlight on the main view, has been removed. Full screen icon changed. Hue of Light Mint and Deep Mint adjusted. The pause was made larger",
            "A new Recipe would zero until it has begun - fixed, time now shows appropriately",
            "App reviewing fix",
            "Time formats changed with colons to express hours, minutes, seconds",
            "Removed completion indicators. Completed steps are now show in faded text. This leaves the step name and time in a larger and clear font",
            "It's now possible to preview the theme before applying and paying",
            "Added purchaseable themes. Two new paid themes, Deep Mint for OLED screens and Neutral for the grayscale lovers, with more free and paid themes coming soon",
            "Add Recipe fix - it may have bugged out in 1.1.16 during the implementation of theming",
        ]
    }
    
    struct WhatsNew1_1_16: WhatsNewProtocol {
        
        let date: String = "May 12, 2019"
        
        let version: String = "1.1.16"
        
        let build: String = "1.17"
        
        let patchNotes: [String] = [
            "Minor UI Improvements",
            "All new theming feature beginning with Dark Mint as our first new theme. Dark Mint brings a darker colour palette bringing easier viewing at night and less eye strain. This update will begin a series of new themes for the future.",
        ]
    }
    
    struct WhatsNew1_1_15: WhatsNewProtocol {
        
        let date: String = "May 3, 2019"
        
        let version: String = "1.1.15"
        
        let build: String = "1.15"
        
        let patchNotes: [String] = [
            "Add Start/Pause Button to fullscreen mode",
            "Internal house keeping that you won't see",
            "Minor UI Improvements",
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
