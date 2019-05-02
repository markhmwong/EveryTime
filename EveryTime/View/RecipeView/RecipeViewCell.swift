//
//  StepTableViewCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewCell: EntityBaseTableViewCell<StepEntity> {
    override func setSelected(_ selected: Bool, animated: Bool) {
        guard let e = entity else {
            return
        }
        let color = e.isComplete ? Theme.View.StepCell.CellIndicatorComplete : Theme.View.StepCell.CellIndicatorIncomplete

        super.setSelected(selected, animated: animated)
        if selected {
            DispatchQueue.main.async {
                self.completeIndicatorView.backgroundColor = color
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard let e = entity else {
            return
        }
        let color = e.isComplete ? Theme.View.StepCell.CellIndicatorComplete : Theme.View.StepCell.CellIndicatorIncomplete
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            DispatchQueue.main.async {
                self.completeIndicatorView.backgroundColor = color
            }
        }
    }
    
    override var entity: StepEntity? {
        didSet {
            guard let e = entity else {
                return
            }
            prepareLabel(e)
            prepareAutoLayout()
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var completeIndicatorView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var gl = CAGradientLayer()
    
    private lazy var selectedBg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.6)
        return view
    }()
    
    override func setupView() {
        super.setupView()
        selectedBackgroundView = selectedBg
        backgroundColor = Theme.Background.Color.CellBackgroundColor
        
        if let s = entity {
            timeLabel.attributedText = NSAttributedString(string: "\(s.timeRemainingToString())", attributes: Theme.Font.Step.CellTimeAttribute)
            nameLabel.attributedText = NSAttributedString(string: s.stepName!, attributes: Theme.Font.Step.CellNameAttribute)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = bounds
    }
    
    func prepareLabel(_ s: StepEntity) {
        timeLabel.attributedText = NSAttributedString(string: "\(s.timeRemainingToString())", attributes: Theme.Font.Step.CellTimeAttribute)
        nameLabel.attributedText = NSAttributedString(string: s.stepName ?? "No Name", attributes: Theme.Font.Step.CellNameAttribute)
        updateCompletionStatusLabel()

        contentView.addSubview(completeIndicatorView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(nameLabel)
    }
    
    func prepareAutoLayout() {
        completeIndicatorView.anchorView(top: nil, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, centerY: contentView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -25.0), size: CGSize(width: 35.0, height: 18.0))
        
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.0).isActive = true
        timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 0.0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
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
            completeIndicatorView.backgroundColor = Theme.View.StepCell.CellIndicatorComplete
        } else {
            completeIndicatorView.backgroundColor = Theme.View.StepCell.CellIndicatorIncomplete
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
        completeIndicatorView.removeFromSuperview()
    }
}
