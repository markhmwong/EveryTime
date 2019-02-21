//
//  StepTableViewCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class StepTableViewCell: UITableViewCell {
    fileprivate var nameLabel: UILabel? = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.NameAttribute)
        return label
    }()
    fileprivate var timeLabel: UILabel? = {
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
            
            guard let n = nameLabel, let t = timeLabel else {
                return
            }
            n.text = s.name
            t.text = "\(s.hours)h \(s.minutes)m \(s.seconds)"
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
        guard let n = nameLabel, let t = timeLabel else {
            return
        }
        
        contentView.addSubview(n)
        n.leadingAnchor.constraint(equalTo: leadingAnchor, constant:55).isActive = true
        n.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        contentView.addSubview(t)
        t.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-55).isActive = true
        t.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        //todo
        nameLabel = nil
        timeLabel = nil
        guard let n = nameLabel, let t = timeLabel else {
            return
        }
        t.removeFromSuperview()
        n.removeFromSuperview()
    }
}
