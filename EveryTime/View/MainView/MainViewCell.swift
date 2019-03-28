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
    public var mainViewController: MainViewController? = nil
    public var cellForIndexPath: IndexPath?
    private lazy var recipeTimeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "00h 00m 00s", attributes: Theme.Font.Recipe.TimeAttribute)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var nextShortestTimeLabel: UILabel? = nil
    private lazy var nameLabelAnimationYMovement: CGFloat = 0.0
    private var stepName: String? = nil

    override var entity: RecipeEntity? {
        didSet {
            guard let r = entity else {
                return
            }
            guard let name = r.recipeName else {
                return
            }
            
            prepareLabels(recipe: r)
            let bg = r.isPaused ? Theme.View.RecipeCell.RecipeCellPauseButtonInactive : Theme.View.RecipeCell.RecipeCellPauseButtonActive
            let textColor = r.isPaused ? Theme.Font.Color.TextColourDisabled : Theme.Font.Color.TextColour
            let highlightAlpha: CGFloat = r.isPaused ? 0.85 : 0.25
            updatePauseButtonView(textColor, highlightAlpha, bg)
            
            if (r.isPaused) {
                bringSubviewToFront(timerHighlight)
            } else {
                bringSubviewToFront(recipeTimeLabel)
            }
        }
    }
    private lazy var stepNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.View.RecipeCell.RecipeCellPauseButtonActive
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: 0,bottom: -10,right: 0)
        button.layer.cornerRadius = 8.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 12.0, bottom: 5.0, right: 12.0)
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
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.0)//Theme.Background.Color.NavBottomBorderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var pauseButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//Theme.Background.Color.CellButtonBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var timerHighlight: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.View.RecipeCell.MainViewTimerCellHighlight
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
    }
    
    func prepareLabels(recipe: RecipeEntity) {
        nameLabel.attributedText = NSAttributedString(string: recipe.recipeName ?? "Unknown Recipe Name", attributes: Theme.Font.Recipe.NameAttribute)
        stepNameLabel.attributedText = NSAttributedString(string: recipe.currStepName ?? "Unknown Step Name", attributes: Theme.Font.Recipe.StepSubTitle)
        recipeTimeLabel.attributedText = NSAttributedString(string: recipe.timeRemainingForCurrentStepToString(), attributes: Theme.Font.Recipe.TimeAttribute)
        
        nameLabel.backgroundColor = Theme.Background.Color.Clear
        stepNameLabel.backgroundColor = Theme.Background.Color.Clear
        recipeTimeLabel.backgroundColor = Theme.Background.Color.Clear
        
        addSubview(nameLabel)
        addSubview(recipeTimeLabel)
        addSubview(stepNameLabel)
        addSubview(timerHighlight)
        labelAutoLayout()
    }
    
    func labelAutoLayout() {
        let leftSidePadding: CGFloat = 25.0
        nameLabel.anchorView(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: leftSidePadding, bottom: 0.0, right: 0.0), size: .zero)
        recipeTimeLabel.anchorView(top: nil, bottom: nil, leading: contentView.leadingAnchor, trailing: nil, centerY: contentView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: textLabelPadding, left: leftSidePadding, bottom: 0.0, right: 0.0), size: .zero)
        stepNameLabel.anchorView(top: nameLabel.bottomAnchor, bottom: nil, leading: recipeTimeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: textLabelPadding, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
        timerHighlight.anchorView(top: nil, bottom: nil, leading: recipeTimeLabel.leadingAnchor, trailing: recipeTimeLabel.trailingAnchor, centerY: recipeTimeLabel.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: 10.0))
    }
    
    override func setupView() {
        clipsToBounds = false
        layer.backgroundColor = UIColor.clear.cgColor
        layer.masksToBounds = true
        addSubview(pauseButtonView)
        backgroundColor = UIColor.clear//Theme.Background.Color.CellBackgroundColor

        pauseButton.addTarget(self, action: #selector(handlePauseButton), for: .touchUpInside)
        pauseButtonView.addSubview(pauseButton)

        pauseButtonView.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: nil, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 80.0, height: 0.0))
        pauseButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, centerY: pauseButtonView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -25.0), size: CGSize(width: 35.0, height: 18.0))
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.removeFromSuperview()
        recipeTimeLabel.removeFromSuperview()
        timerHighlight.removeFromSuperview()
        stepNameLabel.removeFromSuperview()
    }
    
    @objc func handlePauseButton() {
        updatePauseState()
        CoreDataHandler.saveContext()
    }
    
    func updatePauseState() {
        guard let mvc = mainViewController else {
            //TODO: - error
            return
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        //should be done in the model. let the VC's VM update the cell data
        if let r = entity {
            let bg = r.isPaused ? Theme.View.RecipeCell.RecipeCellPauseButtonActive : Theme.View.RecipeCell.RecipeCellPauseButtonInactive
            let textColor = r.isPaused ? Theme.Font.Color.TextColour : Theme.Font.Color.TextColourDisabled
            let highlightAlpha: CGFloat = r.isPaused ? 0.25 : 0.85

            if (r.isPaused) {
                //will unpause
                mvc.unpauseEntireRecipe(recipe: r)
                bringSubviewToFront(recipeTimeLabel)
                self.updatePauseButtonView(textColor, highlightAlpha, bg)
            } else {
                mvc.pauseEntireRecipe(recipe: r)
                bringSubviewToFront(timerHighlight)
                let id = "\(r.recipeName!).\(r.createdDate!)"
                self.updatePauseButtonView(textColor, highlightAlpha, bg)
                
                LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
            }
        }
    }
    
    func updatePauseHighlight() {
        if let r = entity {
            if (r.isPaused) {
                bringSubviewToFront(timerHighlight)
            } else {
                bringSubviewToFront(recipeTimeLabel)
            }
        }
    }
    
    func updatePauseButtonView(_ color: UIColor, _ alpha: CGFloat, _ bg: UIColor) {
        DispatchQueue.main.async {
            self.pauseButton.backgroundColor = bg
            self.recipeTimeLabel.textColor = color
            self.timerHighlight.alpha = alpha
        }
    }
    
    func updateStepLabel() {
        guard let e = entity else {
            return
        }
        stepNameLabel.attributedText = NSAttributedString(string: e.currStepName ?? "No Step Name", attributes: Theme.Font.Recipe.StepSubTitle)
    }
    
    func updateTimeLabel(timeRemaining: String) {
        guard let e = entity else {
            return
        }
        DispatchQueue.main.async {
            self.stepNameLabel.attributedText = NSAttributedString(string: e.currStepName ?? "No Step Name", attributes: Theme.Font.Recipe.StepSubTitle)
            if self.entity != nil {
                    self.recipeTimeLabel.attributedText = NSAttributedString(string: timeRemaining, attributes: Theme.Font.Recipe.TimeAttribute)
            } else {
                    self.recipeTimeLabel.attributedText = NSAttributedString(string: "No Time", attributes: Theme.Font.Recipe.TimeAttribute)
            }
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
            UIColor(red: 0.5, green: 0.55, blue: 0.5, alpha: 1.0).cgColor,
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        ]
        selectionFadeAnimation.fillMode = CAMediaTimingFillMode.forwards
        selectionFadeAnimation.isRemovedOnCompletion = true
        layer.add(selectionFadeAnimation, forKey: "selectCellFade")
        
    }
}
