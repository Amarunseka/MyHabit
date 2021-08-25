//
//  SecondViewController.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.toAutoLayout()
        return scroll
    }()
    
    
    private let containerView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        return view
    }()
    
    
    private let titleLabel: UILabel = {
        let text = UILabel()
        text.toAutoLayout()
        text.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        text.textColor = .black
        text.textAlignment = .left
        text.numberOfLines = 1
        text.text = "Привычка за 21 день"
        return text
    }()
    
    
    private let textLabel: UILabel = {
        let text = UILabel()
        text.toAutoLayout()
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = .black
        text.textAlignment = .left
        text.numberOfLines = 0
        text.text = RulesOfHabitsForText.rules
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Информация"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(
            titleLabel,
            textLabel)
        setupConstraint()
    }
    
    private func setupConstraint(){
        [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor),

            textLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
        ]
        .forEach{$0 .isActive = true}
    }

}
