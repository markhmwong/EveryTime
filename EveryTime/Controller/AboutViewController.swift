//
//  AboutViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 12/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewController: ViewControllerBase {
    
    fileprivate var delegate: MainViewController?
    fileprivate lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.isSelectable = false
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    init(delegate: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The super class will call prepare_ functions
    }
    
    override func prepareView() {
        super.prepareView()
        let appName = Bundle.appName()
        let details = """
        Thanks for using \(appName).\n
        I'm not the best cook but I love a good a steak. The first bite always gets me when you've cooked it to your liking, and thats the problem it wasn't always the way it was made previously; I made this app to keep track of the amount of times I had flipped my steak for it to cook evenly knowing Gordan Ramsey would kick my arse for overcooking it.\n
        I do really hope you enjoy using it and get the most of out it, whether you need to track your own cooking, an execise routine or a series of steps that you simply can never get down perfectly. This was made for that in mind.\n
        
        Privacy.\n
        This application does not contain any code that extracts sensitive data from your phone to an external server. It will not ask for your permission to use your camera, contacts, photo albums. If it does, then you are not using an official build. Though currently I do not track any user interaction I may in the future to see how a user interacts with my application.
        
        Bugs.\n
        Please report any bugs to hello@whizbangapps.com.
        
        Contact.\n
        Twitter: @markhmwong\nGithub: @markhmwong\nWebsite: https://www.whizbangapps.com/\(appName)
        """
        textView.attributedText = NSAttributedString(string: details, attributes: Theme.Font.About.Text)
        view.addSubview(textView)
        
        view.addSubview(dismissButton)
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        let safeAreaGuideLayout = view.safeAreaLayoutGuide
        dismissButton.topAnchor.constraint(equalTo: safeAreaGuideLayout.topAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
    }
    
    @objc func handleDismiss() {
        guard let mvc = delegate else {
            return
        }
        
        mvc.startTimer()
        dismiss(animated: true, completion: nil)
    }
}
