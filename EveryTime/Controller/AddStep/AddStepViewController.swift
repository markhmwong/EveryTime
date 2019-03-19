//
//  AddStepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 4/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class AddStepViewController: ViewControllerBase {

    //MARK: VARIABLES
    fileprivate let maxCharacterLimitForNameLabel = 30
    fileprivate let minCharacterLimitForNameLabel = 1
    var recipeViewControllerDelegate: RecipeViewControllerDelegate?
    var recipeViewControllerWithTableViewDelegate: RecipeViewControllerWithTableView?
    var interactor: OverlayInteractor? = nil

    //UIPickerView
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    enum ErrorsToThrow: Error {
        case labelNotFilled
        case labelLengthTooLong
        case labelInvalidLength
        case labelLengthTooShort
    }
    
    enum pickerColumn: Int {
        case hour = 0
        case min = 2
        case sec = 4
    }
    
    fileprivate var countDownPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    fileprivate var labelTextField: UITextField = {
        let input = UITextField()
        input.defaultTextAttributes = Theme.Font.Recipe.TextFieldAttribute
        input.attributedPlaceholder = NSAttributedString(string: "Name the Step", attributes: Theme.Font.Recipe.TextFieldAttribute)
        input.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.TextFieldAttribute)
        input.returnKeyType = UIReturnKeyType.done
        input.clearButtonMode = .never
        input.enablesReturnKeyAutomatically = true
        input.backgroundColor = UIColor.clear
        input.becomeFirstResponder()
        input.textAlignment = .center
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    fileprivate var invertedCaret: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "\u{2304}", attributes: Theme.Font.Recipe.CaretAttribute)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate var rightNavItemButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Done", attributes: Theme.Font.Nav.Item), for: .normal)
        button.setTitle("Done", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Add A New Step", attributes: Theme.Font.Recipe.TitleAttribute)
        return label
    }()
    fileprivate lazy var navView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    fileprivate lazy var doneButton: StandardButton = {
        let button = StandardButton(title: "Add")
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .extraLight)
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepare_ functions will be called in the super class
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let rvc = recipeViewControllerDelegate {
            rvc.willReloadTableData()
        }
    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        if (!isAppearing) {
            view.endEditing(true)
        }
    }
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        guard let delegate = recipeViewControllerWithTableViewDelegate else {
            return
        }
        delegate.present(alert, animated: true, completion: nil)
    }
    
    //MARK: HANDLE DONE BUTTON
    @objc func handleDoneButton() {
        do {
            try self.grabValuesFromInput()
        } catch ErrorsToThrow.labelNotFilled {
            showAlertBox("Please fill in the label")
        } catch ErrorsToThrow.labelLengthTooLong {
            showAlertBox("Length too long, keep it under \(maxCharacterLimitForNameLabel)")
        } catch ErrorsToThrow.labelInvalidLength {
            showAlertBox("Please Invalid Length")
        } catch ErrorsToThrow.labelLengthTooShort {
            showAlertBox("Too short")
        } catch {
            //
        }
        recipeViewControllerWithTableViewDelegate?.startTimer()
        self.dismiss(animated: true) { }
    }
    
    func grabValuesFromInput() throws {
        
        //0
        guard labelTextField.text != "" else {
            throw ErrorsToThrow.labelNotFilled
        }
        
        //catch negative length
        guard let length = labelTextField.text?.count else {
            throw ErrorsToThrow.labelInvalidLength
        }
        guard length >= minCharacterLimitForNameLabel else {
            throw ErrorsToThrow.labelLengthTooShort
        }
        
        //catch character limit
        guard length <= maxCharacterLimitForNameLabel else {
            throw ErrorsToThrow.labelLengthTooLong
        }
        
        let name = labelTextField.text!
        
        let hrs = countDownPicker.selectedRow(inComponent: pickerColumn.hour.rawValue)
        let min = countDownPicker.selectedRow(inComponent: pickerColumn.min.rawValue)
        let sec = countDownPicker.selectedRow(inComponent: pickerColumn.sec.rawValue)
        
        let sEntity = StepEntity(name: name, hours: hrs, minutes: min, seconds: sec, priority: Int16(0))
        if let rvc = recipeViewControllerDelegate {
            rvc.didReturnValues(step: sEntity)
        }
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.backgroundColor = UIColor.clear
        
    }
    
    override func prepareView() {
        super.prepareView()
        preparePicker()

        view.layer.cornerRadius = Theme.View.CornerRadius
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.addSubview(navView)
        view.addSubview(blurView)
        view.addSubview(rightNavItemButton)
        view.addSubview(labelTextField)
        view.addSubview(invertedCaret)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        
        rightNavItemButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
    }
    
    override func prepareAutoLayout() {
        rightNavItemButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        rightNavItemButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        labelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        labelTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60).isActive = true
        
        countDownPicker.topAnchor.constraint(equalTo: labelTextField.bottomAnchor).isActive = true
        countDownPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countDownPicker.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        invertedCaret.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        invertedCaret.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: invertedCaret.bottomAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: countDownPicker.bottomAnchor).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: countDownPicker.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
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
}
