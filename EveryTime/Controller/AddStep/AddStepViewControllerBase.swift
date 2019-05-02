//
//  AddStepViewControllerBase.swift
//  EveryTime
//
//  Created by Mark Wong on 19/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum PickerColumn: Int {
    case hour = 0
    case min = 2
    case sec = 4
}

class AddStepViewControllerBase: ViewControllerBase, UITextFieldDelegate {
    
    var viewModel: AddStepViewModel!
    //MARK: VARIABLES
    private let maxCharacterLimitForNameLabel = 30
    private let minCharacterLimitForNameLabel = 1
//    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //UIPickerView
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    lazy var mainView: AddStepMainView = {
        let view = AddStepMainView(delegate: self)
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepare_ functions will be called in the super class
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        grabValuesFromInput()
        return true
    }
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        guard let delegate = recipeViewControllerWithTableViewDelegate else {
//            return
//        }
//        delegate.present(alert, animated: true, completion: nil)
        self.present(alert, animated: true, completion: nil)

    }
    
    //MARK: HANDLE DONE BUTTON
    @objc func handleAdd() {
        grabValuesFromInput()
    }
    
    func grabValuesFromInput() {
        
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.layer.cornerRadius = Theme.View.CornerRadius
        view.backgroundColor = Theme.Background.Color.NavTopFillBackgroundColor
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
