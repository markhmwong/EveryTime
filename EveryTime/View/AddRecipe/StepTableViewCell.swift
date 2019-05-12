//
//  StepTableViewCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct TableViewStep {
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var name: String = ""
    var date: Date = Date()
    var priority: Int16 = 0
}

class StepTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.NameAttribute)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.NameAttribute)
        return label
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Copy", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCopy), for: .touchUpInside)
        return button
    }()
    
    var step: StepEntity? {
        didSet {
            guard let s = step else {
                return
            }
            nameLabel.text = s.stepName
            timeLabel.text = s.timeRemainingToString()
            
            contentView.addSubview(nameLabel)
            contentView.addSubview(timeLabel)
            contentView.addSubview(copyButton)
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10.0).isActive = true
            nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10.0).isActive = true
            timeLabel.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            copyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-10.0).isActive = true
            copyButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    weak var delegate: AddRecipeViewController?
    
    var theme: ThemeManager?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let view = UIView()
        view.backgroundColor = .black
        self.selectedBackgroundView = view
    }
    
    func setupLayout() {

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.removeFromSuperview()
        nameLabel.removeFromSuperview()
        copyButton.removeFromSuperview()
    }
    
    @objc func handleCopy() {
        guard let step = step else {
            return
        }
        delegate?.copyWith(step: step)
    }
}
