//
//  AboutViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 12/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

import MessageUI

enum Settings: Int {
    case About = 0
    case Review
    case Share
    case Feedback
}

enum Data: Int {
    case Clear = 0
}

enum SettingsSections: Int {
    case Data = 0
    case Support
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

class SettingsViewController: ViewControllerBase  {
    var settingsViewModel: SettingsViewModel!
    private var delegate: MainViewController?
    private lazy var mainView: SettingsMainView = {
        let view = SettingsMainView(delegate: self)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(delegate: MainViewController, viewModel: SettingsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.settingsViewModel = viewModel
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
    
    // leave these functions here. place data type like setToRecipients in a variable
    func emailFeedback() {        
        let picker: MFMailComposeViewController = MFMailComposeViewController(nibName: nil, bundle: nil)
        picker.mailComposeDelegate = self
        picker.setToRecipients([settingsViewModel.emailToRecipient])
        picker.setSubject(settingsViewModel.emailSubject)

        picker.setMessageBody(settingsViewModel.emailBody(), isHTML: true)
        present(picker, animated: true, completion: nil)
    }
    
    func share() {
        let text = settingsViewModel.shareText
        let url: URL = URL(string: settingsViewModel.shareURL)!
        let vc = UIActivityViewController(activityItems: [text, url], applicationActivities: [])
        
        self.present(vc, animated: true, completion: nil)
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
}
