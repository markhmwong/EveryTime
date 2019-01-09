//
//  StepCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class StepCell: BaseCell {

    var nameLabel: UILabel = UILabel()
    var timeLabel: UILabel = UILabel()
    var step: Step? {
        didSet {
            self.prepareLabels()
        }
    }
    
    override func setupView() {
        self.backgroundColor = UIColor.blue
        
        if let s = step {
            timeLabel.text = s.timeRemaining()
            nameLabel.text = s.name
        }
    }
    
    func prepareLabels() {
        timeLabel.backgroundColor = UIColor.white
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        nameLabel.backgroundColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func updateNameLabel(name: String) {
        nameLabel.text = name
    }
    
    func updateTimeLabel(time: String) {
        timeLabel.text = time
    }
}
