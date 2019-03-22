//
//  StepTableViewCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewCell: EntityBaseTableViewCell<StepEntity> {
    
    override var entity: StepEntity? {
        didSet {
            guard let e = entity else {
                return
            }
            prepareLabel(e)
            prepareAutoLayout()
        }
    }
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    fileprivate lazy var completeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var gl = CAGradientLayer()
    
    fileprivate lazy var selectedBg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.6)
        return view
    }()
    
    override func setupView() {
        super.setupView()
        selectedBackgroundView = selectedBg
        backgroundColor = Theme.Background.Color.CellBackgroundColor
        
        if let s = entity {
            timeLabel.attributedText = NSAttributedString(string: "\(s.timeRemainingToString())", attributes: Theme.Font.Step.CellTimeAttribute)
            nameLabel.attributedText = NSAttributedString(string: s.stepName!, attributes: Theme.Font.Step.CellNameAttribute)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = bounds
    }
    
    func prepareLabel(_ e: StepEntity) {
        timeLabel.attributedText = NSAttributedString(string: "\(e.timeRemainingToString())", attributes: Theme.Font.Step.CellTimeAttribute)
        nameLabel.attributedText = NSAttributedString(string: e.stepName ?? "No Name", attributes: Theme.Font.Step.CellNameAttribute)
        updateCompletionStatusLabel()
        completeLabel.textAlignment = .right

        contentView.addSubview(completeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(nameLabel)
    }
    
    func prepareAutoLayout() {
        
        completeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        completeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13).isActive = true
        nameLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    func updateNameLabel(name: String) {
        nameLabel.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Step.CellNameAttribute)
    }
    
    func updateTimeLabel(time: String) {
        timeLabel.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Step.CellTimeAttribute)
    }
    
    func updateCompletionStatusLabel() {
        guard let e = entity else {
            return
        }
        if (e.isComplete) {
            completeLabel.attributedText = NSAttributedString(string: "•", attributes: Theme.Font.Step.CellIndicatorComplete)
        } else {
            completeLabel.attributedText = NSAttributedString(string: "•", attributes: Theme.Font.Step.CellIndicatorIncomplete)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
        completeLabel.removeFromSuperview()
    }
}
