//
//  AddRecipeBaseCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 22/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeBaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
    }
}

class AddRecipeNameCell: AddRecipeBaseCell {
    fileprivate var recipeNameTextField: UITextField = {
        let textField = UITextField()
        textField.defaultTextAttributes = Theme.Font.Recipe.TextFieldAttribute
        textField.attributedPlaceholder = NSAttributedString(string: "Recipe Name", attributes: Theme.Font.Recipe.TextFieldAttribute)
        textField.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.TextFieldAttribute)
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .never
        textField.enablesReturnKeyAutomatically = true
        textField.backgroundColor = UIColor.clear
        textField.textAlignment = .center
        return textField
    }()
    
    var addRecipeViewControllerDelegate: AddRecipeViewController?
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setAttributedTitle(NSAttributedString(string: "Continue", attributes: Theme.Font.Nav.Item), for: .normal)
        return button
    }()
    
    override func setupView() {
        recipeNameTextField.borderStyle = .none
        recipeNameTextField.layer.masksToBounds = false
        recipeNameTextField.layer.shadowColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0).cgColor
        recipeNameTextField.layer.shadowOffset = CGSize(width: 2.0, height: 1.0)
        recipeNameTextField.layer.shadowOpacity = 1.0
        recipeNameTextField.layer.shadowRadius = 0.0
        recipeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        recipeNameTextField.becomeFirstResponder()
        self.addSubview(recipeNameTextField)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        self.addSubview(nextButton)
        
        recipeNameTextField.topAnchor.constraint(equalTo: self.topAnchor, constant:20).isActive = true
        recipeNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        recipeNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 100).isActive = true
    }
    
    
    @objc func handleNextButton() {
        
        guard let delegate = addRecipeViewControllerDelegate else{
            return
        }
        
        guard let name = recipeNameTextField.text else {
            return
        }
        
        delegate.recipeNameStr = name
        delegate.scrollToIndex(index: 1)
        recipeNameTextField.resignFirstResponder()
    }
}

class AddRecipeStepCell: AddRecipeBaseCell {
    fileprivate let rowHeight: CGFloat = 40.0
    fileprivate let stepCellId = "stepCellId"
    fileprivate var addStepButtonStackView: UIStackView?
    fileprivate var dataSource: [TableViewStep] = []
    fileprivate var keyboardTextField: UITextField = UITextField()
    fileprivate var textFieldStackView = UIStackView()
    var recipeName = ""
    var addRecipeViewControllerDelegate: AddRecipeViewController?

    lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.delegate = self
        tv.isEditing = false
        tv.dataSource = self
        return tv
    }()
    
    fileprivate var hourTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.textAlignment = .center
        textfield.placeholder = "Hrs"
        textfield.becomeFirstResponder()
        return textfield
    }()
    fileprivate var minuteTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.textAlignment = .center
        textfield.placeholder = "Mins"
        return textfield
    }()
    fileprivate var secondTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.textAlignment = .center
        textfield.placeholder = "Secs"
        return textfield
    }()
    fileprivate var nameTextfield: UITextField? = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .asciiCapable
        textfield.textAlignment = .center
        textfield.placeholder = "Name"
        return textfield
    }()

    override func setupView() {
        guard let n = nameTextfield, let h = hourTextfield, let m = minuteTextfield, let s = secondTextfield else {
            return
        }
        
        tableView.register(StepTableViewCell.self, forCellReuseIdentifier: stepCellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        self.addSubview(tableView)

        n.becomeFirstResponder()
        n.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(n)

        let padding: CGFloat = 2.0

        textFieldStackView.alignment = .fill
        textFieldStackView.axis = .horizontal
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = padding
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldStackView)

        textFieldStackView.addArrangedSubview(h)
        textFieldStackView.addArrangedSubview(m)
        textFieldStackView.addArrangedSubview(s)

        h.addNextButtonToolbar(onNext: (target: self, action: #selector(handleNextButton)), onCancel: nil, onDone: (target: self, action: #selector(handleDoneButton)))
        m.addNextButtonToolbar(onNext: (target: self, action: #selector(handleNextButton)), onCancel: nil, onDone: (target: self, action: #selector(handleDoneButton)))
        n.addNextButtonToolbar(onNext: (target: self, action: #selector(handleNextButton)), onCancel: nil, onDone: (target: self, action: #selector(handleDoneButton)))
        s.addAddDoneButonToolbar(onDone: (target: self, action: #selector(handleDoneButton)), onAdd: (target: self, action: #selector(handleAddButton)))

        //autolayout
        n.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        n.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        n.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        n.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        textFieldStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textFieldStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textFieldStackView.topAnchor.constraint(equalTo: n.bottomAnchor, constant: padding).isActive = true
        textFieldStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: padding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    

    
    @objc func handleNextButton() {
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
    
    //  Add button only confirms the steps and recipe to a temporary store. Does not include CoreData and the data can be cancelled anytime.
    @objc func handleAddButton() {
        guard let n = nameTextfield, let h = hourTextfield, let m = minuteTextfield, let s = secondTextfield else {
            return
        }
        if (checkTextFields([n, h, m, s])) {
            addStep(toCoreData: false, h: h.text, m: m.text, s: s.text, n: n.text)
            clearTextFields([n, h, m, s])
            n.becomeFirstResponder()
        }
    }
    
    //  Done button confirms the steps and recipe and commits it to CoreData
    @objc func handleDoneButton(_ sender: UITextField) {
        self.resignFirstResponder()
        
        guard let arvc = addRecipeViewControllerDelegate else {
            return
        }
        
        guard let n = nameTextfield, let h = hourTextfield, let m = minuteTextfield, let s = secondTextfield else {
            return
        }
        
        if (checkTextFields([n, h, m, s])) {
            s.resignFirstResponder()
            addStep(toCoreData: true, h: h.text, m: m.text, s: s.text, n: n.text)
        } else {
            addStep(toCoreData: true)
            arvc.dismiss(animated: true, completion: nil)
        }
        
        clearTextFields([n, h, m, s])
        arvc.dismiss(animated: true, completion: nil)
    }
    
    func addStep(toCoreData: Bool = false, h: String? = nil, m: String? = nil, s: String? = nil, n: String? = nil) {
        guard let name = n, let hour = h, let minute = m, let second = s  else {
            if (toCoreData) {
                loopOverTableViewData()
            }
            return
        }
        
        let step = TableViewStep()
        
        step.name = name
        if let hourValue = hour.integerValue {
            step.hours = hourValue
        }
        
        if let minuteValue = minute.integerValue {
            step.minutes = minuteValue
        }
        
        if let secondValue = second.integerValue {
            step.seconds = secondValue
        }
        step.priority = Int16(dataSource.count)
        dataSource.append(step)
        print("datasource \(step.priority)")
        tableView.insertRows(at: [IndexPath(item: dataSource.count - 1, section: 0)], with: UITableView.RowAnimation.right)
        
        if (toCoreData) {
            loopOverTableViewData()
        }
    }
    
    func loopOverTableViewData() {
        let rEntity = RecipeEntity(name: recipeName)
        for (index, s) in dataSource.enumerated() {
            let sEntity = StepEntity(name: s.name, hours: s.hours, minutes: s.minutes, seconds: s.seconds, priority: s.priority)
            if (index == 0) {
                sEntity.isLeading = true
            }
            rEntity.addToStep(sEntity)
        }
        
        rEntity.updateElapsedTimeByPriority()
        rEntity.updateExpiryTime()
        
        if let arv = addRecipeViewControllerDelegate {
            arv.createRecipe(rEntity: rEntity)
        }
    }
    
    func checkTextFields(_ textFields: [UITextField]) -> Bool {
        for textField in textFields {
            if (textField.text?.isEmpty ?? true) {
                //error empty
                textField.becomeFirstResponder()
                return false
            }
        }
        return true
    }
    
    func clearTextFields(_ textFields: [UITextField]) {
        for textField in textFields {
            textField.text! = ""
        }
    }
}

extension AddRecipeStepCell: UITableViewDelegate {
    
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

extension AddRecipeStepCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceObj = self.dataSource[sourceIndexPath.row]
        let destinationObj = self.dataSource[destinationIndexPath.row]
        
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
        cell.backgroundColor = UIColor.clear
        cell.step = dataSource[indexPath.item]
        return cell
    }
}

class TableViewStep {
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var name: String = ""
    var date: Date = Date()
    var priority: Int16 = 0
}
