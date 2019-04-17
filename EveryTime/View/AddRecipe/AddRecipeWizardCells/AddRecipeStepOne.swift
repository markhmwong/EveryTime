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
    
    var mainViewControllerDelegate: MainViewController?
    
    private var continueButtonConstraint: NSLayoutConstraint!

    private var keyboardHeight: CGFloat = 0.0 {
        didSet {
            continueButtonConstraint.constant = -keyboardHeight - 50.0
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
    private var recipeNameTextField: UITextField = {
        let textField = UITextField()
        textField.defaultTextAttributes = Theme.Font.Recipe.TextFieldAttribute
        textField.attributedPlaceholder = NSAttributedString(string: "Recipe Name", attributes: Theme.Font.Recipe.TextFieldAttribute)
        textField.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.TextFieldAttribute)
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .never
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.backgroundColor = UIColor.clear
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        return textField
    }()
    
    private var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "please enter a valid name", attributes: Theme.Font.Error.Text)
        label.layer.opacity = 0.0
        return label
    }()
    private var continueButton: StandardButton = {
        let button = StandardButton(title: "Continue")
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
        guard let mvcd = mainViewControllerDelegate else {
            return
        }
        let count = mvcd.dataSource.count + 1
        recipeNameTextField.attributedText = NSAttributedString(string: "Recipe \(count)", attributes: Theme.Font.Recipe.TextFieldAttribute)
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
        continueButtonConstraint = continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -keyboardHeight - 50.0)
        continueButtonConstraint.isActive = true
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
            throw AddRecipeWizardError.InvalidTextField(message: "empty recipe name")
        }
        let invalidCharacterSet = CharacterSet(charactersIn: "!@#$%^&*(()-_=+][{}';/?.,~`")
        if (name.rangeOfCharacter(from: invalidCharacterSet) != nil) {
            throw AddRecipeWizardError.InvalidCharacters(message: "invalid character(s)")
        }
        
        if (name.count > 20) {
            throw AddRecipeWizardError.InvalidLength(message: "name is too long")
        }
        
        if (name.isEmpty) {
            throw AddRecipeWizardError.Empty(message: "empty recipe name")
        }
        
        delegate.recipeNameStr = name
        delegate.scrollToIndex(index: 1)
        recipeNameTextField.resignFirstResponder()
    }
    
    @objc func handleContinueButton() {
        do {
            try checkTextField()
        } catch AddRecipeWizardError.Empty(let message) {
            showErrorMessage(message)
        } catch AddRecipeWizardError.InvalidCharacters(let message) {
            showErrorMessage(message)
        } catch AddRecipeWizardError.InvalidLength(let message) {
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
