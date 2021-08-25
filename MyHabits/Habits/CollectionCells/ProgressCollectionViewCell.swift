//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit


class ProgressCollectionViewCell: UICollectionViewCell {
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "Все получится!"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    private let percentsProgressLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.toAutoLayout()
        view.tintColor = .gray
        view.progressTintColor = .systemCustomPurple
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }

    
    private func setupCell() {
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        
        contentView.addSubviews(
            titleLabel,
            percentsProgressLabel,
            progressView)
        
    }
    
    func setupProgress(progress value: Float) {
        progressView.setProgress(value, animated: true)
        percentsProgressLabel.text = "\(Int(round(Double(value) * pow(100.0, 2.0)) / pow(10.0, 2.0)))%"
    }

    
    private func setupConstraints() {
        let constraints = [
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
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



