//
//  AddRecipeStepOne.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 14/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeStepOne: AddRecipeBaseCell {
    var addRecipeViewControllerDelegate: AddRecipeViewController?
    var keyboardHeight: CGFloat = 0.0 {
        didSet {
            continueButton.topAnchor.constraint(equalTo: bottomAnchor, constant: -keyboardHeight - 70.0).isActive = true //TODO
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
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
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0).cgColor
        textField.layer.shadowOffset = CGSize(width: 2.0, height: 1.0)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius = 0.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        return textField
    }()
    var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "please enter a valid name", attributes: Theme.Font.Error.Text)
        label.layer.opacity = 0.0
        return label
    }()
    fileprivate var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setAttributedTitle(NSAttributedString(string: "Continue", attributes: Theme.Font.Recipe.TextFieldAttribute), for: .normal)
        button.layer.cornerRadius = 8.0
        button.backgroundColor = Theme.Font.Color.AddButtonColour
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupView() {
        super.setupView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        addSubview(recipeNameTextField)
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        addSubview(continueButton)
        addSubview(errorMessageLabel)
        prepareAutoLayout()
    }
    
    func prepareAutoLayout() {
        recipeNameTextField.topAnchor.constraint(equalTo: topAnchor, constant:100).isActive = true
        recipeNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        recipeNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        continueButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true
//        continueButton.topAnchor.constraint(equalTo: bottomAnchor, constant: -keyboardHeight).isActive = true
        errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        errorMessageLabel.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 20.0).isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }
    
    func checkTextField() throws {

        guard let delegate = addRecipeViewControllerDelegate else{
            return
        }
        
        guard let name = recipeNameTextField.text else {
            throw AddRecipeWizardError.invalidTextField(message: "empty recipe name")
        }
        let invalidCharacterSet = CharacterSet(charactersIn: "!@#$%^&*(")
        if (name.rangeOfCharacter(from: invalidCharacterSet) != nil) {
            throw AddRecipeWizardError.invalidCharacters(message: "invalid character(s)")
        }
        
        if (name.isEmpty) {
            throw AddRecipeWizardError.empty(message: "empty recipe name")
        }
        
        delegate.recipeNameStr = name
        delegate.scrollToIndex(index: 1)
        recipeNameTextField.resignFirstResponder()
    }
    
    @objc func handleContinueButton() {
        do {
            try checkTextField()
        } catch AddRecipeWizardError.empty(let message) {
            showErrorMessage(message)
        } catch AddRecipeWizardError.invalidCharacters(let message) {
            showErrorMessage(message)
        } catch {
            showErrorMessage("unexpected error")
        }
    }
    
    func showErrorMessage(_ message: String) {
        errorMessageLabel.attributedText = NSAttributedString(string: message, attributes: Theme.Font.Error.Text)
        errorMessageLabel.layer.opacity = 1.0
    }
    
    func hideErrorMessage() {
        errorMessageLabel.layer.opacity = 0.0
    }
}
