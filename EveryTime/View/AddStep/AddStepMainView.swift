//
//  AddStepMainView.swift
//  EveryTime
//
//  Created by Mark Wong on 20/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddStepMainView: UIView {
    
    weak var delegate: AddStepViewControllerBase?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var labelTextFieldTopAnchorPadding: CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return 30.0
        default:
            return 60.0
        }
    }
    
    lazy var countDownPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var labelTextField: UITextField = {
        let input = UITextField()
        input.defaultTextAttributes = Theme.Font.Recipe.TextFieldAttribute
        input.attributedPlaceholder = NSAttributedString(string: "Step Name", attributes: Theme.Font.Recipe.TextFieldAttribute)
        input.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.TextFieldAttribute)
        input.returnKeyType = UIReturnKeyType.done
        input.clearButtonMode = .never
        input.autocorrectionType = .no
        input.enablesReturnKeyAutomatically = true
        input.backgroundColor = UIColor.clear
        input.becomeFirstResponder()
        input.textAlignment = .center
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: backButton, rightNavItem: addButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "New Step", attributes: Theme.Font.Nav.Title)
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    


    init(delegate: AddStepViewControllerBase) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(navView)
        addSubview(labelTextField)
        addSubview(countDownPicker)
        preparePicker()

        navView.addSubview(titleLabel)
        
        guard let delegate = delegate else {
            return
        }
        
        labelTextField.delegate = delegate
    }
    
    func setupLayout() {
        labelTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelTextField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        labelTextField.topAnchor.constraint(equalTo: navView.bottomAnchor, constant: labelTextFieldTopAnchorPadding).isActive = true

        countDownPicker.topAnchor.constraint(equalTo: labelTextField.bottomAnchor).isActive = true
        countDownPicker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        countDownPicker.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: navView.centerYAnchor, constant: 0.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: navView.centerXAnchor, constant: 0.0).isActive = true
        
        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    func preparePicker() {
        guard let delegate = delegate else {
            return
        }
        
        let hoursLabel: UILabel = UILabel()
        hoursLabel.text = "hours"
        
        let minutesLabel: UILabel = UILabel()
        minutesLabel.text = "min."
        
        let secondsLabel: UILabel = UILabel()
        secondsLabel.text = "sec."
        
        let labelDict: [Int: UILabel] = [
            1 : hoursLabel,
            3 : minutesLabel,
            5 : secondsLabel
        ]
        
        countDownPicker.delegate = delegate
        countDownPicker.dataSource = delegate
        countDownPicker.translatesAutoresizingMaskIntoConstraints = false
        countDownPicker.setPickerLabels(labels: labelDict, containedView: delegate.view)
        addSubview(countDownPicker)
    }
    
    @objc func handleAdd() {
        guard let delegate = delegate else {
            return
        }
        delegate.grabValuesFromInput()
    }
    
    @objc func handleCancel() {
        guard let delegate = delegate else {
            return
        }
        delegate.handleCancel()
    }
}
