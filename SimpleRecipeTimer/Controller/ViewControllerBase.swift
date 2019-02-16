//
//  ViewControllerBase.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 16/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ViewControllerBase: UIViewController, ViewControllerBaseProtocol {
    func prepareView() {
        
    }
    
    func prepareViewController() {
        
    }
    
    func prepareAutoLayout() {
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewController()
        prepareView()
        prepareAutoLayout()
    }
}
