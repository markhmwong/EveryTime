//
//  RecipeColorViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 28/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension RecipeColorView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = delegate?.viewModel else { return 0 }
        return vm.colorArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: delegate?.viewModel?.cellId ?? "colorCellId", for: indexPath)
        let color = delegate?.viewModel?.colorArr[indexPath.item]
        cell.backgroundColor = color
        
        guard let vm = delegate?.viewModel else { return cell }
        guard let selectedIndex = vm.selectedIndex else { return cell }
        
        if (selectedIndex == indexPath.item) {
            cell.isSelected = true
            let backgroundView = vm.selectedImageView()
            cell.selectedBackgroundView = backgroundView
            backgroundView.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: cell.centerYAnchor, centerX: cell.centerXAnchor, padding: .zero, size: CGSize(width: cell.bounds.width / 6, height: cell.bounds.height / 6))
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vm = delegate?.viewModel else { return }
        
        let cell = collectionView.cellForItem(at: IndexPath(item: vm.selectedIndex ?? 0, section: 0))
        cell?.selectedBackgroundView = nil
        
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            let backgroundImage = UIImage(named: "Checkmark")
            let image = UIImageView(image: backgroundImage)
            image.translatesAutoresizingMaskIntoConstraints = false
            
            cell.selectedBackgroundView = image
            image.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: cell.centerYAnchor, centerX: cell.centerXAnchor, padding: .zero, size: CGSize(width: cell.bounds.width / 6, height: cell.bounds.height / 6))
            
            delegate?.viewModel?.selectedIndex = indexPath.item
            
            let color = delegate?.viewModel?.colorArr[indexPath.item]
            delegate?.viewModel?.recipe.color = NSKeyedArchiver.archivedData(withRootObject: color)
            CoreDataHandler.saveContext()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2.0, height: UIScreen.main.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
}

class RecipeColorViewModel {
    
    let cellId = "colorCellId"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var theme: ThemeManager?
    
    var recipe: RecipeEntity
    
    var colorArr: [UIColor] = [
        UIColor.red,
        UIColor.blue,
        UIColor.gray,
        UIColor.purple,
        UIColor.black,
        UIColor.white,
        UIColor.green,
        UIColor.yellow,
        UIColor.orange,
        UIColor.brown,
        UIColor.cyan,
        UIColor.darkGray,
    ]
    
    var selectedIndex: Int?  {
        didSet {
            selectedColor = colorArr[selectedIndex!]
        }
    }
    
    var selectedColor: UIColor?
    
    init(theme: ThemeManager, recipe: RecipeEntity) {
        self.theme = theme
        self.recipe = recipe
        initialiseColorFromRecipe()
    }
    
    func selectedImageView() -> UIImageView {
        let backgroundImage = UIImage(named: "Checkmark")
        let image = UIImageView(image: backgroundImage)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    func initialiseColorFromRecipe() {
        
        guard recipe.color != nil else {
            recipe.colorArchive(color: UIColor.clear)
//            recipe.color = NSKeyedArchiver.archivedData(withRootObject: UIColor.clear)
            return
        }
        
        let recipeColor = recipe.colorUnarchive()
        print(recipeColor)
        indexFor(recipeColor: recipeColor)
    }
    
    // or we could create a reverse lookup.
    func indexFor(recipeColor: UIColor) {
        for (index, color) in colorArr.enumerated() {
            if (recipeColor.isEqual(color)) {
                selectedIndex = index
                break
            }
        }
    }
    
}

class RecipeColorView: UIView {
    
    weak var delegate: RecipeColorViewController?
    
    lazy var collView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.allowsMultipleSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: noColorButton, titleLabel: titleLabel, topScreenAnchor: self.topAnchor)
        view.backgroundFillerColor(color: delegate?.viewModel?.theme?.currentTheme.navigation.backgroundColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var noColorButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "None", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleNoColor), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "About", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.title)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: RecipeColorViewController) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {

        addSubview(navView)
        addSubview(collView)
        collView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: delegate?.viewModel?.cellId ?? "recipeColorId")
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        guard let vm = delegate?.viewModel else {
            return
        }
        if (vm.appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let vm = delegate?.viewModel else {
            return
        }
        let navTopConstraint = !vm.appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !vm.appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: collView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true
        
        titleLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: navView.centerYAnchor, centerX: navView.centerXAnchor, padding: .zero, size: .zero)
        collView.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
    }
    
    @objc func handleDismiss() {
        delegate?.delegate?.mainView.tableView.reloadData()
        delegate?.delegate?.dismissCurrentViewController()
    }
    
    @objc func handleNoColor() {
        
        guard let vm = delegate?.viewModel else { return }
        
        let clearColor = UIColor.clear
        
        vm.recipe.color = NSKeyedArchiver.archivedData(withRootObject: clearColor)
        CoreDataHandler.saveContext()
    }
    
}

class RecipeColorViewController: ViewControllerBase {
    
    weak var delegate: RecipeEditViewController?
    
    var viewModel: RecipeColorViewModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(delegate: RecipeEditViewController, viewModel: RecipeColorViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainView : RecipeColorView = {
        let view = RecipeColorView(delegate: self)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.fillSuperView()
    }
}
