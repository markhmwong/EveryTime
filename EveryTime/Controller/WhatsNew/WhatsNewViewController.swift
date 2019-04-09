//
//  WhatsNewViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 8/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class WhatsNewViewController: ViewControllerBase {
    
    var viewModel: WhatsNewViewModel?
    var mainView: WhatsNewView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModel: WhatsNewViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleDismiss() {
        
    }
}
