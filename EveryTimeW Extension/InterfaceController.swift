//
//  InterfaceController.swift
//  EveryTimeW Extension
//
//  Created by Mark Wong on 16/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import WatchKit
import UIKit


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Watch OS!")
        titleLabel.setText("My First WatchOS App")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
