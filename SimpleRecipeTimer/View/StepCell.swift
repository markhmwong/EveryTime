//
//  StepCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class StepCell: EntityBaseCell<StepEntity> {
    override var entity: StepEntity? {
        didSet {
            if let name = entity?.stepName {
                self.prepareNameLabel(name)
            }
        }
    }
    var nameLabel: UILabel? = nil
    var timeLabel: UILabel = UILabel()
    var priorityLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    var isComplete: Bool = false
    var stackView: UIStackView?
    var completeLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = Theme.Background.Color.CellBackgroundColor
        if let s = entity {
            timeLabel.attributedText = NSAttributedString(string: "\(s.timeRemaining())", attributes: Theme.Font.Step.CellTimeAttribute)
            nameLabel?.attributedText = NSAttributedString(string: s.stepName!, attributes: Theme.Font.Step.CellNameAttribute)
        }
    }
    
    func prepareNameLabel(_ name: String) {
        
        stackView = UIStackView()
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.axis = .horizontal
        stackView?.alignment = .center
        stackView?.spacing = 10
        stackView?.distribution = .fillEqually
        
        timeLabel.textAlignment = .center
        nameLabel = UILabel()
        nameLabel?.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Step.CellNameAttribute)
        nameLabel?.textAlignment = .left
        
        priorityLabel.attributedText = NSAttributedString(string: "\(entity!.priority)", attributes: Theme.Font.Step.CellNameAttribute)
        
        completeLabel.attributedText = NSAttributedString(string: "done", attributes: Theme.Font.Step.CellIndicatorIncomplete)
        completeLabel.textAlignment = .right
        
        stackView?.addArrangedSubview(priorityLabel)
        stackView?.addArrangedSubview(nameLabel!)
        stackView?.addArrangedSubview(timeLabel)
        stackView?.addArrangedSubview(completeLabel)
        self.addSubview(stackView!)
        stackView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stackView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        stackView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func updateNameLabel(name: String) {
        nameLabel?.attributedText = NSAttributedString(string: name, attributes: Theme.Font.Step.CellNameAttribute)
    }
    
    func updateTimeLabel(time: String) {
        timeLabel.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Step.CellTimeAttribute)
//
//        guard let e = entity else {
//            return
//        }
//        if (e.isComplete) {
//            completeLabel.attributedText = NSAttributedString(string: "done", attributes: Theme.Font.Step.CellIndicatorComplete)
//        } else {
//            completeLabel.attributedText = NSAttributedString(string: "done", attributes: Theme.Font.Step.CellIndicatorIncomplete)
//        }
    }
}
