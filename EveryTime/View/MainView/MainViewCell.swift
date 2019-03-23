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
    private var totalTimeLabel: UILabel? = nil
    private var nextShortestTimeLabel: UILabel? = nil
    private lazy var nameLabelAnimationYMovement: CGFloat = 0.0
    private var stepName: String? = nil

    override var entity: RecipeEntity? {
        didSet {
            guard let e = entity else {
                return
            }
            guard let name = e.recipeName else {
                return
            }

            prepareLabels(name, e.timeRemainingForCurrentStepToString())
            
            if (e.isPaused) {
                pauseButton.setAttributedTitle(NSAttributedString(string: "start", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
                totalTimeLabel?.textColor = Theme.Font.Color.TextColourDisabled
            } else {
                pauseButton.setAttributedTitle(NSAttributedString(string: "stop", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
            }
        }
    }
    private var stepNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: 0,bottom: -10,right: 0)
        button.layer.borderColor = UIColor(red:0.02, green:0.08, blue:0.03, alpha:1.0).cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 4.0
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
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.6)//Theme.Background.Color.NavBottomBorderColor
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
        view.backgroundColor = Theme.Background.Color.MainViewTimerCellHighlight
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = bounds
    }
    
    func prepareLabels(_ name: String,_ time: String) {
        nameLabel.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Recipe.NameAttribute)
        stepNameLabel.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Recipe.StepSubTitle)
        
        totalTimeLabel = UILabel()
        totalTimeLabel?.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Recipe.TimeAttribute)
        totalTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.backgroundColor = Theme.Background.Color.Clear
        stepNameLabel.backgroundColor = Theme.Background.Color.Clear
        totalTimeLabel?.backgroundColor = Theme.Background.Color.Clear
        
        addSubview(nameLabel)
        addSubview(stepNameLabel)
        addSubview(timerHighlight)
        addSubview(totalTimeLabel!)
        
        let leftSidePadding: CGFloat = 25.0
        nameLabel.anchorView(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: leftSidePadding, bottom: 0.0, right: 0.0), size: .zero)
        totalTimeLabel?.anchorView(top: nil, bottom: nil, leading: contentView.leadingAnchor, trailing: nil, centerY: contentView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: leftSidePadding, bottom: 0.0, right: 0.0), size: .zero)
        stepNameLabel.anchorView(top: nil, bottom: totalTimeLabel!.topAnchor, leading: totalTimeLabel!.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        timerHighlight.anchorView(top: totalTimeLabel?.centerYAnchor, bottom: totalTimeLabel?.bottomAnchor, leading: totalTimeLabel?.leadingAnchor, trailing: totalTimeLabel?.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 18.0, left: 0.0, bottom: 0.0, right: -15.0), size: .zero)
    }
    
    override func setupView() {
        layer.cornerRadius = 0.0
        clipsToBounds = false
        layer.backgroundColor = UIColor.clear.cgColor
        layer.masksToBounds = true

        addSubview(pauseButtonView)
        
        backgroundColor = UIColor.clear//Theme.Background.Color.CellBackgroundColor

        pauseButton.addTarget(self, action: #selector(recipePauseHandler), for: .touchUpInside)
        pauseButtonView.addSubview(pauseButton)

        pauseButtonView.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: nil, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 80.0, height: 0.0))
        pauseButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, centerY: pauseButtonView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -25.0), size: .zero)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.removeFromSuperview()
        totalTimeLabel?.removeFromSuperview()
        totalTimeLabel = nil
    }
    
    @objc func recipePauseHandler() {
        updatePauseButton()
        CoreDataHandler.saveContext()
    }
    
    func updatePauseButton() {
        guard let mvc = mainViewController else {
            //TODO: - error
            return
        }
        
        //should be done in the model. let the VC update the cell
        if let r = entity {
            let pauseButtonText = r.isPaused ? "stop" : "start"
            let textColor = r.isPaused ? Theme.Font.Color.TextColour : Theme.Font.Color.TextColourDisabled
            let highlightAlpha: CGFloat = r.isPaused ? 0.85 : 0.4
            
            if (r.isPaused) {
                mvc.unpauseEntireRecipe(recipe: r)
                self.updatePauseButton(pauseButtonText, textColor, highlightAlpha)
            } else {
                let id = "\(r.recipeName!).\(r.createdDate!)"
                LocalNotificationsService.shared.notificationCenterInstance().removePendingNotificationRequests(withIdentifiers: [id])
                mvc.pauseEntireRecipe(recipe: r)
                self.updatePauseButton(pauseButtonText, textColor, highlightAlpha)
            }
        }
    }
    
    func updatePauseButton(_ text: String, _ color: UIColor, _ alpha: CGFloat) {
        DispatchQueue.main.async {
            self.pauseButton.setAttributedTitle(NSAttributedString(string: text, attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
            self.totalTimeLabel?.textColor = color
            self.timerHighlight.alpha = alpha
        }
    }
    
    func updateTimeLabel(timeRemaining: String) {
        guard let e = entity else {
            return
        }
        DispatchQueue.main.async {
            self.stepNameLabel.attributedText = NSAttributedString(string: e.currStepName ?? "No Step Name", attributes: Theme.Font.Recipe.StepSubTitle)
        }
        if entity != nil {
            DispatchQueue.main.async {
                self.totalTimeLabel?.attributedText = NSAttributedString(string: timeRemaining, attributes: Theme.Font.Recipe.TimeAttribute)
            }

        } else {
            DispatchQueue.main.async {
                self.totalTimeLabel?.attributedText = NSAttributedString(string: "No Time", attributes: Theme.Font.Recipe.TimeAttribute)
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
