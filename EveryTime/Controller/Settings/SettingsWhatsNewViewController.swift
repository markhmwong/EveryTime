//
//  SettingsWhatsNewViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 9/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsWhatsNewViewController: ViewControllerBase {
    
    weak var delegate: SettingsViewController!
    
    var viewModel: WhatsNewViewModel?
    
    private lazy var mainView: WhatsNewView = {
        let mainView = WhatsNewView(delegate: self)
        mainView.backgroundColor = Theme.Background.Color.NavTopFillBackgroundColor
        return mainView
    }()
    
    init(delegate: SettingsViewController, viewModel: WhatsNewViewModel = WhatsNewViewModel(whatsNew: WhatsNewFactory.getLatestWhatsNew())) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
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
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
        
        mainView.updateDateLabel(date: viewModel?.whatsNew.date ?? "Unknown Date")
        mainView.updatedPatchNotes(patchNotes: viewModel?.patchNotes ?? "Unknown Notes")
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.fillSuperView()

    }
    
    func handleDismiss() {
        delegate.handleDismiss()
    }
    
    deinit {
        print("settings vc - deinitialised")
    }
}
