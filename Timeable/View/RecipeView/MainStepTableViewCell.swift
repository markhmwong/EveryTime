//
//  StepTableViewCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class MainStepTableViewCell: EntityBaseTableViewCell<StepEntity> {
    
    override var entity: StepEntity? {
        didSet {
            guard let e = entity else {
                return
            }
            self.prepareLabel(e)
            self.prepareAutoLayout()
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
//    fileprivate var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
    fileprivate lazy var completeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var gl = CAGradientLayer()
    
    override func setupView() {
        super.setupView()
        backgroundColor = Theme.Background.Color.CellBackgroundColor
        let colorTop = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 0.3).cgColor
        
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.7, 1.0]
        gl.frame = bounds
        gl.shouldRasterize = true // rasterise so we don't need to redraw
        layer.insertSublayer(gl, at: 0)
        
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
