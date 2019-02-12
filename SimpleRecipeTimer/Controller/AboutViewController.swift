//
//  AboutViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 12/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    fileprivate var delegate: MainViewController?
    
    init(delegate: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        print("About view controller")
    }
}
