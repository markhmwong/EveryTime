//
//  AddRecipeHeaderView.swift
//  EveryTime
//
//  Created by Mark Wong on 14/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeHeaderView: UIView {
    
    private lazy var recipeNameTextField: UITextField = {
        let textField = UITextField()
        textField.defaultTextAttributes = Theme.Font.Recipe.TextFieldAttribute
        textField.attributedPlaceholder = NSAttributedString(string: "Recipe Name", attributes: Theme.Font.Recipe.TextFieldAttribute)
        textField.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.TextFieldAttribute)
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .never
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        return textField
    }()
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Unknown Name", attributes: Theme.Font.Recipe.HeaderTableView)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(parentView: AddRecipeMainView) {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(recipeNameTextField)
        addSubview(headerTitleLabel)
        
    }
}
