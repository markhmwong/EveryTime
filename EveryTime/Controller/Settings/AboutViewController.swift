//
//  AboutVC.swift
//  EveryTime
//
//  Created by Mark Wong on 24/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewModel {
    var theme: ThemeManager?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let appName = AppMetaData.name
    
    private let appVersion = AppMetaData.version
    
    private let appBuild = AppMetaData.build
    
    lazy var details = """
    Thanks for using \(appName) v\(appVersion ?? " unknown"), build \(appBuild ?? "unknown").\n
    I'm not the best cook but I love a good a steak. The first bite always gets me when you've cooked it to your liking, and thats the problem it wasn't always the way it was made previously; I made this app to keep track of the amount of times I had flipped my steak for it to cook evenly knowing Gordan Ramsey would kick my arse for overcooking it.\n
    I do really hope you enjoy using it and get the most of out it, whether you need to track your own cooking, an execise routine or a series of steps that you simply can never get down perfectly. This was made for that in mind.\n
    
    Privacy.\n
    This application does not contain any code that extracts sensitive data from your phone to an external server. It will not ask for your permission to use your camera, contacts, photo albums. If it does, then you are not using an official build. Though currently I do not track any user interaction I may in the future to see how a user interacts with my application.
    
    Bugs.\n
    Please report any bugs to hello@whizbangapps.com.
    
    Contact.\n
    Twitter: @markhmwong\nWebsite: https://www.whizbangapps.com/\(appName)
    """
    
    init(theme: ThemeManager) {
        self.theme = theme
    }
}

class AboutViewController: ViewControllerBase {
    
    var viewModel: AboutViewModel?
    
    private lazy var mainView: AboutView = {
        let mainView = AboutView(delegate: self)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(viewModel: AboutViewModel? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareViewController() {
        super.prepareViewController()
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.fillSuperView()
//        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
//        print("deinitialised")
    }
}
