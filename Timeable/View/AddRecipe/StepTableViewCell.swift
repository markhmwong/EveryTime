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
        label.text = ""
        return label
    }()
    fileprivate var timeLabel: UILabel? = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    var step: TableViewStep? {
        didSet {
            guard let s = step else {
                return
            }
            
            guard let n = nameLabel else {
                return
            }
            n.text = s.name
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
        guard let n = nameLabel else {
            return
        }
        
        n.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(n)
        n.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        n.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        //todo
        nameLabel = nil
        
        guard let n = nameLabel else {
            return
        }
        n.removeFromSuperview()
    }
}
