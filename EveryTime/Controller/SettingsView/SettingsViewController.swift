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

enum Data: Int {
    case Clear = 0
}

enum SettingsSections: Int {
    case Data = 0
    case Support
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func about(row: Int) {
        switch row {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case SettingsSections.Data.rawValue:
            if (indexPath.row == Data.Clear.rawValue) {
                deleteAllAction()
            }
        case SettingsSections.Support.rawValue:
            about(row: indexPath.row)
        default:
            print("default")
        }
    }
    
    func deleteAllAction() {
        let alert = UIAlertController(title: "Are you sure?", message: "This will delete all Recipes", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                self.dismiss(animated: true, completion: {
                    self.delegate?.deleteAllRecipes()
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsViewCell
        cell.updateLabel(text: dataSource[indexPath.section][indexPath.row]!)
        if (indexPath.section == SettingsSections.Data.rawValue && indexPath.item == Data.Clear.rawValue) {
            cell.label.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 17
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SettingsSections.Data.rawValue:
            return "Data"
        case SettingsSections.Support.rawValue:
            return "Support"
        default:
            return "Other"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
}

class SettingsViewController: ViewControllerBase  {
    func share() {
        let text = "Get productive with a micromanagement timer!\n"
        let url: URL = URL(string: "https://itunes.apple.com/us/app/everytime/id1454444680?ls=1&mt=8")!
        let vc = UIActivityViewController(activityItems: [text, url], applicationActivities: [])
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    let cellId = "cellId"
    var dataSource: [[Int : String]] = [[0: "Clear All Recipes"], [0: "About", 1 : "Review In App Store", 2 : "Share with Friends"]]
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
