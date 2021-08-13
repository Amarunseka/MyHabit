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
        
    var habit: Habit? {
        didSet {
            titleOfHabitLabel.text = habit?.name
            timeToDoItLabel.text = String((habit?.dateString[...(habit?.dateString.lastIndex(of: " "))!]) ?? "")
            counterOfExecutionsLabel.text = "Счётчик: \(habit?.trackDates.count ?? 0)"
            
            titleOfHabitLabel.textColor = habit?.color ?? UIColor()
            markOfCompletion.layer.borderColor = habit?.color.cgColor ?? UIColor() as! CGColor
            if habit?.isAlreadyTakenToday == true {
                markOfCompletion.backgroundColor = habit?.color
                checkmark.alpha = 1}
        }
    }
    
    weak var delegate: HabitCollectionCellDelegate?
    
    let titleOfHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        label.sizeToFit()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    
    let timeToDoItLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.textColor = .systemGray2
        label.sizeToFit()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    let counterOfExecutionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.textColor = .systemGray
        label.sizeToFit()
        label.text = "Счетчик: 0"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    let markOfCompletion: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 38, height: 38)
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var checkmark: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "checkmark")
        image.tintColor = .white
        image.alpha = 0
        return image
    }()
    
    
    let changeColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    
    func setupCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleOfHabitLabel)
        contentView.addSubview(timeToDoItLabel)
        contentView.addSubview(counterOfExecutionsLabel)
        contentView.addSubview(markOfCompletion)
        markOfCompletion.addSubview(checkmark)
        markOfCompletion.addSubview(changeColorButton)
        changeColorButton.addTarget(self, action: #selector(tapHabitButton), for: .touchUpInside)
    }
    
    
    func setupConstraints() {
        [
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
            
        ].forEach{$0 .isActive = true}
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func tapHabitButton() {
        guard let habit = habit else { return }
        
        if habit.isAlreadyTakenToday == false {
            HabitsStore.shared.track(habit)
            markOfCompletion.backgroundColor = self.habit?.color
            checkmark.alpha = 1
            counterOfExecutionsLabel.text = "Счётчик: \(habit.trackDates.count)"
            delegate?.reloadData()
        }
    }
}

