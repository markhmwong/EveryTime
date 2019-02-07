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
            addRecipeNameCell = collectionView.dequeueReusableCell(withReuseIdentifier: addRecipeNameCellId, for: indexPath) as? AddRecipeNameCell
            addRecipeNameCell?.backgroundColor = UIColor.clear
            addRecipeNameCell?.addRecipeViewControllerDelegate = self
            return addRecipeNameCell!
        case 1:
            addRecipeStepCell = collectionView.dequeueReusableCell(withReuseIdentifier: addRecipeStepCellId, for: indexPath) as? AddRecipeStepCell
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section:0)
        collView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
    }
}

extension AddRecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collView.bounds.width, height: collView.bounds.height)
    }
}

class AddRecipeViewController: UIViewController {
    var addRecipeNameCell: AddRecipeNameCell?
    var addRecipeStepCell: AddRecipeStepCell?
    var interactor: OverlayInteractor? = nil
    let addRecipeNameCellId: String = "AddRecipeNameCellId", addRecipeStepCellId: String = "AddRecipeStepCellId"
    var mainViewControllerDelegate: MainViewController?
    var recipeNameStr = ""
    var invertedCaret: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "\u{2304}", attributes: Theme.Font.Recipe.CaretAttribute)
        return label
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Add Recipe".uppercased(), attributes: Theme.Font.Recipe.TitleAttribute)
        return label
    }()
    var editButton: UIButton = {
        let label = UIButton()
        label.setAttributedTitle(NSAttributedString(string: "edit", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
        return label
    }()
    lazy var collView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.clear
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
        self.prepareViewControllerView()
        self.prepareAutoLayout()
    }
    
    func prepareViewControllerView() {
        self.view.layer.cornerRadius = Theme.View.CornerRadius
        self.view.layer.masksToBounds = true
        
        self.view.backgroundColor = UIColor.clear
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .extraLight)
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(blurView)
        
        invertedCaret.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(invertedCaret)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        
        collView.isScrollEnabled = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collView)
        collView.register(AddRecipeNameCell.self, forCellWithReuseIdentifier: addRecipeNameCellId)
        collView.register(AddRecipeStepCell.self, forCellWithReuseIdentifier: addRecipeStepCellId)
        
        editButton.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editButton)
    }
    
    func prepareAutoLayout() {
        invertedCaret.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        invertedCaret.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: invertedCaret.bottomAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        collView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        editButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant:20).isActive = true
        editButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    func createRecipe(rEntity: RecipeEntity) {
        CoreDataHandler.saveContext()
        if let mvc = mainViewControllerDelegate {
            mvc.addToRecipeCollection(r: rEntity)
            mvc.addToCollectionView()
        }
    }
}

/*
 Handle Buttons In UI
*/ 
extension AddRecipeViewController {
    @objc func handleNextButton() {
        self.scrollToIndex(index: 1)
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
        let cell = collView.cellForItem(at: IndexPath(item: 1, section: 0)) as! AddRecipeStepCell //the add step cell
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
