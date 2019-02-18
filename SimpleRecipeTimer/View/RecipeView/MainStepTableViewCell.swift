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
        label.translatesAutoresizingMaskIntoConstraints = false
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
        nameLabel.attributedText = NSAttributedString(string: e.stepName!, attributes: Theme.Font.Step.CellNameAttribute)
//       priorityLabel.attributedText = NSAttributedString(string: "\(entity!.priority)", attributes: Theme.Font.Step.CellNameAttribute)
        updateCompletionStatusLabel()
        completeLabel.textAlignment = .right
        
        //        stackView?.addArrangedSubview(priorityLabel)
        addSubview(timeLabel)

        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        stackView.addArrangedSubview(nameLabel)
//        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(completeLabel)
        self.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60).isActive = true
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
        //        self.nameLabel = nil
        self.timeLabel.removeFromSuperview()
        //        self.timeLabel = nil
        self.completeLabel.removeFromSuperview()
        //        self.completeLabel = nil
    }
}
