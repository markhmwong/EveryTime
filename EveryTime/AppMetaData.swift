//
//  AppData.swift
//  EveryTime
//
//  Created by Mark Wong on 9/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

struct AppMetaData {
    
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    
    static let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    
    static let name = Bundle.appName()
    
}
