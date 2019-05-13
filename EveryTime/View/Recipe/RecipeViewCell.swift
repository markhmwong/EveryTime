//
//  StepTableViewCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewCell: EntityBaseTableViewCell<StepEntity> {
    
    var theme: ThemeManager?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        guard let e = entity else {
            return
        }
        let color = e.isComplete ? Theme.View.StepCell.CellIndicatorComplete : Theme.View.StepCell.CellIndicatorIncomplete

        super.setSelected(selected, animated: animated)
//        if selected {
//            DispatchQueue.main.async {
////                self.completeIndicatorView.backgroundColor = color
//            }
//        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard let e = entity else {
            return
        }
        let color = e.isComplete ? Theme.View.StepCell.CellIndicatorComplete : Theme.View.StepCell.CellIndicatorIncomplete
        super.setHighlighted(highlighted, animated: animated)
        
//        if highlighted {
//            DispatchQueue.main.async {
////                self.completeIndicatorView.backgroundColor = color
//            }
//        }
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

//    private lazy var completeIndicatorView: UIView = {
//       let view = UIView()
//        view.layer.cornerRadius = 8.0
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    var gl = CAGradientLayer()
    
    private lazy var selectedBg: UIView = {
        let view = UIView()
        return view
    }()
    
    override func setupView() {
        super.setupView()
        selectedBackgroundView = selectedBg
        
        if let s = entity {
            timeLabel.attributedText = NSAttributedString(string: "\(s.timeRemainingToString())", attributes: theme?.currentTheme.tableView.recipeCellRecipeTime)
            nameLabel.attributedText = NSAttributedString(string: s.stepName!, attributes: theme?.currentTheme.tableView.recipeCellStepName)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = bounds
    }
    
    func prepareLabel(_ stepEntity: StepEntity) {
        timeLabel.attributedText = NSAttributedString(string: "\(stepEntity.timeRemainingToString())", attributes: theme?.currentTheme.tableView.recipeCellRecipeTime)
        nameLabel.attributedText = NSAttributedString(string: stepEntity.stepName ?? "No Name", attributes: theme?.currentTheme.tableView.recipeCellStepName)
        updateCompletionStatusLabel()

//        contentView.addSubview(completeIndicatorView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(nameLabel)
    }
    
    func prepareAutoLayout() {
//        completeIndicatorView.anchorView(top: nil, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, centerY: contentView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -25.0), size: CGSize(width: 35.0, height: 18.0))
        
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0).isActive = true
    }
    
    func updateNameLabel(name: String) {
        nameLabel.attributedText = NSAttributedString(string: name, attributes: theme?.currentTheme.tableView.recipeCellStepName)
    }
    
    func updateTimeLabel(time: String) {
        timeLabel.attributedText = NSAttributedString(string: time, attributes: theme?.currentTheme.tableView.recipeCellRecipeTime)
    }
    
    func updateCompletionStatusLabel() {
        guard let e = entity else {
            return
        }
        if (e.isComplete) {
            DispatchQueue.main.async {
                self.nameLabel.alpha = 0.5
                self.timeLabel.alpha = 0.5
            }

//            completeIndicatorView.backgroundColor = Theme.View.StepCell.CellIndicatorComplete
        } else {
//            completeIndicatorView.backgroundColor = Theme.View.StepCell.CellIndicatorIncomplete
            DispatchQueue.main.async {
                self.nameLabel.alpha = 1.0
                self.timeLabel.alpha = 1.0
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
//        completeIndicatorView.removeFromSuperview()
    }
}
