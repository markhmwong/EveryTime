//
//  WhatsNewViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 8/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

class WhatsNewViewModel {
    
    var whatsNew: WhatsNewProtocol
    
    var patchNotes: String
    
    init(whatsNew: WhatsNewProtocol = WhatsNewFactory.getLatestWhatsNew()) {
        self.whatsNew = whatsNew
        self.patchNotes = whatsNew.patchNotes.reduce("") { (curr, next) -> String in
            return "• \(next)" + "\n\n\(curr)"
        }
    }
}
