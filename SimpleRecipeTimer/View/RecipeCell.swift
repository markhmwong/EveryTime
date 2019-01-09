//
//  RecipeCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class RecipeCell: BaseCell {
    fileprivate var titleLabel: UILabel? = nil
//    fileprivate var switchButtonState: Bool = true
    fileprivate var totalTimeLabel: UILabel? = nil
    fileprivate var nextShortestTimeLabel: UILabel? = nil
    fileprivate var pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("pause", for: .normal)
        button.backgroundColor = UIColor.blue
        return button
    }()
    lazy var nameLabelAnimationYMovement: CGFloat = 0.0
    var mainViewController: MainViewController? = nil
    
    var recipe: Recipe? {
        didSet {
            if let name = recipe?.name {
                if titleLabel == nil {
                    let attributes: [NSAttributedString.Key :Any ] = [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.SizeCell)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColour]
                    
                    titleLabel = UILabel()
                    titleLabel?.attributedText = NSAttributedString(string: "\(name)", attributes: attributes)
                    titleLabel?.backgroundColor = UIColor.StandardTheme.Font.RecipeLabelBackgroundColour
                    
                    titleLabel?.translatesAutoresizingMaskIntoConstraints = false
                    self.contentView.addSubview(titleLabel!)
                    titleLabel?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant:10).isActive = true
                    titleLabel?.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel?.removeFromSuperview()
        self.titleLabel = nil
    }
    
    override func setupView() {
        self.clipsToBounds = false
        self.backgroundColor = UIColor.StandardTheme.Recipe.RecipeCellBackground
        
        totalTimeLabel = UILabel()
        totalTimeLabel?.attributedText = NSAttributedString(string: "00h00m00s", attributes: [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.RecipeCellTotalTime)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColour])
        totalTimeLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(totalTimeLabel!)
        totalTimeLabel?.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        totalTimeLabel?.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        pauseButton.addTarget(self, action: #selector(recipePauseHandler), for: .touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(pauseButton)
        pauseButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    //combine with pause button handler
    func updateTextWhenPaused() {
        if let r = recipe {
            
            var attributes: [NSAttributedString.Key : Any] = [:]
            var totalTimeAttributes: [NSAttributedString.Key : Any] = [:]
            if (r.isPaused) {
                attributes = [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.SizeCell)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColourDisabled]
                totalTimeAttributes = [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.RecipeCellTotalTime)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColourDisabled]
            } else {
                attributes = [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.SizeCell)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColour]
                totalTimeAttributes = [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.RecipeCellTotalTime)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColour]
            }

            if let name = recipe?.name {
                titleLabel?.attributedText = NSAttributedString(string: "\(name)", attributes: attributes)
            }
            totalTimeLabel?.attributedText = NSAttributedString(string: "00h00m00s", attributes: totalTimeAttributes)
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
        
        if let r = recipe {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else {
                    return
                }
                if (!r.isPaused) {
                    mvc.pauseEntireRecipe(recipe: r)
                    DispatchQueue.main.async {
                        mvc.stopTimer()
                        //update expirydate
                        self.pauseButton.setTitle("unpause", for: .normal)
                        r.isPaused = !r.isPaused
                    }
                } else {
                    mvc.unpauseEntireRecipe(recipe: r)
                    DispatchQueue.main.async {
                        mvc.startTimer()
                        self.pauseButton.setTitle("pause", for: .normal)
                        r.isPaused = !r.isPaused
                    }
                }
            }
        }
        mvc.willReloadTableData()
    }
    
    func updateTimeLabel() {
        var totalTimeAttributes: [NSAttributedString.Key : Any] = [:]
        totalTimeAttributes = [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.RecipeCellTotalTime)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColour]
        if let r = recipe {
            totalTimeLabel?.attributedText = NSAttributedString(string: r.timeRemainingWithText(), attributes: totalTimeAttributes)
        } else {
            totalTimeLabel?.attributedText = NSAttributedString(string: "unknown", attributes: totalTimeAttributes)
        }
    }
    

    //MARK: - no longer using the animating effect
    func animateNameLabel(state: Bool) {
        nameLabelAnimationYMovement = state ? 0 : ((titleLabel?.frame.size.height)! / 2) * -1
        if (!state) {
            UIView.animate(withDuration: 0.3) {
                self.titleLabel?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.titleLabel?.transform = CGAffineTransform.identity
                self.layoutIfNeeded()
            }
        }
    }
}
