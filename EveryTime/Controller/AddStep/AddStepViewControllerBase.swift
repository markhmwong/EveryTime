//
//  AddStepViewControllerBase.swift
//  EveryTime
//
//  Created by Mark Wong on 19/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddStepViewControllerBase: ViewControllerBase, UITextFieldDelegate {
    
    var viewModel: AddStepViewModel!
    //    private var mainView: AddStepMainView!
    //MARK: VARIABLES
    private let maxCharacterLimitForNameLabel = 30
    private let minCharacterLimitForNameLabel = 1
//    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

//    var recipeViewControllerWithTableViewDelegate: RecipeViewControllerWithTableView?
    
    //UIPickerView
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
//    var labelTextFieldTopAnchorPadding: CGFloat {
//        switch UIDevice.current.screenType.rawValue {
//        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
//            return 30.0
//        default:
//            return 60.0
//        }
//    }

    
//    lazy var countDownPicker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        return picker
//    }()
//
//    lazy var labelTextField: UITextField = {
//        let input = UITextField()
//        input.defaultTextAttributes = Theme.Font.Recipe.TextFieldAttribute
//        input.attributedPlaceholder = NSAttributedString(string: "Step Name", attributes: Theme.Font.Recipe.TextFieldAttribute)
//        input.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.TextFieldAttribute)
//        input.returnKeyType = UIReturnKeyType.done
//        input.clearButtonMode = .never
//        input.autocorrectionType = .no
//        input.enablesReturnKeyAutomatically = true
//        input.backgroundColor = UIColor.clear
//        input.becomeFirstResponder()
//        input.textAlignment = .center
//        input.delegate = self
//        input.translatesAutoresizingMaskIntoConstraints = false
//        return input
//    }()
//
//    private lazy var backButton: UIButton = {
//        let button = UIButton()
//        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
//        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private lazy var navView: NavView = {
//        let view = NavView(frame: .zero, leftNavItem: backButton, rightNavItem: addButton)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private var titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.attributedText = NSAttributedString(string: "New Step", attributes: Theme.Font.Nav.Title)
//        return label
//    }()
//
//    private lazy var addButton: UIButton = {
//        let button = UIButton()
//        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: Theme.Font.Nav.Item), for: .normal)
//        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    lazy var mainView: AddStepMainView = {
        let view = AddStepMainView(delegate: self)
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepare_ functions will be called in the super class
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        grabValuesFromInput()
        return true
    }
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        guard let delegate = recipeViewControllerWithTableViewDelegate else {
//            return
//        }
//        delegate.present(alert, animated: true, completion: nil)
        self.present(alert, animated: true, completion: nil)

    }
    
    //MARK: HANDLE DONE BUTTON
    @objc func handleAdd() {
        grabValuesFromInput()
    }
    
    func grabValuesFromInput() {
        
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.layer.cornerRadius = Theme.View.CornerRadius
        view.backgroundColor = Theme.Background.Color.NavTopFillBackgroundColor
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
//        view.addSubview(navView)
//        view.addSubview(labelTextField)
//        navView.addSubview(titleLabel)
//        preparePicker()
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
//        labelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        labelTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        labelTextField.topAnchor.constraint(equalTo: navView.bottomAnchor, constant: labelTextFieldTopAnchorPadding).isActive = true
//
//        countDownPicker.topAnchor.constraint(equalTo: labelTextField.bottomAnchor).isActive = true
//        countDownPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        countDownPicker.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        titleLabel.centerYAnchor.constraint(equalTo: navView.centerYAnchor, constant: 0.0).isActive = true
//        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
//        let navTopConstraint = !appDelegate.hasTopNotch ? view.topAnchor : nil
//        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
//
//        navView.anchorView(top: navTopConstraint, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
//        navView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightByNotch).isActive = true
        
//        mainView.anchorView(top: navView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        mainView.fillSuperView()
    }
    
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        if (appDelegate.hasTopNotch) {
//            let safeAreaInsets = self.view.safeAreaInsets
//            navView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
//        }
//    }
    
//    func preparePicker() {
//        let hoursLabel: UILabel = UILabel()
//        hoursLabel.text = "hours"
//
//        let minutesLabel: UILabel = UILabel()
//        minutesLabel.text = "min."
//
//        let secondsLabel: UILabel = UILabel()
//        secondsLabel.text = "sec."
//
//        let labelDict: [Int: UILabel] = [
//            1 : hoursLabel,
//            3 : minutesLabel,
//            5 : secondsLabel
//        ]
//
//        countDownPicker.delegate = self
//        countDownPicker.dataSource = self
//        countDownPicker.translatesAutoresizingMaskIntoConstraints = false
//        countDownPicker.setPickerLabels(labels: labelDict, containedView: view)
//        view.addSubview(countDownPicker)
//    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
