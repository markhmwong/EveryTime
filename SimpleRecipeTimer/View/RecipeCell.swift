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
            } else {
                pauseButton.setAttributedTitle(NSAttributedString(string: "pause", attributes: Theme.Font.Recipe.PauseAttribute), for: .normal)
            }
        }
    }
    fileprivate var nameLabel: UILabel? = nil
//    fileprivate var switchButtonState: Bool = true
    fileprivate var totalTimeLabel: UILabel? = nil
    fileprivate var nextShortestTimeLabel: UILabel? = nil
    fileprivate var pauseButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var nameLabelAnimationYMovement: CGFloat = 0.0
    var mainViewController: MainViewController? = nil
    var cellForIndexPath: IndexPath?
    
    override func prepareLabels(_ name: String,_ time: String) {
        nameLabel = UILabel()
        nameLabel?.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Recipe.NameAttribute)
        nameLabel?.backgroundColor = UIColor.StandardTheme.Font.RecipeLabelBackgroundColour
        
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
        self.clipsToBounds = false
        self.backgroundColor = UIColor.StandardTheme.Recipe.RecipeCellBackground
        
        pauseButton.addTarget(self, action: #selector(recipePauseHandler), for: .touchUpInside)
        pauseButton.setTitle("pause", for: .normal)

        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(pauseButton)
        pauseButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    //combine with pause button handler
    func updateTextWhenPaused() {
        if let r = entity {
            if let name = entity?.recipeName {
                nameLabel?.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Recipe.NameAttribute)
            }
            totalTimeLabel?.attributedText = NSAttributedString(string: "00h00m00s", attributes: Theme.Font.Recipe.TimeAttribute)
        }
    }
    
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
                    mvc.pauseEntireRecipe(recipe: r)
                    DispatchQueue.main.async {
                        self.pauseButton.setTitle("unpause", for: .normal)
                        r.isPaused = !r.isPaused
                    }
                } else {
                    mvc.unpauseEntireRecipe(recipe: r)
                    DispatchQueue.main.async {
                        self.pauseButton.setTitle("pause", for: .normal)
                        r.isPaused = !r.isPaused
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
    
    func updateNameLabel(name: String) {
        
    }
    

    //MARK: - no longer using the animating effect
    func animateNameLabel(state: Bool) {
        nameLabelAnimationYMovement = state ? 0 : ((nameLabel?.frame.size.height)! / 2) * -1
        if (!state) {
            UIView.animate(withDuration: 0.3) {
                self.nameLabel?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.nameLabel?.transform = CGAffineTransform.identity
                self.layoutIfNeeded()
            }
        }
    }
}
