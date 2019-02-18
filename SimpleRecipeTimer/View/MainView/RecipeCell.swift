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

            self.prepareLabels(name, e.timeRemainingForCurrentStepToString())
            
            if (e.isPaused) {
                pauseButton.setAttributedTitle(NSAttributedString(string: "unpause", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
                totalTimeLabel?.textColor = Theme.Font.Color.TextColourDisabled
            } else {
                pauseButton.setAttributedTitle(NSAttributedString(string: "pause", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
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
        return gradientLayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = bounds
    }
    
    func prepareLabels(_ name: String,_ time: String) {
        self.contentView.addSubview(nameLabel)
        nameLabel.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Recipe.NameAttribute)

        stepNameLabel.attributedText = NSAttributedString(string: "unknown", attributes: Theme.Font.Recipe.StepSubTitle)
        self.contentView.addSubview(stepNameLabel)
        
        totalTimeLabel = UILabel()
        totalTimeLabel?.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Recipe.TimeAttribute)
        totalTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(totalTimeLabel!)
        
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant:0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        totalTimeLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        totalTimeLabel?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        stepNameLabel.topAnchor.constraint(equalTo: (totalTimeLabel?.bottomAnchor)!).isActive = true
        stepNameLabel.leadingAnchor.constraint(equalTo: totalTimeLabel!.leadingAnchor, constant: 0).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.removeFromSuperview()
        self.totalTimeLabel?.removeFromSuperview()
        self.totalTimeLabel = nil
    }
    
    override func setupView() {
        self.backgroundColor = Theme.Background.Color.CellBackgroundColor
        pauseButton.addTarget(self, action: #selector(recipePauseHandler), for: .touchUpInside)
        self.contentView.addSubview(pauseButton)

        layer.insertSublayer(gl, at: 0)
        pauseButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        
        layer.cornerRadius = 15.0
        clipsToBounds = false

        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor(red:0.65, green:0.65, blue:0.65, alpha:1.0).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    @objc func recipePauseHandler() {
        self.updatePauseButton()
    }
    
    func updatePauseButton() {
        guard let mvc = mainViewController else {
            //TODO: - error
            return
        }
        
        //should be done in the model. let the VC update the cell
        if let r = entity {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else {
                    return
                }
                if (!r.isPaused) {

                    mvc.pauseEntireRecipe(recipe: r)
                    DispatchQueue.main.async {
                        self.pauseButton.setAttributedTitle(NSAttributedString(string: "unpause", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
                        self.totalTimeLabel?.textColor = Theme.Font.Color.TextColourDisabled
                    }
                } else {
                    let pauseState = false
                    mvc.unpauseEntireRecipe(recipe: r)
                    
                    CoreDataHandler.getPrivateContext().perform {
                        if let singleEntity = CoreDataHandler.fetchByDate(in: RecipeEntity.self, date: r.createdDate!) {
                            singleEntity.isPaused = pauseState
                        }
                        r.isPaused = pauseState
                    }
                    
                    DispatchQueue.main.async {
                        self.pauseButton.setAttributedTitle(NSAttributedString(string: "pause", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
                        self.totalTimeLabel?.textColor = Theme.Font.Color.TextColour
                    }
                }
            }
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
            totalTimeLabel?.attributedText = NSAttributedString(string: "unknown", attributes: Theme.Font.Recipe.TimeAttribute)
        }
    }
}
