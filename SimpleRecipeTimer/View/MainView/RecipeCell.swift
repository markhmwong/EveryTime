//
//  RecipeCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class RecipeCell: EntityBaseCell<RecipeEntity> {
    override var entity: RecipeEntity? {
        didSet {
            guard let name = entity?.recipeName else {
                return
            }
            
            guard let time = entity?.timeRemaining() else {
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
    
    func prepareLabels(_ name: String,_ time: String) {
        nameLabel = UILabel()
        nameLabel?.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Recipe.NameAttribute)
        nameLabel?.backgroundColor = UIColor.clear
        
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(nameLabel!)
        nameLabel?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant:10).isActive = true
        nameLabel?.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        
        totalTimeLabel = UILabel()
        totalTimeLabel?.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Recipe.TimeAttribute)
        totalTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(totalTimeLabel!)
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
//        self.contentView.layer.backgroundColor = UIColor.clear.cgColor
//        self.clipsToBounds = false
        self.backgroundColor = Theme.Background.Color.CellBackgroundColor
        
        pauseButton.addTarget(self, action: #selector(recipePauseHandler), for: .touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(pauseButton)
        pauseButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        pauseButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        pauseButton.backgroundColor = UIColor.blue
        pauseButton.titleEdgeInsets = UIEdgeInsets(top: -10,left: 0,bottom: -10,right: 0)
    }
    
    //combine with pause button handler
//    func updateTextWhenPaused() {
//        if entity != nil {
//            if let name = entity?.recipeName {
//                nameLabel?.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Recipe.NameAttribute)
//            }
//            totalTimeLabel?.attributedText = NSAttributedString(string: "00h00m00s", attributes: Theme.Font.Recipe.TimeAttributeInactive)
//        }
//    }
    
    @objc func recipePauseHandler() {
        self.updatePauseButton()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    func updatePauseButton() {
        guard let mvc = mainViewController else {
            //TODO: - error
            return
        }
        
        if let r = entity {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else {
                    return
                }
                if (!r.isPaused) {
                    let pauseState = true
                    mvc.pauseEntireRecipe(recipe: r)

                    if let singleEntity = CoreDataHandler.fetchByDate(in: RecipeEntity.self, date: r.createdDate!) {
                        singleEntity.isPaused = pauseState
                    }
                    DispatchQueue.main.async {
                        CoreDataHandler.saveContext()
                        self.pauseButton.setAttributedTitle(NSAttributedString(string: "unpause", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
                        self.totalTimeLabel?.textColor = Theme.Font.Color.TextColourDisabled
                        r.isPaused = pauseState
                    }
                } else {
                    let pauseState = false
                    mvc.unpauseEntireRecipe(recipe: r)

                    if let singleEntity = CoreDataHandler.fetchByDate(in: RecipeEntity.self, date: r.createdDate!) {
                        singleEntity.isPaused = pauseState
                    }

                    DispatchQueue.main.async {
                        CoreDataHandler.saveContext()
                        self.pauseButton.setAttributedTitle(NSAttributedString(string: "pause", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
                        self.totalTimeLabel?.textColor = Theme.Font.Color.TextColour
                        r.isPaused = pauseState
                    }
                }
            }
        }
    }
    
    func updateTimeLabel(timeRemaining: String) {
        if let r = entity {
            totalTimeLabel?.attributedText = NSAttributedString(string: timeRemaining, attributes: Theme.Font.Recipe.TimeAttribute)
        } else {
            totalTimeLabel?.attributedText = NSAttributedString(string: "unknown", attributes: Theme.Font.Recipe.TimeAttribute)
        }
    }
    
//    func updateNameLabel(name: String) {
//
//    }
    

    //MARK: - no longer using the animating effect
//    func animateNameLabel(state: Bool) {
//        nameLabelAnimationYMovement = state ? 0 : ((nameLabel?.frame.size.height)! / 2) * -1
//        if (!state) {
//            UIView.animate(withDuration: 0.3) {
//                self.nameLabel?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                self.layoutIfNeeded()
//            }
//        } else {
//            UIView.animate(withDuration: 0.3) {
//                self.nameLabel?.transform = CGAffineTransform.identity
//                self.layoutIfNeeded()
//            }
//        }
//    }
}
