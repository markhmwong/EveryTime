//
//  AboutVC.swift
//  EveryTime
//
//  Created by Mark Wong on 24/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewController: ViewControllerBase {
    
    private lazy var mainView: AboutView = {
        let mainView = AboutView(delegate: self)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.backgroundColor = UIColor.white
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        
        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
