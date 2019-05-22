//
//  TipJarViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 22/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TipJarViewController: ViewControllerBase {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
