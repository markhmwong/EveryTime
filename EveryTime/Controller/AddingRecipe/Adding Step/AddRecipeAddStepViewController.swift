//
//  AddRecipeSettingsAddStepViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 14/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeAddStepViewController: AddStepViewControllerBase, AddStepProtocol {
    weak var delegate: AddRecipeViewController_B?
    
    init(delegate: AddRecipeViewController_B?, viewModel: AddStepViewModel) {
        super.init()
        self.delegate = delegate
        self.viewModel = viewModel
        self.labelTextField.attributedText = NSAttributedString(string: "\(viewModel.grabEntity()?.stepName ?? "Step")", attributes: Theme.Font.Recipe.TextFieldAttribute)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func grabValuesFromInput() {
        let name = labelTextField.text!
        let hrs = countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
        let min = countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
        let sec = countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)
        
        do {
            try viewModel.validatePickerView(hrs: hrs, min: min, sec: sec)
            try viewModel.validateNameInputWithEntity(name: name)
            guard let vm = delegate?.viewModel else {
                return
            }
            let priority = vm.dataSource.count
            viewModel.createStepEntity(name: name, hours: hrs, minutes: min, seconds: sec, priority: Int16(priority))
            delegate?.didReturnValuesFromAddingStep(step: viewModel.grabEntity()!)
            self.dismiss(animated: true) { }
        } catch AddStepPickerViewErrors.allZero {
            showAlertBox("At least one unit of time must be greater than 0")
        } catch AddStepPickerViewErrors.lessThanZero {
            showAlertBox("One unit of time is less than 0")
        } catch AddStepPickerViewErrors.greaterThanADay {
            showAlertBox("Hours is greater than 24")
        } catch AddStepPickerViewErrors.greaterThanAnHour {
            showAlertBox("Minutes is greater than 60")
        } catch AddStepPickerViewErrors.greaterThanAMinute {
            showAlertBox("Seconds is greater than 60")
        } catch AddStepLabelErrors.labelNotFilled {
            showAlertBox("Please fill in the label")
        } catch AddStepLabelErrors.labelLengthTooLong {
            showAlertBox("Length too long, keep it under \(viewModel.maxCharacterLimitForNameLabel)")
        } catch AddStepLabelErrors.labelInvalidLength {
            showAlertBox("Please Invalid Length")
        } catch AddStepLabelErrors.labelLengthTooShort {
            showAlertBox("Label is too short, minimum characters is 2")
        } catch {
            showAlertBox("Error unknown with name label")
        }
    }
}

//class AddRecipeAddStepViewController: ViewControllerBase, UITextFieldDelegate {
//
//    private var viewModel: AddStepViewModel!
//    //    private var mainView: AddStepMainView!
//    //MARK: VARIABLES
//
//    private let maxCharacterLimitForNameLabel = 30
//
//    private let minCharacterLimitForNameLabel = 1
//
//
//
//    //UIPickerView
//    var hours: Int = 0
//
//    var minutes: Int = 0
//
//    var seconds: Int = 0
//
//
//    var labelTextFieldTopAnchorPadding: CGFloat {
//        switch UIDevice.current.screenType.rawValue {
//        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
//            return 30.0
//        default:
//            return 60.0
//        }
//    }
//
//    private var countDownPicker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        return picker
//    }()
//
//    private lazy var labelTextField: UITextField = {
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
//    private lazy var dismissButton: UIButton = {
//        let button = UIButton()
//        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private var titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.attributedText = NSAttributedString(string: "New Step", attributes: Theme.Font.Nav.Title)
//        return label
//    }()
//
//    private lazy var navView: NavView = {
//        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: addButton)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    // to be changed
//    private lazy var mainView: UIView = {
//       let view = UIView()
//        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//
//    }()
//
//    private lazy var addButton: UIButton = {
//        let button = UIButton()
//        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: Theme.Font.Nav.Item), for: .normal)
//        button.addTarget(self, action: #selector(handleAddStep), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    
//    init(delegate: AddRecipeViewController_B?, viewModel: AddStepViewModel) {
//        super.init(nibName: nil, bundle: nil)
//        self.delegate = delegate
//        self.viewModel = viewModel
//        self.labelTextField.attributedText = NSAttributedString(string: "\(viewModel.grabEntity()?.stepName ?? "Step")", attributes: Theme.Font.Recipe.TextFieldAttribute)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //prepare_ functions will be called in the super class
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        grabValuesFromInput()
//        return true
//    }
    
//    func showAlertBox(_ message: String) {
//        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        alert.modalPresentationStyle = .overCurrentContext
//        self.present(alert, animated: true, completion: nil)
//    }

//    @objc func handleDismiss() {
//        guard let d = delegate else {
//            return
//        }
//        d.dismiss(animated: true, completion: nil)
//    }
    
//    @objc func handleAddStep() {
//        grabValuesFromInput()
//    }
    
//    func grabValuesFromInput() {
//        let name = labelTextField.text!
//        let hrs = countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
//        let min = countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
//        let sec = countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)
//
//        do {
//            try viewModel.validatePickerView(hrs: hrs, min: min, sec: sec)
//            try viewModel.validateNameInputWithEntity(name: name)
//            guard let vm = delegate?.viewModel else {
//                return
//            }
//            let priority = vm.dataSource.count
//            viewModel.createStepEntity(name: name, hours: hrs, minutes: min, seconds: sec, priority: Int16(priority))
//            delegate?.didReturnValuesFromAddingStep(step: viewModel.grabEntity()!)
//            self.dismiss(animated: true) { }
//        } catch AddStepPickerViewErrors.allZero {
//            showAlertBox("At least one unit of time must be greater than 0")
//        } catch AddStepPickerViewErrors.lessThanZero {
//            showAlertBox("One unit of time is less than 0")
//        } catch AddStepPickerViewErrors.greaterThanADay {
//            showAlertBox("Hours is greater than 24")
//        } catch AddStepPickerViewErrors.greaterThanAnHour {
//            showAlertBox("Minutes is greater than 60")
//        } catch AddStepPickerViewErrors.greaterThanAMinute {
//            showAlertBox("Seconds is greater than 60")
//        } catch AddStepLabelErrors.labelNotFilled {
//            showAlertBox("Please fill in the label")
//        } catch AddStepLabelErrors.labelLengthTooLong {
//            showAlertBox("Length too long, keep it under \(viewModel.maxCharacterLimitForNameLabel)")
//        } catch AddStepLabelErrors.labelInvalidLength {
//            showAlertBox("Please Invalid Length")
//        } catch AddStepLabelErrors.labelLengthTooShort {
//            showAlertBox("Label is too short, minimum characters is 2")
//        } catch {
//            showAlertBox("Error unknown with name label")
//        }
//    }
    
//    override func prepareViewController() {
//        super.prepareViewController()
//        view.layer.cornerRadius = Theme.View.CornerRadius
//        view.backgroundColor = UIColor.white
//    }
    
//    override func prepareView() {
//        super.prepareView()
//        view.addSubview(mainView)
//        preparePicker()
//        view.addSubview(navView)
//        view.addSubview(labelTextField)
//
//        navView.addSubview(titleLabel)
//
//    }
    
//    override func prepareAutoLayout() {
//        super.prepareAutoLayout()
//
//        let navTopConstraint = !appDelegate.hasTopNotch ? view.topAnchor : nil
//        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
//
//        navView.anchorView(top: navTopConstraint, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
//        navView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightByNotch).isActive = true
//
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
//
//        mainView.anchorView(top: navView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
//    }
    
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        if (appDelegate.hasTopNotch) {
//            let safeAreaInsets = self.view.safeAreaInsets
//            navView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
//        }
//
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
//}
