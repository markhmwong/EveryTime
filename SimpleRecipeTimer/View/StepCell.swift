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

    
    override func setupView() {
        super.setupView()
        self.backgroundColor = UIColor.blue
        if let s = entity {
            timeLabel.text = s.timeRemaining()
            nameLabel?.text = s.stepName
        }
    }
    
    override func prepareNameLabel(_ name: String) {
        timeLabel.backgroundColor = UIColor.white
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        let attributes: [NSAttributedString.Key :Any ] = [NSAttributedString.Key.font: UIFont(name: UIFont.StandardTheme.Font.Style.Black, size: UIFont.StandardTheme.Font.Size.SizeCell)!, NSAttributedString.Key.foregroundColor: UIColor.StandardTheme.Font.TextColour]

        nameLabel = UILabel()
        nameLabel?.attributedText = NSAttributedString(string: "\(name)", attributes: attributes)
        nameLabel?.backgroundColor = UIColor.white
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel!)
        nameLabel?.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        nameLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameLabel?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func updateNameLabel(name: String) {
        nameLabel?.text = name
    }
    
    func updateTimeLabel(time: String) {
        timeLabel.text = time
    }
}
