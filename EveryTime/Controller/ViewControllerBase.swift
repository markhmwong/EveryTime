//
//  ViewControllerBase.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 16/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ViewControllerBase: UIViewController, ViewControllerBaseProtocol {

    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func prepareViewController() {
        
    }
    
    func prepareView() {
        
    }
    
    func prepareAutoLayout() {
        
    }
}
