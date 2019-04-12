//
//  WhatsNewView.swift
//  EveryTime
//
//  Created by Mark Wong on 9/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class WhatsNewView: UIView {
    
    private weak var delegate: SettingsWhatsNewViewController?

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var patchNotesTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Theme.Background.Color.Clear
        view.isSelectable = false
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = Theme.Background.Color.Clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var patchNotesHeader: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "The Highlights of \(AppMetaData.version!)", attributes: Theme.Font.PatchNotes.SubHeading)
        view.backgroundColor = Theme.Background.Color.Clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Background.Color.Clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupAutoLayout()
    }
    
    convenience init(delegate: SettingsWhatsNewViewController) {
        self.init(frame: .zero)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        addSubview(navView)
        addSubview(textContainer)
        addSubview(patchNotesHeader)
        addSubview(dateLabel)
        textContainer.addSubview(patchNotesTextView)
    }
    
    private func setupAutoLayout() {
        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true
        textContainer.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 50.0, left: 10.0, bottom: -10.0, right: -10.0), size: .zero)
        patchNotesHeader.anchorView(top: textContainer.topAnchor, bottom: nil, leading: textContainer.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        dateLabel.anchorView(top: patchNotesHeader.bottomAnchor, bottom: nil, leading: textContainer.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        patchNotesTextView.anchorView(top: dateLabel.bottomAnchor, bottom: textContainer.bottomAnchor, leading: textContainer.leadingAnchor, trailing: textContainer.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 50.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    func updatedPatchNotes(patchNotes: String) {
        patchNotesTextView.attributedText = NSAttributedString(string: patchNotes, attributes: Theme.Font.PatchNotes.Text)
    }
    
    func updateDateLabel(date: String) {
        dateLabel.attributedText = NSAttributedString(string: date, attributes: Theme.Font.PatchNotes.Date)
    }
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    deinit {
        print("deinitialised")
    }
}
