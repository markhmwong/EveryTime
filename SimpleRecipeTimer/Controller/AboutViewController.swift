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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewController()
        prepareView()
    }
    
    func prepareView() {
        let textView = UITextView()
        textView.text = """
        Thank you for using Timeable.\n
        I'm not the best cook but I love a good a steak. The first bite always gets me when you've cooked it to your liking, and thats the problem it wasn't always to my liking; I made this app to keep track of the amount of times I had flipped my steak for it to cook evenly knowing Gordan Ramsey would kick my arse for overcooking it.\n
        I do really hope you enjoy using it and get the most of out it, whether you need to track your own cooking, an execise routine or a series of steps that you simply can never get down perfectly. This was made for that in mind.\n
        
        Privacy.\n
        A big issue in recent times. This application does not contain any code that takes data from your phone. It will not ask for your permission to use your camera, contacts, photo albums. If it does, then you are not using an official build.
        
        Bugs.\n
        Please report any bugs to hello@whizbangapps.com.
        
        Contact.\n
        Twitter: @markhmwong Github: @markhmwong Website: https://www.whizbangapps.com
        """
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    func prepareViewController() {
        view.backgroundColor = UIColor.white
    }
}
