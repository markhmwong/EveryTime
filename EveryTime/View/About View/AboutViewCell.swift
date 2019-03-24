//
//  AboutViewCell.swift
//  EveryTime
//
//  Created by Mark Wong on 24/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewCell: UITableViewCell {
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        label.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel(text: String) {
        print(text)
        label.attributedText = NSAttributedString(string: text, attributes: Theme.Font.About.Text)
    }
    
}