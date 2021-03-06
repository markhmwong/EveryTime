//
//  RecipeCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class MainViewCell: EntityBaseCell<RecipeEntity> {
    
    var theme: ThemeManager?
    
    var delegate: MainViewController? = nil
    
    var cellForIndexPath: IndexPath?
    
    private var nextShortestTimeLabel: UILabel? = nil
    
    private lazy var nameLabelAnimationYMovement: CGFloat = 0.0
    
    private var stepName: String? = nil
    
    override var entity: RecipeEntity? {
        didSet {
            guard let r = entity, let theme = theme else {
                return
            }
            prepareLabels(recipe: r)
            let bg = !r.isPaused ? theme.currentTheme.tableView.pauseButtonBackgroundInactive : theme.currentTheme.tableView.pauseButtonBackgroundActive
            let textColor: UIColor = r.isPaused ? theme.currentTheme.tableView.pausedTextColor : theme.currentTheme.tableView.cellTextColor
//            let highlightAlpha: CGFloat = r.isPaused ? 0.85 : 0.25
            updatePauseButtonView(textColor, bg)

        }
    }
    
    private lazy var recipeTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stepNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorTag: UIView = {
        let colorTagView = UIView()
        colorTagView.clipsToBounds = true
        
        colorTagView.layer.cornerRadius = 5.0
        
        colorTagView.layer.backgroundColor = UIColor.black.cgColor
        colorTagView.layer.borderColor = UIColor.orange.cgColor
        colorTagView.layer.borderWidth = 2
        colorTagView.translatesAutoresizingMaskIntoConstraints = false
        return colorTagView
    }()

    private lazy var pauseButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = theme?.currentTheme.tableView.cellTextColor
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: 0,bottom: -10,right: 0)
        button.layer.cornerRadius = 8.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 12.0, bottom: 5.0, right: 12.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var resetButton: StandardButton = {
        let button = StandardButton(title: "", theme: theme)
        let image = UIImage(named: "Reset_Light_One")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var gl: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Theme.Background.Gradient.CellColorTop, Theme.Background.Gradient.CellColorBottom]
        gradientLayer.locations = [0.3, 1.0]
        gradientLayer.shouldRasterize = true // rasterise so we don't need to redraw
        gradientLayer.masksToBounds = true
        return gradientLayer
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var pauseButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.Clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var textLabelPadding: CGFloat {
        switch UIDevice.current.screenType {
            case UIDevice.ScreenType.iPhones_5_5s_5c_SE:
                return 3.0
            default:
                return 10.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = bounds
        let leftSidePadding: CGFloat = 25.0
        recipeNameLabel.anchorView(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: leftSidePadding, bottom: 0.0, right: 0.0), size: .zero)
        recipeTimeLabel.anchorView(top: contentView.centerYAnchor, bottom: nil, leading: recipeNameLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
        stepNameLabel.anchorView(top: nil, bottom: contentView.centerYAnchor, leading: recipeTimeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
        bottomBorder.anchorView(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 1.0))

        guard let vm = delegate?.viewModel else { return }
        
        pauseButtonView.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: nil, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 80.0, height: 0.0))

        pauseButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, centerY: pauseButtonView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -25.0), size: vm.pauseButtonSize)
        
        resetButton.anchorView(top: nil, bottom: contentView.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -7.0, right: 0.0), size: vm.resetButtonSize)
        colorTag.anchorView(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0), size: CGSize(width: 10.0, height: bounds.height / 6))

    }
    
    func prepareLabels(recipe: RecipeEntity) {
        guard let theme = theme else {
            return
        }
        recipeNameLabel.attributedText = NSAttributedString(string: recipe.recipeName ?? "Unknown Recipe Name", attributes:  theme.currentTheme.tableView.mainViewRecipeName)
        stepNameLabel.attributedText = NSAttributedString(string: recipe.currStepName ?? "Unknown Step Name", attributes: theme.currentTheme.tableView.mainViewStepName)
        recipeTimeLabel.attributedText = NSAttributedString(string: recipe.timeRemainingForCurrentStepToString(), attributes: theme.currentTheme.tableView.mainViewRecipeTime)
        
        bottomBorder.backgroundColor = theme.currentTheme.tableView.bottomBorderColor
        
        colorTag.layer.backgroundColor = recipe.colorUnarchive().cgColor
        colorTag.layer.borderColor = recipe.colorUnarchive().lighter(by: 30.0)?.cgColor
        addSubview(recipeNameLabel)
        addSubview(recipeTimeLabel)
        addSubview(stepNameLabel)
        addSubview(bottomBorder)
        addSubview(colorTag)
    }
    
    override func setupView() {
        clipsToBounds = false
        addSubview(pauseButtonView)
        pauseButton.addTarget(self, action: #selector(handlePauseButton), for: .touchUpInside)
        pauseButtonView.addSubview(pauseButton)

    }
    
    func addResetButton() {
        resetButton.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        resetButton.theme = theme
        resetButton.setupView("")
        addSubview(resetButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeNameLabel.removeFromSuperview()
        recipeTimeLabel.removeFromSuperview()
        stepNameLabel.removeFromSuperview()
        resetButton.removeFromSuperview()
        colorTag.removeFromSuperview()
    }
    
    @objc func handlePauseButton() {
        updatePauseState()
        CoreDataHandler.saveContext()
    }
    
    @objc func handleResetButton() {
        guard let mvc = delegate else {
            //TODO: - error
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard let rEntity = entity else { return }
        mvc.resetCurrentStep(rEntity: rEntity)
        rEntity.wasReset = true
//        handle localnotifications
        let id = LocalNotificationsService.shared.locationNotificationIdentifierFor(recipe: rEntity)
        LocalNotificationsService.shared.addRecipeWideNotification(identifier: id, notificationContent: [NotificationDictionaryKeys.Title.rawValue : rEntity.recipeName!], timeRemaining: rEntity.totalTimeRemaining)
    }
    
    func updatePauseState() {
        guard let mvc = delegate else {
            //TODO: - error
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        //should be done in the model. let the VC's VM update the cell data
        if let r = entity {
            guard let theme = theme else { return }
            
            let pauseBackground = r.isPaused ? theme.currentTheme.tableView.pauseButtonBackgroundInactive : theme.currentTheme.tableView.pauseButtonBackgroundActive
            let textColor = !r.isPaused ? theme.currentTheme.tableView.pausedTextColor : theme.currentTheme.tableView.cellTextColor

            if (r.isPaused) {
                //will unpause
                mvc.unpauseEntireRecipe(recipe: r)
                self.updatePauseButtonView(textColor, pauseBackground)
            } else {
                mvc.pauseEntireRecipe(recipe: r)
                let id = "\(r.recipeName!).\(r.createdDate!)"
                self.updatePauseButtonView(textColor, pauseBackground)
                
                LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            }
        }
    }
    
    func updatePauseButtonView(_ color: UIColor,_ bg: UIColor) {
        DispatchQueue.main.async {
            self.pauseButton.backgroundColor = bg
            self.recipeTimeLabel.textColor = color
        }
    }
    
    func updateStepLabel() {
        guard let e = entity, let theme = theme else {
            return
        }
        stepNameLabel.attributedText = NSAttributedString(string: e.currStepName ?? "No Step Name", attributes: theme.currentTheme.tableView.mainViewStepName)
    }
    
    func updateRecipeLabel() {
        guard let e = entity, let theme = theme else {
            return
        }
        recipeNameLabel.attributedText = NSAttributedString(string: e.recipeName ?? "No Step Name", attributes: theme.currentTheme.tableView.mainViewRecipeName)
    }
    
    func updateTimeLabel(timeRemaining: String) {
        guard let e = entity, let theme = theme else {
            return
        }

        DispatchQueue.main.async {
            var timeString = ""
            if self.entity != nil {
                timeString = timeRemaining
            } else {
                timeString = "No Time"
            }
            
            self.recipeTimeLabel.attributedText = NSAttributedString(string: timeString, attributes: theme.currentTheme.tableView.mainViewRecipeTime)
            self.stepNameLabel.attributedText = NSAttributedString(string: e.currStepName ?? "No Step Name", attributes: theme.currentTheme.tableView.mainViewStepName)
        }
    }
    
    func updateColorTag() {
        guard let recipe = entity else { return }
        DispatchQueue.main.async {
            self.colorTag.layer.backgroundColor = recipe.colorUnarchive().cgColor
            self.colorTag.layer.borderColor = recipe.colorUnarchive().lighter(by: 50.0)?.cgColor
        }
    }
    
    func animateCellForCompleteStep() {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.toValue = [
            UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 0.2).cgColor,
            UIColor(red:1.00, green:0.00, blue:0.42, alpha:0.2).cgColor,
        ]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = true
        gl.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    func animateCellForSelection() {
        let selectionFadeAnimation = CABasicAnimation(keyPath: "backgroundColor")
        selectionFadeAnimation.duration = 0.15
        selectionFadeAnimation.autoreverses = true
        selectionFadeAnimation.toValue = [
            UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor,
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        ]
        selectionFadeAnimation.fillMode = CAMediaTimingFillMode.forwards
        selectionFadeAnimation.isRemovedOnCompletion = true
        layer.add(selectionFadeAnimation, forKey: "selectCellFade")
        
    }
}
