//
//  CollectionViewCell.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit

protocol HabitCollectionCellDelegate: AnyObject {
    func reloadData()
}

class HabitCollectionViewCell: UICollectionViewCell {
        
    private var habit: Habit?
    
    weak var delegate: HabitCollectionCellDelegate?
    
    
    private let titleOfHabitLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        label.sizeToFit()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    
    private let timeToDoItLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.textColor = .systemGray2
        label.sizeToFit()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    private let counterOfExecutionsLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.textColor = .systemGray
        label.sizeToFit()
        label.text = "Счетчик: 0"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    private let markOfCompletion: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 38, height: 38)
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.toAutoLayout()
        return view
    }()
    
    
    private lazy var checkmark: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.image = UIImage(systemName: "checkmark")
        image.tintColor = .white
        image.alpha = 0
        return image
    }()
    
    
    private let changeColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.backgroundColor = .clear
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    
    func configure(with habit: Habit) {
        titleOfHabitLabel.text = habit.name
        timeToDoItLabel.text = habit.dateString
        counterOfExecutionsLabel.text = "Счётчик: \(habit.trackDates.count)"
        titleOfHabitLabel.textColor = habit.color
        markOfCompletion.layer.borderColor = habit.color.cgColor
        
        if habit.isAlreadyTakenToday == true {
            markOfCompletion.backgroundColor = habit.color
            checkmark.alpha = 1
        } else {
            markOfCompletion.backgroundColor = .white
        }
        self.habit = habit
    }
    
    
    private func setupCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubviews(
            titleOfHabitLabel,
            timeToDoItLabel,
            counterOfExecutionsLabel,
            markOfCompletion)
        
        markOfCompletion.addSubviews(
            checkmark,
            changeColorButton)
        
        changeColorButton.addTarget(self, action: #selector(tapHabitButton), for: .touchUpInside)
    }
    
    
    private func setupConstraints() {
        let constraints = [
            titleOfHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleOfHabitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleOfHabitLabel.widthAnchor.constraint(equalToConstant: 220),
            
            timeToDoItLabel.leadingAnchor.constraint(equalTo: titleOfHabitLabel.leadingAnchor),
            timeToDoItLabel.topAnchor.constraint(equalTo: titleOfHabitLabel.bottomAnchor, constant: 4),
            timeToDoItLabel.widthAnchor.constraint(equalToConstant: 150),
            
            counterOfExecutionsLabel.leadingAnchor.constraint(equalTo: titleOfHabitLabel.leadingAnchor),
            counterOfExecutionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            counterOfExecutionsLabel.widthAnchor.constraint(equalToConstant: 100),
            
            markOfCompletion.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            markOfCompletion.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            markOfCompletion.widthAnchor.constraint(equalToConstant: 36),
            markOfCompletion.heightAnchor.constraint(equalTo: markOfCompletion.widthAnchor),
            
            checkmark.centerXAnchor.constraint(equalTo: markOfCompletion.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: markOfCompletion.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor),
            
            changeColorButton.centerXAnchor.constraint(equalTo: markOfCompletion.centerXAnchor),
            changeColorButton.centerYAnchor.constraint(equalTo: markOfCompletion.centerYAnchor),
            changeColorButton.widthAnchor.constraint(equalTo: markOfCompletion.widthAnchor),
            changeColorButton.heightAnchor.constraint(equalTo: markOfCompletion.heightAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapHabitButton() {
        guard let habit = habit else { return }
        
        if habit.isAlreadyTakenToday == false {
            HabitsStore.shared.track(habit)
            delegate?.reloadData()
        }
    }
}


