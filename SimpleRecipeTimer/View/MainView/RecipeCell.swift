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
            guard let name = entity?.recipeName else {
                return
            }
            
            guard let time = entity?.timeRemainingForCurrentStepToString() else {
                return
            }
            self.prepareLabels(name, time)
            
            guard let pauseState = entity?.isPaused else {
                return
            }
            
            if (pauseState) {
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
    fileprivate var nameLabel: UILabel? = nil
    fileprivate var totalTimeLabel: UILabel? = nil
    fileprivate var nextShortestTimeLabel: UILabel? = nil
    fileprivate var pauseButton: UIButton = {
        let button = UIButton()
        return button
    }()
    lazy var nameLabelAnimationYMovement: CGFloat = 0.0
    var mainViewController: MainViewController? = nil
    var cellForIndexPath: IndexPath?
    var stepName: String? = nil
    
    
    func prepareLabels(_ name: String,_ time: String) {
        nameLabel = UILabel()
        nameLabel?.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Recipe.NameAttribute)
        nameLabel?.backgroundColor = UIColor.clear
        
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(nameLabel!)
        
        stepNameLabel.attributedText = NSAttributedString(string: "unknown", attributes: Theme.Font.Recipe.NameAttribute)
        self.contentView.addSubview(stepNameLabel)
        
        totalTimeLabel = UILabel()
        totalTimeLabel?.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Recipe.TimeAttribute)
        totalTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(totalTimeLabel!)

        
        nameLabel?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant:10).isActive = true
        nameLabel?.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        
        totalTimeLabel?.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        totalTimeLabel?.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel?.removeFromSuperview()
        self.nameLabel = nil
        self.totalTimeLabel?.removeFromSuperview()
        self.totalTimeLabel = nil
    }
    
    override func setupView() {
        layer.cornerRadius = 4
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
        self.backgroundColor = Theme.Background.Color.CellBackgroundColor
        
        pauseButton.addTarget(self, action: #selector(recipePauseHandler), for: .touchUpInside)
        pauseButton.backgroundColor = UIColor.clear
        pauseButton.titleEdgeInsets = UIEdgeInsets(top: -10,left: 0,bottom: -10,right: 0)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(pauseButton)
        
        pauseButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
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
//                        CoreDataHandler.saveContext()
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
        stepNameLabel.text = e.currStepName
        if entity != nil {
            totalTimeLabel?.attributedText = NSAttributedString(string: timeRemaining, attributes: Theme.Font.Recipe.TimeAttribute)
        } else {
            totalTimeLabel?.attributedText = NSAttributedString(string: "unknown", attributes: Theme.Font.Recipe.TimeAttribute)
        }
    }
}
