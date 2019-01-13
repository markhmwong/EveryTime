//
//  AddRecipeViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 31/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeViewController: UIViewController {
    
    var delegate: MainViewController?
    var recipeNameStr = ""
    var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Name"
        return label
    }()
    
    var recipeNameTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "name"
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true
        textField.backgroundColor = UIColor.lightGray
        textField.becomeFirstResponder()
        return textField
    }()
    
    init(delegate: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        //prepare navbar buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleAddRecipe)) //may repalce this for a uibutton on the main view
        
        //prepare main view in view controller
        self.prepareMainView()
    }
    
    func prepareMainView() {
        self.view.backgroundColor = UIColor.white
        
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(recipeNameLabel)
        recipeNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        recipeNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        recipeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(recipeNameTextField)
        recipeNameTextField.topAnchor.constraint(equalTo: self.recipeNameLabel.bottomAnchor).isActive = true
        recipeNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        recipeNameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func createRecipe() {
        guard let name = recipeNameTextField.text else {
            //TODO: - Error checking
            return
        }
        
        let rEntity = RecipeEntity(name: name)
        //Adding step in Recipe Entity constructor
//        let sEntity = StepEntity(name: "SampleStep", hours: 1, minutes: 30, seconds: 0)
//        rEntity.addToStep(sEntity)
        CoreDataHandler.saveContext()
        if let mvc = delegate {
            mvc.addToRecipeCollection(r: rEntity)
            mvc.addToCollectionView()
        }
    }
    
    @objc func handleAddRecipe() {
        self.createRecipe()
        CoreDataHandler.saveContext()
        self.dismiss(animated: true) {
            //
        }
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true) {
            //
        }
    }
    
}
