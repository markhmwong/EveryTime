//
//  AboutViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 12/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

enum Settings: Int {
    case About = 0
    case Review
    case Share
}

class SettingsViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource {
    func share() {
        let text = "Get productive with a micromanagement timer!\n"
        let url: URL = URL(string: "https://itunes.apple.com/us/app/everytime/id1454444680?ls=1&mt=8")!
        let vc = UIActivityViewController(activityItems: [text, url], applicationActivities: [])
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case Settings.About.rawValue:
            let vc = AboutViewController(nibName: nil, bundle: nil)
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        case Settings.Review.rawValue:
            SKStoreReviewController.requestReview()
        case Settings.Share.rawValue:
            share()
        default:
            print("default")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsViewCell
        cell.updateLabel(text: dataSource[indexPath.row]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 17
    }
    
    let cellId = "cellId"
    var dataSource: [Int : String] = [0: "About", 1 : "Review In App Store", 2 : "Share with Friends"]
    fileprivate var delegate: MainViewController?
    fileprivate lazy var mainView: SettingsMainView = {
        let view = SettingsMainView(delegate: self)
        view.backgroundColor = UIColor.white
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
        
        //The super will call prepare_ functions
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
    }
    
    func handleDismiss() {
        guard let mvc = delegate else {
            return
        }
        
        mvc.startTimer()
        dismiss(animated: true, completion: nil)
    }
    

}