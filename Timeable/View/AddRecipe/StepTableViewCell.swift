//
//  StepTableViewCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class StepTableViewCell: UITableViewCell {
    fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.NameAttribute)
        return label
    }()
    fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.NameAttribute)
        return label
    }()
    var step: TableViewStep? {
        didSet {
            guard let s = step else {
                return
            }
            
//            guard let n = nameLabel, let t = timeLabel else {
//                return
//            }
            
            nameLabel.text = s.name
            timeLabel.text = "\(s.hours)h \(s.minutes)m \(s.seconds)s"
            
            contentView.addSubview(nameLabel)
            contentView.addSubview(timeLabel)

            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:55).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-55).isActive = true
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.removeFromSuperview()
        nameLabel.removeFromSuperview()
    }
}
