//
//  AddStepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 4/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

enum PickerColumn: Int {
    case hour = 0
    case min = 2
    case sec = 4
}

// refactor addstep into one base view controller
protocol AddStepProtocol {
    func grabValuesFromInput()
    func preparePicker()
}


class AddStepViewController: ViewControllerBase, UITextFieldDelegate {
    
    private var addStepViewModel: AddStepViewModel!
//    private var mainView: AddStepMainView!
    //MARK: VARIABLES
    private let maxCharacterLimitForNameLabel = 30
    private let minCharacterLimitForNameLabel = 1
    var recipeViewControllerDelegate: RecipeViewControllerDelegate?
    var recipeViewControllerWithTableViewDelegate: RecipeViewControllerWithTableView?
    var interactor: OverlayInteractor? = nil

    //UIPickerView
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    var labelTextFieldTopAnchorPadding: CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return 30.0
        default:
            return 60.0
        }
    }
    
    var caretTopPadding: CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return 10.0
        default:
            return 50.0
        }
    }
    
    private var countDownPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var labelTextField: UITextField = {
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
        input.delegate = self
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
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "New Step", attributes: Theme.Font.Nav.Title)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // to be changed
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(delegate: RecipeViewControllerWithTableView?, viewModel: AddStepViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.recipeViewControllerDelegate = delegate
        self.addStepViewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepare_ functions will be called in the super class
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let rvc = recipeViewControllerDelegate {
            rvc.willReloadTableData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        grabValuesFromInput()
        return true
    }
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        guard let delegate = recipeViewControllerWithTableViewDelegate else {
            return
        }
        delegate.present(alert, animated: true, completion: nil)
    }
    
    //MARK: HANDLE DONE BUTTON
    @objc func handleAdd() {
        grabValuesFromInput()
    }
    
    func grabValuesFromInput() {
        let name = labelTextField.text!
        let hrs = countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
        let min = countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
        let sec = countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)

        do {
            try addStepViewModel.validatePickerView(hrs: hrs, min: min, sec: sec)
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
        } catch {
            showAlertBox("Error unknown with picker view")
        }
        
        do {
            try addStepViewModel.validateNameInput()
        } catch AddStepLabelErrors.labelNotFilled {
            showAlertBox("Please fill in the label")
        } catch AddStepLabelErrors.labelLengthTooLong {
            showAlertBox("Length too long, keep it under \(addStepViewModel.maxCharacterLimitForNameLabel)")
        } catch AddStepLabelErrors.labelInvalidLength {
            showAlertBox("Please Invalid Length")
        } catch AddStepLabelErrors.labelLengthTooShort {
            showAlertBox("Too short")
        } catch {
            showAlertBox("Error unknown with name label")
        }
        

        guard let rvc = recipeViewControllerDelegate else {
            return
        }
        addStepViewModel.updateStepValues(name: name, hrs: hrs, min: min, sec: sec)
        addStepViewModel.transformToEntity(priority: Int16(rvc.stepCount() - 1))
        rvc.didReturnValues(step: addStepViewModel.grabEntity()!)
        recipeViewControllerWithTableViewDelegate?.startTimer()
        self.dismiss(animated: true) { }
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.layer.cornerRadius = Theme.View.CornerRadius
        view.backgroundColor = Theme.Background.Color.NavTopFillBackgroundColor
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)

        preparePicker()
        if let rvc = recipeViewControllerDelegate {
            
            guard let step = addStepViewModel.step() else {
                return
            }
            
            let stepName = "\(step.name) \(rvc.stepCount())"
            addStepViewModel.updateStepValues(name: stepName)
            labelTextField.attributedText = NSAttributedString(string: stepName, attributes: Theme.Font.Recipe.TextFieldAttribute)
        }
        
        view.addSubview(navView)
        view.addSubview(labelTextField)
        navView.addSubview(titleLabel)

    }
    

    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        labelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        labelTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelTextField.topAnchor.constraint(equalTo: navView.bottomAnchor, constant: labelTextFieldTopAnchorPadding).isActive = true
        
        countDownPicker.topAnchor.constraint(equalTo: labelTextField.bottomAnchor).isActive = true
        countDownPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countDownPicker.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: navView.centerYAnchor, constant: 0.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        let navTopConstraint = !appDelegate.hasTopNotch ? view.topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightByNotch).isActive = true

        mainView.anchorView(top: navView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.view.safeAreaInsets
            navView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    func preparePicker() {
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
        
        countDownPicker.delegate = self
        countDownPicker.dataSource = self
        countDownPicker.translatesAutoresizingMaskIntoConstraints = false
        countDownPicker.setPickerLabels(labels: labelDict, containedView: view)
        view.addSubview(countDownPicker)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
