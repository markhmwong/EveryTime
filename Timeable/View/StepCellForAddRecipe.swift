//
//  StepCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class StepCellForAddRecipe: EntityBaseCell<StepEntity> {
    override var entity: StepEntity? {
        didSet {
            guard let e = entity else {
                return
            }
            self.prepareLabel(e)
        }
    }
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var completeLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = Theme.Background.Color.CellBackgroundColor
        if let s = entity {
            timeLabel.attributedText = NSAttributedString(string: "\(s.timeRemainingToString())", attributes: Theme.Font.Step.CellTimeAttribute)
            nameLabel.attributedText = NSAttributedString(string: s.stepName!, attributes: Theme.Font.Step.CellNameAttribute)
        }
    }
    
    func prepareLabel(_ e: StepEntity) {
        timeLabel.attributedText = NSAttributedString(string: "\(e.timeRemainingToString())", attributes: Theme.Font.Step.CellTimeAttribute)
        nameLabel.attributedText = NSAttributedString(string: e.stepName!, attributes: Theme.Font.Step.CellNameAttribute)
        updateCompletionStatusLabel()
        completeLabel.textAlignment = .right
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(completeLabel)
        self.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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
            completeLabel.attributedText = NSAttributedString(string: "done", attributes: Theme.Font.Step.CellIndicatorComplete)
        } else {
            completeLabel.attributedText = NSAttributedString(string: "done", attributes: Theme.Font.Step.CellIndicatorIncomplete)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.removeFromSuperview()
        self.timeLabel.removeFromSuperview()
        self.completeLabel.removeFromSuperview()
    }
}
