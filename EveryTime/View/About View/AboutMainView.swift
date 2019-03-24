//
//  AboutMainView.swift
//  EveryTime
//
//  Created by Mark Wong on 21/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit


class AboutMainView: UIView {
    private var delegate: AboutViewController?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.isSelectable = false
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = delegate
        tableView.delegate = delegate
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    lazy var navView: NavView = {
       let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let appName = Bundle.appName()
    private let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    private lazy var details = """
    Thanks for using \(appName) v\(appVersion ?? "").\n
    I'm not the best cook but I love a good a steak. The first bite always gets me when you've cooked it to your liking, and thats the problem it wasn't always the way it was made previously; I made this app to keep track of the amount of times I had flipped my steak for it to cook evenly knowing Gordan Ramsey would kick my arse for overcooking it.\n
    I do really hope you enjoy using it and get the most of out it, whether you need to track your own cooking, an execise routine or a series of steps that you simply can never get down perfectly. This was made for that in mind.\n
    
    Privacy.\n
    This application does not contain any code that extracts sensitive data from your phone to an external server. It will not ask for your permission to use your camera, contacts, photo albums. If it does, then you are not using an official build. Though currently I do not track any user interaction I may in the future to see how a user interacts with my application.
    
    Bugs.\n
    Please report any bugs to hello@whizbangapps.com.
    
    Contact.\n
    Twitter: @markhmwong\nGithub: @markhmwong\nWebsite: https://www.whizbangapps.com/\(appName)
    """
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: AboutViewController) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(navView)
        textView.attributedText = NSAttributedString(string: details, attributes: Theme.Font.About.Text)
        addSubview(textView)
        shareButton.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        addSubview(shareButton)
        addSubview(tableView)
        
        tableView.register(AboutViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    func setupAutoLayout() {
        let safeAreaGuideLayout = safeAreaLayoutGuide
        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        navView.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Theme.View.Nav.Height).isActive = true
        
        textView.anchorView(top: nil, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: centerYAnchor, centerX: nil, padding: .zero, size: .zero)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        
        shareButton.topAnchor.constraint(equalTo: safeAreaGuideLayout.topAnchor).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        tableView.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    @objc func handleShareButton() {
        delegate?.share()
    }
}
