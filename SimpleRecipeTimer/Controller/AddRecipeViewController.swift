//
//  AddRecipeViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 31/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import CoreData


extension AddRecipeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell? = nil
        
        switch indexPath.item {
        case 0:
            addRecipeNameCell = collectionView.dequeueReusableCell(withReuseIdentifier: addRecipeNameCellId, for: indexPath) as? AddRecipeStepOne
            addRecipeNameCell?.backgroundColor = UIColor.clear
            addRecipeNameCell?.addRecipeViewControllerDelegate = self
            return addRecipeNameCell!
        case 1:
            addRecipeStepCell = collectionView.dequeueReusableCell(withReuseIdentifier: addRecipeStepCellId, for: indexPath) as? AddRecipeStepTwo
            addRecipeStepCell?.backgroundColor = UIColor.clear
            addRecipeStepCell?.addRecipeViewControllerDelegate = self
            addRecipeStepCell?.recipeName = recipeNameStr
            return addRecipeStepCell!
        default:
            break
        }
        return cell!
    }
}

extension AddRecipeViewController: UICollectionViewDelegate {
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section:0)
        collView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let indexPaths = collView.indexPathsForVisibleItems
        
        if (indexPaths[0].item == 1) {
            showEditButton()
        } else {
            hideEditButton()
        }
    }
}

extension AddRecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collView.bounds.width, height: collView.bounds.height)
    }
}

class AddRecipeViewController: ViewControllerBase {
    var addRecipeNameCell: AddRecipeStepOne?
    var addRecipeStepCell: AddRecipeStepTwo?
    var interactor: OverlayInteractor? = nil
    let addRecipeNameCellId: String = "AddRecipeNameCellId", addRecipeStepCellId: String = "AddRecipeStepCellId"
    var mainViewControllerDelegate: MainViewController?
    var recipeNameStr = ""
    var invertedCaret: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "\u{2304}", attributes: Theme.Font.Recipe.CaretAttribute)
        return label
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Add Recipe".uppercased(), attributes: Theme.Font.Recipe.TitleAttribute)
        return label
    }()
    var editButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "edit", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
        return button
    }()
    var backButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "back", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
        return button
    }()
    lazy var collView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        return cv
    }()

    init(delegate: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewControllerDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareView() {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .extraLight)
        blurView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(blurView)
        
        view.addSubview(invertedCaret)
        
        view.addSubview(titleLabel)
        
        view.addSubview(collView)
        
        collView.register(AddRecipeStepOne.self, forCellWithReuseIdentifier: addRecipeNameCellId)
        collView.register(AddRecipeStepTwo.self, forCellWithReuseIdentifier: addRecipeStepCellId)
        
        editButton.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    override func prepareViewController() {
        view.layer.cornerRadius = Theme.View.CornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
    }
    
    override func prepareAutoLayout() {
        invertedCaret.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        invertedCaret.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: invertedCaret.bottomAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        collView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        editButton.topAnchor.constraint(equalTo: view.topAnchor, constant:20).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

    }
    
    func createRecipe(rEntity: RecipeEntity) {
        CoreDataHandler.saveContext()
        if let mvc = mainViewControllerDelegate {
            mvc.addToRecipeCollection(r: rEntity)
            mvc.addToCollectionView()
        }
    }
    
    func showEditButton() {
        editButton.alpha = 1.0
        editButton.isEnabled = true
        backButton.alpha = 1.0
        backButton.isEnabled = true
    }
    
    func hideEditButton() {
        editButton.alpha = 0.0
        editButton.isEnabled = false
        backButton.alpha = 0.0
        backButton.isEnabled = false
    }
}

/*
 Handle Buttons In UI
*/ 
extension AddRecipeViewController {
    @objc func handleNextButton() {
        self.scrollToIndex(index: 1)
    }
    
    @objc func handleBackButton() {
        self.scrollToIndex(index: 0)
    }
    
    @objc func handleAddRecipe() {
        CoreDataHandler.saveContext()
        guard let mvc = mainViewControllerDelegate else {
            return
        }
        mvc.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDismiss() {
        guard let mvc = mainViewControllerDelegate else {
            return
        }
        mvc.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditButton() {
        let cell = collView.cellForItem(at: IndexPath(item: 1, section: 0)) as! AddRecipeStepTwo
        let tableView = cell.tableView
        guard let i = interactor else {
            return
        }
        tableView.isEditing = !tableView.isEditing
        
        if (tableView.isEditing) {
            i.pan.isEnabled = false
            editButton.setAttributedTitle(NSAttributedString(string: "save", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
        } else {
            i.pan.isEnabled = true
            editButton.setAttributedTitle(NSAttributedString(string: "edit", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
        }
    }
    

}
