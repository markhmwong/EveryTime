//
//  RecipeCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class RecipeCell: EntityBaseCell<RecipeEntity> {
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
    fileprivate var stepNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate var totalTimeLabel: UILabel? = nil
    fileprivate var nextShortestTimeLabel: UILabel? = nil
    fileprivate var pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: 0,bottom: -10,right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate lazy var nameLabelAnimationYMovement: CGFloat = 0.0
    var mainViewController: MainViewController? = nil
    var cellForIndexPath: IndexPath?
    fileprivate var stepName: String? = nil
    var gl: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Theme.Background.Gradient.CellColorTop, Theme.Background.Gradient.CellColorBottom]
        gradientLayer.locations = [0.3, 1.0]
        gradientLayer.shouldRasterize = true // rasterise so we don't need to redraw
        gradientLayer.masksToBounds = true
        return gradientLayer
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
        addSubview(totalTimeLabel!)

        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant:0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true

        totalTimeLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        totalTimeLabel?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true

        stepNameLabel.topAnchor.constraint(equalTo: (totalTimeLabel?.bottomAnchor)!).isActive = true
        stepNameLabel.leadingAnchor.constraint(equalTo: totalTimeLabel!.leadingAnchor, constant: 0).isActive = true
    }
    
    override func setupView() {
        layer.insertSublayer(gl, at: 0)
        layer.cornerRadius = 15.0
        clipsToBounds = false
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = true

        
        backgroundColor = Theme.Background.Color.CellBackgroundColor
        pauseButton.backgroundColor = Theme.Background.Color.Clear
        pauseButton.addTarget(self, action: #selector(recipePauseHandler), for: .touchUpInside)
        addSubview(pauseButton)

        pauseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
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
            if (r.isPaused) {
                mvc.unpauseEntireRecipe(recipe: r)
                self.updatePauseButton(pauseButtonText, textColor)

                guard let sName = r.currStepName else {
                    return
                }
                guard let rName = r.recipeName else {
                    return
                }
                guard let createdDate = r.createdDate else {
                    return
                }
                
                let identifier = "\(rName).\(createdDate)"
                //recipe notification
                LocalNotificationsService.shared.addRecipeWideNotification(identifier: identifier, notificationContent: [NotificationDictionaryKeys.Title.rawValue : rName], timeRemaining: r.totalTimeRemaining)
            } else {
                LocalNotificationsService.shared.notificationCenterInstance().removeAllPendingNotificationRequests()
                mvc.pauseEntireRecipe(recipe: r)
                self.updatePauseButton(pauseButtonText, textColor)
            }
        }
    }
    
    func updatePauseButton(_ text: String, _ color: UIColor) {
        DispatchQueue.main.async {
            self.pauseButton.setAttributedTitle(NSAttributedString(string: text, attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
            self.totalTimeLabel?.textColor = color
        }
    }
    
    func updateTimeLabel(timeRemaining: String) {
        guard let e = entity else {
            return
        }
        
        stepNameLabel.attributedText = NSAttributedString(string: e.currStepName ?? "No Step Name", attributes: Theme.Font.Recipe.StepSubTitle)
        if entity != nil {
            totalTimeLabel?.attributedText = NSAttributedString(string: timeRemaining, attributes: Theme.Font.Recipe.TimeAttribute)
        } else {
            totalTimeLabel?.attributedText = NSAttributedString(string: "No Time", attributes: Theme.Font.Recipe.TimeAttribute)
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
}
