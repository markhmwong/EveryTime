//
//  AddStepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 4/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class AddStepViewController: UIViewController {

    //MARK: VARIABLES
    fileprivate let maxCharacterLimitForNameLabel = 12
    fileprivate let minCharacterLimitForNameLabel = 1
    var recipeViewControllerDelegate: RecipeVCDelegate?
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
    
    var countDownPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    private var labelTextField: UITextField = {
        let input = UITextField()
        input.defaultTextAttributes = Theme.Font.Step.AddStep
        input.attributedPlaceholder = NSAttributedString(string: "Name The Step", attributes: Theme.Font.Step.AddStep)
        input.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.AddStep)
        input.returnKeyType = UIReturnKeyType.done
        input.clearButtonMode = .whileEditing
        input.enablesReturnKeyAutomatically = true
        input.backgroundColor = UIColor.lightGray
        input.becomeFirstResponder()
        return input
    }()
    var rightNavItemButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    lazy var navView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        navView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navView)
        navView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor).isActive = true
        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        rightNavItemButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        rightNavItemButton.translatesAutoresizingMaskIntoConstraints = false
        navView.addSubview(rightNavItemButton)
        rightNavItemButton.centerYAnchor.constraint(equalTo: self.navView.centerYAnchor).isActive = true
        rightNavItemButton.trailingAnchor.constraint(equalTo: self.navView.trailingAnchor, constant: -8).isActive = true
        
        self.preparePicker()
        

        labelTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(labelTextField)
        
        labelTextField.topAnchor.constraint(equalTo: countDownPicker.bottomAnchor, constant: 20).isActive = true
        labelTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        labelTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let rvc = recipeViewControllerDelegate {
            rvc.willReloadTableData()
        }
    }
    
    //MARK: HANDLE DONE BUTTON
    @objc func handleDoneButton() {
        do {
            try self.grabValuesFromInput()
        } catch ErrorsToThrow.labelNotFilled {
            //TODO: BUILD ALERT BOX
            print("Alert Box: Please fill in the label")
        } catch ErrorsToThrow.labelLengthTooLong {
            print("Alert Box: Length too long keep it to \(maxCharacterLimitForNameLabel)")
        } catch ErrorsToThrow.labelInvalidLength {
            print("Alert Box: Invalid Length")
        } catch ErrorsToThrow.labelLengthTooShort {
            print("Alert Box: Too Short")
        } catch {
            //
        }
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
        
        print("todo - priority by count of array")
        let sEntity = StepEntity(name: name, hours: hrs, minutes: min, seconds: sec, priority: Int16(0))
        if let rvc = recipeViewControllerDelegate {
            rvc.didReturnValues(step: sEntity)
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
        countDownPicker.setPickerLabels(labels: labelDict, containedView: self.view)
        self.view.addSubview(countDownPicker)
        
        countDownPicker.topAnchor.constraint(equalTo: self.navView.bottomAnchor).isActive = true
        countDownPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        countDownPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
}
