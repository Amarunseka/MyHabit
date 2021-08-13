//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    let todayProgress = HabitsStore.shared.todayProgress
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получиться!"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    let percentsProgressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .gray
        view.progressTintColor = UIColor(red: 0.631, green: 0.0863, blue: 0.8, alpha: 1)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    
    func setupCell() {
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(percentsProgressLabel)
        contentView.addSubview(progressView)
        progressView.setProgress(todayProgress, animated: true)
        percentsProgressLabel.text = "\(Int(round(Double(todayProgress) * pow(100.0, 2.0)) / pow(10.0, 2.0)))%"
    }
    
    
    func setupConstraints() {
        [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            percentsProgressLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            percentsProgressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            percentsProgressLabel.widthAnchor.constraint(equalToConstant: 50),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            progressView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -24)
            
        ].forEach{$0 .isActive = true}
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


