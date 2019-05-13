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
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "What's New", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.title)
        return label
    }()
    
    lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil, titleLabel: titleLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var patchNotesTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isSelectable = false
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var patchNotesHeader: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: SettingsWhatsNewViewController) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        guard let vm = delegate?.viewModel else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = vm.theme?.currentTheme.generalBackgroundColour
        addSubview(navView)
        addSubview(textContainer)
        addSubview(patchNotesHeader)
        addSubview(dateLabel)
        navView.addSubview(titleLabel)
        textContainer.addSubview(patchNotesTextView)
        patchNotesHeader.attributedText = NSAttributedString(string: "The Highlights of \(AppMetaData.version!)", attributes: vm.theme?.currentTheme.font.bodyText)
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
        titleLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: navView.centerYAnchor, centerX: navView.centerXAnchor, padding: .zero, size: .zero)

    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    func updatedPatchNotes(patchNotes: String) {
        guard let vm = delegate?.viewModel else {
            return
        }
        patchNotesTextView.attributedText = NSAttributedString(string: patchNotes, attributes: vm.theme?.currentTheme.font.bodyText)
    }
    
    func updateDateLabel(date: String) {
        guard let vm = delegate?.viewModel else {
            return
        }
        dateLabel.attributedText = NSAttributedString(string: date, attributes: vm.theme?.currentTheme.font.bodyText)
    }
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    deinit {
    }
}
