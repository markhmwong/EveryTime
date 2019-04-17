//
//  AddRecipeStepTwo.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 14/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum textFieldTag: Int {
    case nameTextField = 0
    case hourTextField
    case minuteTextField
    case secondTextField
}

enum PickerViewTag: Int {
    case HourPicker = 0
    case MinutePicker
    case SecondPicker
}

extension AddRecipeStepTwo: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case PickerViewTag.HourPicker.rawValue:
            return 24
        case PickerViewTag.MinutePicker.rawValue, PickerViewTag.SecondPicker.rawValue:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case PickerViewTag.HourPicker.rawValue:
            return "\(row)"
        case PickerViewTag.MinutePicker.rawValue, PickerViewTag.SecondPicker.rawValue:
            return "\(row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case PickerColumn.hour.rawValue:
            hourTextfield!.text = "\(row)"
        case PickerViewTag.MinutePicker.rawValue:
            minuteTextfield!.text = "\(row)"
        case PickerViewTag.SecondPicker.rawValue:
            secondTextfield!.text = "\(row)"
        default:
            break;
        }
    }
}

class AddRecipeStepTwo: AddRecipeBaseCell {
    
    private let rowHeight: CGFloat = 120.0
    private let stepCellId = "wizardCellId"
    private var addStepButtonStackView: UIStackView?
    private var keyboardTextField: UITextField = UITextField()
    var recipeName = ""
    var addRecipeViewControllerDelegate: AddRecipeViewController?
    var tableViewBottomConstraint: NSLayoutConstraint!
    var dataSource: [TableViewStep] = []
    
    private var textFieldStackView: UIStackView = {
        let tf = UIStackView()
        tf.alignment = .fill
        tf.axis = .horizontal
        tf.distribution = .fillEqually
        tf.spacing = 0.0
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    var keyboardHeight: CGFloat = 0.0 {
        didSet {
            tableViewBottomConstraint.constant = -keyboardHeight
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        }
    }
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.isEditing = true
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var countDownPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var hourPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = PickerViewTag.HourPicker.rawValue
        picker.delegate = self
        picker.dataSource = self

        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var minutePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = PickerViewTag.MinutePicker.rawValue
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var secondPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = PickerViewTag.SecondPicker.rawValue
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var hourTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.tag = textFieldTag.hourTextField.rawValue
        textfield.backgroundColor = UIColor.clear
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.textAlignment = .center
        textfield.text = "0"
        textfield.inputView = hourPickerView
        
        textfield.placeholder = "Hrs"
        textfield.becomeFirstResponder()
        return textfield
    }()
    private lazy var minuteTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.tag = textFieldTag.minuteTextField.rawValue
        textfield.backgroundColor = UIColor.clear
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.textAlignment = .center
        textfield.inputView = minutePickerView
        textfield.text = "0"
        textfield.placeholder = "Mins"
        return textfield
    }()
    private lazy var secondTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.tag = textFieldTag.secondTextField.rawValue
        textfield.backgroundColor = UIColor.clear
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.textAlignment = .center
        textfield.inputView = secondPickerView
        textfield.text = "0"
        textfield.placeholder = "Secs"
        return textfield
    }()
    private var nameTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.tag = textFieldTag.nameTextField.rawValue
        textfield.backgroundColor = UIColor.clear
        textfield.keyboardType = .asciiCapable
        textfield.textAlignment = .center
        textfield.placeholder = "Name"
        textfield.text = "Step 1"
        textfield.spellCheckingType = .no
        textfield.autocorrectionType = .no
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Name", attributes: Theme.Font.Recipe.StepNameLabelForAddRecipe)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Hours", attributes: Theme.Font.Recipe.StepNameLabelForAddRecipe)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minutesLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Minutes", attributes: Theme.Font.Recipe.StepNameLabelForAddRecipe)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secondsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Seconds", attributes: Theme.Font.Recipe.StepNameLabelForAddRecipe)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timeLabelStackView: UIStackView = {
        let tf = UIStackView()
        tf.alignment = .fill
        tf.axis = .horizontal
        tf.distribution = .fillEqually
        tf.spacing = 2.0
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override func setupView() {
        super.setupView()
        addRecipeViewControllerDelegate?.addRecipeStepTwo = self
        guard let n = nameTextfield, let h = hourTextfield, let m = minuteTextfield, let s = secondTextfield else {
            return
        }
        n.delegate = self
        h.delegate = self
        m.delegate = self
        s.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        tableView.register(StepTableViewCell.self, forCellReuseIdentifier: stepCellId)
        
        addSubview(nameLabel)
        addSubview(tableView)
        n.becomeFirstResponder()
        addSubview(n)
        addSubview(textFieldStackView)
        addSubview(timeLabelStackView)
        
        timeLabelStackView.addArrangedSubview(hoursLabel)
        timeLabelStackView.addArrangedSubview(minutesLabel)
        timeLabelStackView.addArrangedSubview(secondsLabel)
        
        textFieldStackView.addArrangedSubview(h)
        textFieldStackView.addArrangedSubview(m)
        textFieldStackView.addArrangedSubview(s)
        
        h.addAddDoneButonToolbar(onDone: (target: self, action: #selector(handleDoneButton)), onAdd: (target: self, action: #selector(handleAddButton)), onDismiss: (target: self, action: #selector(handleDismissButton)))
        m.addAddDoneButonToolbar(onDone: (target: self, action: #selector(handleDoneButton)), onAdd: (target: self, action: #selector(handleAddButton)), onDismiss: (target: self, action: #selector(handleDismissButton)))
        n.addAddDoneButonToolbar(onDone: (target: self, action: #selector(handleDoneButton)), onAdd: (target: self, action: #selector(handleAddButton)), onDismiss: (target: self, action: #selector(handleDismissButton)))
        s.addAddDoneButonToolbar(onDone: (target: self, action: #selector(handleDoneButton)), onAdd: (target: self, action: #selector(handleAddButton)), onDismiss: (target: self, action: #selector(handleDismissButton)))
        prepareAutoLayout()
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        keyboardHeight = (keyboardFrame?.cgRectValue.height)! - ((keyboardFrame?.cgRectValue.height)! - hourPickerView.frame.height)
    }
    
    func prepareAutoLayout() {
        //todo
        guard let n = nameTextfield else {
            return
        }
        let padding: CGFloat = 2.0
        let textFieldHeight: CGFloat = 40.0
        
        nameLabel.anchorView(top: topAnchor, bottom: n.topAnchor, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: .zero, size: .zero)
        
        n.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0.0).isActive = true
        n.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        n.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        n.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        timeLabelStackView.anchorView(top: n.bottomAnchor, bottom: textFieldStackView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        
        textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textFieldStackView.topAnchor.constraint(equalTo: timeLabelStackView.bottomAnchor).isActive = true
        textFieldStackView.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        tableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: padding).isActive = true
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:0)
        tableViewBottomConstraint.isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold Up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        guard let delegate = addRecipeViewControllerDelegate else {
            return
        }
        delegate.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleContinueButton() {
        guard let n = nameTextfield, let h = hourTextfield, let m = minuteTextfield, let s = secondTextfield else {
            return
        }
        
        if (n.isFirstResponder) {
            n.resignFirstResponder()
            h.becomeFirstResponder()
        } else if (h.isFirstResponder) {
            h.resignFirstResponder()
            m.becomeFirstResponder()
        } else {
            m.resignFirstResponder()
            s.becomeFirstResponder()
        }
    }
    
    @objc func handleDismissButton() {
        guard let n = nameTextfield, let h = hourTextfield, let m = minuteTextfield, let s = secondTextfield else {
            return
        }
        
        if (n.isFirstResponder) {
            n.resignFirstResponder()
        } else if (h.isFirstResponder) {
            h.resignFirstResponder()
        } else if (m.isFirstResponder) {
            m.resignFirstResponder()
        } else {
            s.resignFirstResponder()
        }
        
        tableViewBottomConstraint.constant = 0
    }
    
    /**
        # Add Button
     
        Confirms the steps and recipe to a temporary store - self.datasource (array).
        Does not include any save to CoreData. Dismissing the viewcontroller loses any data.
        Catches Errors from checkTextFields method to catch various validition conditions.
     
     - Flow: Checks the validity of the text fields
        2) Saves to temporary array - self.datasource
        3) Clears textfields of any characters
        4) Returns the focus to the name textfield
     
     
     - Returns: void
    */
    @objc func handleAddButton() {
        guard let n = nameTextfield, let h = hourTextfield, let m = minuteTextfield, let s = secondTextfield else {
            return
        }
        
        do {
            try checkTextFields([n, h, m, s])
            addStep(saveToCoreData: false, h: h.text, m: m.text, s: s.text, n: n.text)
            clearTextFields([n])
            n.becomeFirstResponder()
        } catch AddRecipeWizardError.Empty(let message) {
            showAlertBox(message)
        } catch AddRecipeWizardError.InvalidCharacters(let message) {
            showAlertBox(message)
        } catch AddRecipeWizardError.InvalidTextField(let message) {
            showAlertBox(message)
        } catch AddRecipeWizardError.InvalidRange(let message) {
            showAlertBox(message)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    /**
        # Done button
     
        Confirms a filled datasource array containing recipes with steps and commits it to CoreData Model Object Context.
        Proceeds to remove the current viewcontroller and return back to the mainviewcontroller.
     
    */
    @objc func handleDoneButton() {
        self.resignFirstResponder()
        
        guard let arvc = addRecipeViewControllerDelegate else {
            return
        }
        
        if (dataSource.count > 0) {
            dismissViewControllerAndUpdateCollectionView()
        }
        arvc.dismiss(animated: true, completion: nil)
    }
    
    func addStep(saveToCoreData: Bool = false, h: String? = nil, m: String? = nil, s: String? = nil, n: String? = nil) {
        guard let name = n, let hour = h, let minute = m, let second = s  else {
            if (saveToCoreData) {
                dismissViewControllerAndUpdateCollectionView()
            }
            return
        }
        
        let step = TableViewStep(hours: hour.integerValue!, minutes: minute.integerValue!, seconds: second.integerValue!, name: name, date: Date(), priority: Int16(dataSource.count))
        
//        step.name = name
//        if let hourValue = hour.integerValue {
//            step.hours = hourValue
//        }
//
//        if let minuteValue = minute.integerValue {
//            step.minutes = minuteValue
//        }
//
//        if let secondValue = second.integerValue {
//            step.seconds = secondValue
//        }
//        step.priority = Int16(dataSource.count)
        dataSource.append(step)
        
        if (dataSource.count > 0) {
            tableView.insertRows(at: [IndexPath(item: dataSource.count - 1, section: 0)], with: UITableView.RowAnimation.right)
            tableView.scrollToRow(at: IndexPath(row: dataSource.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        }
        
        if (saveToCoreData) {
            dismissViewControllerAndUpdateCollectionView()
        }
    }
    
    //ensure the perform block operates correctly
    func dismissViewControllerAndUpdateCollectionView() {
        CoreDataHandler.getContext().perform {
            let rEntity = RecipeEntity(name: self.recipeName)
            for (index, s) in self.dataSource.enumerated() {
                let sEntity = StepEntity(name: s.name, hours: s.hours, minutes: s.minutes, seconds: s.seconds, priority: s.priority)
                if (index == 0) {
                    sEntity.isLeading = true
                    rEntity.currStepName = sEntity.stepName
                }
                rEntity.addToStep(sEntity)
            }
            
            rEntity.updateTimeRemainingForCurrentStep()
            
            if let arv = self.addRecipeViewControllerDelegate {
                arv.createRecipe(rEntity: rEntity)
            }
        }
    }
    
    func checkTextFields(_ textFields: [UITextField]) throws -> Bool {
        var allZeroFields = true
        var hoursZero = true
        var minutesZero = true
        var secondsZero = true
        
        
        //check if values are not empty (name) and the unit of measure is within range
        for textField in textFields {
            if (textField.text?.isEmpty ?? true) {
                //error empty
                textField.becomeFirstResponder()
                throw AddRecipeWizardError.Empty(message: "We have an empty field")
            }
            
            guard let t = textField.text else {
                return false
            }
            
            switch textField.tag {
                case textFieldTag.nameTextField.rawValue:
                    if (t.count > 30) {
                        throw AddRecipeWizardError.InvalidLength(message: "name is too long")
                    }
                case textFieldTag.hourTextField.rawValue:
                    if (Int(t)! > 23) {
                        throw AddRecipeWizardError.InvalidRange(message: "choose between 1 - 23 for hours")
                    }
                case textFieldTag.minuteTextField.rawValue:
                    if (Int(t)! > 60) {
                        throw AddRecipeWizardError.InvalidRange(message: "choose between 1 - 60 for minutes")
                    }
                case textFieldTag.secondTextField.rawValue:
                    if (Int(t)! > 60) {
                        throw AddRecipeWizardError.InvalidRange(message: "choose between 1 - 60 for seconds")
                    }
                default:
                    throw AddRecipeWizardError.InvalidTextField(message: "Invalid Text")
            }
        }
        
        //Checks if all values are 0
        for textField in textFields {
            guard let t = textField.text else {
                return false
            }
            
            switch textField.tag {
            case textFieldTag.nameTextField.rawValue:
                if (t.count == 0) {
                    throw AddRecipeWizardError.InvalidLength(message: "Step name is empty")
                }
                case textFieldTag.hourTextField.rawValue:
                    if (Int(t)! <= 0) {
                        hoursZero = false
                    }
                case textFieldTag.minuteTextField.rawValue:
                    if (Int(t)! <= 0) {
                        minutesZero = false
                    }
                case textFieldTag.secondTextField.rawValue:
                    if (Int(t)! <= 0) {
                        secondsZero = false
                    }
                default:
                    throw AddRecipeWizardError.InvalidTextField(message: "Invalid Text")
            }
        }
        
        if (hoursZero || minutesZero || secondsZero) {
            return true
        }
        
        throw AddRecipeWizardError.InvalidTextField(message: "At least one unit of time must be greater than 0")
    }
    
    func clearTextFields(_ textFields: [UITextField]) {
        for textField in textFields {
            switch textField.tag {
                case textFieldTag.nameTextField.rawValue:
                    textField.text = "Step \(dataSource.count + 1)"
                default:
                    textField.text = "0"
            }
        }
    }
    
    
}

extension AddRecipeStepTwo: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableViewBottomConstraint.constant = -keyboardHeight

        if (tableViewBottomConstraint.constant != 0) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.setNeedsLayout()
                
            }) { (finished) in
                if (self.dataSource.count > 0) {
                    self.tableView.scrollToRow(at: IndexPath(row: self.dataSource.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                }
            }
        }
    }
}

extension AddRecipeStepTwo: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension AddRecipeStepTwo: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("perform drop with")
    }
}

extension AddRecipeStepTwo: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        //copy
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var sourceObj = self.dataSource[sourceIndexPath.row]
        var destinationObj = self.dataSource[destinationIndexPath.row]
        
        //switch dates
        let tempDestinationPriority = destinationObj.priority
        destinationObj.priority = sourceObj.priority
        sourceObj.priority = tempDestinationPriority
        
        dataSource.remove(at: sourceIndexPath.row)
        dataSource.insert(sourceObj, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellId, for: indexPath) as! StepTableViewCell
        cell.step = dataSource[indexPath.item]
        return cell
    }
}
