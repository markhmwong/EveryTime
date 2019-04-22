////
////  AddRecipeViewController.swift
////  SimpleRecipeTimer
////
////  Created by Mark Wong on 31/12/18.
////  Copyright © 2018 Mark Wong. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//
//extension AddRecipeViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell: UICollectionViewCell? = nil
//
//        if (indexPath.item == 0) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addRecipeNameCellId, for: indexPath) as! AddRecipeStepOne
//            cell.mainViewControllerDelegate = mainViewControllerDelegate
//            cell.addRecipeViewControllerDelegate = self
//            cell.setupView()
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addRecipeStepCellId, for: indexPath) as! AddRecipeStepTwo
//            cell.addRecipeViewControllerDelegate = self
//            cell.recipeName = recipeNameStr
//            cell.setupView()
//            return cell
//        }
//    }
//}
//
//extension AddRecipeViewController: UICollectionViewDelegate {
//
//    func scrollToIndex(index: Int) {
//        let indexPath = IndexPath(item: index, section:0)
//        collView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
//    }
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        let indexPaths = collView.indexPathsForVisibleItems
//
//        if (indexPaths[0].item == 1) {
//            showEditButton()
//        } else {
//            hideEditButton()
//        }
//    }
//}
//
//extension AddRecipeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collView.bounds.width, height: collView.bounds.height)
//    }
//}
//
//class AddRecipeViewController: ViewControllerBase {
//
//    var addRecipeStepOne: AddRecipeStepOne?
//    var addRecipeStepTwo: AddRecipeStepTwo?
//
//    var interactor: OverlayInteractor? = nil
//    let addRecipeNameCellId: String = "AddRecipeNameCellId", addRecipeStepCellId: String = "AddRecipeStepCellId"
//    var mainViewControllerDelegate: MainViewController?
//    var recipeNameStr = ""
//    var invertedCaret: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.attributedText = NSAttributedString(string: "\u{2304}", attributes: Theme.Font.Recipe.CaretAttribute)
//        return label
//    }()
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.attributedText = NSAttributedString(string: "Add Recipe".uppercased(), attributes: Theme.Font.Recipe.TitleAttribute)
//        return label
//    }()
//    lazy var finishButton: UIButton = {
//        let button = UIButton()
//        button.alpha = 0.5
//        button.isEnabled = false
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setAttributedTitle(NSAttributedString(string: "Add Recipe", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
//        return button
//    }()
//    lazy var backButton: UIButton = {
//        let button = UIButton()
//        button.alpha = 0.5
//        button.isEnabled = false
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
//        return button
//    }()
//    fileprivate lazy var blurView: UIVisualEffectView = {
//        let view = UIVisualEffectView()
//        view.effect = UIBlurEffect(style: .extraLight)
//        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var collView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        cv.delegate = self
//        cv.dataSource = self
//        cv.backgroundColor = UIColor.clear
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.isScrollEnabled = false
//        return cv
//    }()
//
//    init(delegate: MainViewController) {
//        super.init(nibName: nil, bundle: nil)
//        self.mainViewControllerDelegate = delegate
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.resignFirstResponder()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //prepare_ funcs called by superclass
//    }
//
//
//    override func prepareView() {
//        super.prepareView()
//
//        view.addSubview(blurView)
//        view.addSubview(invertedCaret)
//        view.addSubview(titleLabel)
//        view.addSubview(collView)
//
//        finishButton.addTarget(self, action: #selector(handleFinishButton), for: .touchUpInside)
//        view.addSubview(finishButton)
//        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
//        view.addSubview(backButton)
//
//        collView.register(AddRecipeStepOne.self, forCellWithReuseIdentifier: addRecipeNameCellId)
//        collView.register(AddRecipeStepTwo.self, forCellWithReuseIdentifier: addRecipeStepCellId)
//    }
//
//    override func prepareViewController() {
//        super.prepareViewController()
//        view.layer.cornerRadius = Theme.View.CornerRadius
//        view.layer.masksToBounds = true
//        view.backgroundColor = UIColor.clear
//    }
//
//    var caretTopPadding: CGFloat {
//        switch UIDevice.current.screenType.rawValue {
//        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
//            return 10.0
//        default:
//            return 50.0
//        }
//    }
//
//    override func prepareAutoLayout() {
//        super.prepareAutoLayout()
//        invertedCaret.topAnchor.constraint(equalTo: view.topAnchor, constant: caretTopPadding).isActive = true
//        invertedCaret.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        titleLabel.topAnchor.constraint(equalTo: invertedCaret.bottomAnchor, constant: 20).isActive = true
//        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        collView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
//        collView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        collView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
//        finishButton.topAnchor.constraint(equalTo: view.topAnchor, constant:20).isActive = true
//        finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//
//        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//
//    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
//        if (!isAppearing) {
//            view.endEditing(true)
//        }
//    }
//
//    func createRecipe(rEntity: RecipeEntity) {
//        CoreDataHandler.saveContext()
//        if let mvc = mainViewControllerDelegate {
//            mvc.addToRecipeCollection(r: rEntity)
//            mvc.mainView.addToCollectionView()
//            mvc.startTimer()
//        }
//    }
//
//    func showEditButton() {
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
//            self.backButton.alpha = 1.0
//            self.finishButton.alpha = 1.0
//        }) { (complete: Bool) in
//            self.finishButton.isEnabled = true
//            self.backButton.isEnabled = true
//        }
//    }
//
//    func hideEditButton() {
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
//            self.backButton.alpha = 0.5
//            self.finishButton.alpha = 0.5
//        }) { (complete: Bool) in
//            self.finishButton.isEnabled = false
//            self.backButton.isEnabled = false
//        }
//    }
//}
//
///*
// Handle Buttons In UI
//*/
//extension AddRecipeViewController {
//    @objc func handleNextButton() {
//        self.scrollToIndex(index: 1)
//    }
//
//    @objc func handleBackButton() {
//        self.scrollToIndex(index: 0)
//    }
//
//    @objc func handleAddRecipe() {
//        CoreDataHandler.saveContext()
//        guard let mvc = mainViewControllerDelegate else {
//            return
//        }
//        mvc.dismiss(animated: true, completion: nil)
//    }
//
//    @objc func handleDismiss() {
//        guard let mvc = mainViewControllerDelegate else {
//            return
//        }
//        mvc.dismiss(animated: true, completion: nil)
//    }
//
//    @objc func handleFinishButton() {
////        let cell = collView.cellForItem(at: IndexPath(item: 1, section: 0)) as! AddRecipeStepTwo
////        let tableView = cell.tableView
////        guard let i = interactor else {
////            return
////        }
////        i.pan.isEnabled = false
////        tableView.isEditing = !tableView.isEditing
////        finishButton.setAttributedTitle(NSAttributedString(string: "Finish", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
//
//        self.resignFirstResponder()
//        guard let stepTwo = addRecipeStepTwo else {
//            return
//        }
//
//        if (stepTwo.dataSource.count > 0) {
//            stepTwo.dismissViewControllerAndUpdateCollectionView()
//        }
//        self.dismiss(animated: true, completion: nil)
//
////        if (tableView.isEditing) {
////            i.pan.isEnabled = false
//////            editButton.setAttributedTitle(NSAttributedString(string: "save", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
//
//    }
//}
//
////let cell = collView.cellForItem(at: IndexPath(item: 1, section: 0)) as! AddRecipeStepTwo
////let tableView = cell.tableView
////guard let i = interactor else {
////    return
////}
////tableView.isEditing = !tableView.isEditing
////
////if (tableView.isEditing) {
////    i.pan.isEnabled = false
////    //            editButton.setAttributedTitle(NSAttributedString(string: "save", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
////} else {
////    i.pan.isEnabled = true
////    finishButton.setAttributedTitle(NSAttributedString(string: "finish", attributes: Theme.Font.Recipe.TitleAttribute), for: .normal)
////}
