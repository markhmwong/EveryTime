//
//  SettingsViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 1/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewModel {
    let appName = Bundle.appName()
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    let deviceType = UIDevice().type
    
    let emailToRecipient: String = "hello@whizbangapps.com"
    let emailSubject: String = "EveryTime Feedback"
    
    let shareText = "Get productive with a micromanagement timer!\n"
    let shareURL = "https://itunes.apple.com/us/app/everytime/id1454444680?ls=1&mt=8"
    var dataSource: [[Int : String]] = [[:]]
    
    init(dataSource: [[Int: String]] = [[0: "Unknown Table Datasource"]]) {
        self.dataSource = dataSource

    }
    
    func emailBody() -> String {
        return """
        </br>
        </br>\(appName): \(appVersion!)\n
        </br>iOS: \(systemVersion)
        </br>Device: \(deviceType.rawValue)
        """
    }
}
