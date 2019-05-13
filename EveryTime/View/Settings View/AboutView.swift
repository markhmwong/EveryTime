//
//  AboutView.swift
//  EveryTime
//
//  Created by Mark Wong on 24/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutView: UIView {
    

    
    private weak var delegate: AboutViewController?

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
        label.attributedText = NSAttributedString(string: "About", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.title)
        return label
    }()
    
    lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil, titleLabel: titleLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isSelectable = false
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private func setupView() {

        guard let vm = delegate?.viewModel else {
            return
        }
        backgroundColor = vm.theme?.currentTheme.generalBackgroundColour
        addSubview(navView)
        textView.attributedText = NSAttributedString(string: vm.details, attributes: vm.theme?.currentTheme.font.bodyText)
        addSubview(textView)
    }
    
    private func setupAutoLayout() {
        guard let vm = delegate?.viewModel else {
            return
        }
        let navTopConstraint = !vm.appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !vm.appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: textView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true

        textView.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        titleLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: navView.centerYAnchor, centerX: navView.centerXAnchor, padding: .zero, size: .zero)
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        guard let vm = delegate?.viewModel else {
            return
        }
        if (vm.appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
}
