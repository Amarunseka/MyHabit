//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Миша on 11.08.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    private var habit: Habit
        
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "АКТИВНОСТЬ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.toAutoLayout()
        table.backgroundColor = .white
        return table
    }()
    
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        navigationItem.title = habit.name
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeTitle),
            name: NSNotification.Name(rawValue: "changeTitle"),
            object: nil)
    }
    
    @objc private func changeTitle() {
        navigationItem.title = habit.name
    }
    
    private func setupView(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit))
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        view.addSubview(activityLabel)
    }
    
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.backgroundColor = .systemCustomLightGray
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.dataSource = self
    }
    
    
    private func setupConstraints(){
        let constraints = [
            activityLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            activityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            activityLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 7),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ]
        NSLayoutConstraint.activate(constraints)

    }

    
    @objc private func editHabit(){
        let editHabitController = HabitViewController()
        editHabitController.habit = habit
        editHabitController.backToHabitsVCDelegate = self

        let habitViewController = UINavigationController(rootViewController: editHabitController)
        habitViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        habitViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(habitViewController, animated: true)
    }
}



// MARK: - extension UITableViewDataSource

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  HabitsStore.shared.dates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        cell.contentConfiguration = cellContent
        cell.tintColor = .systemCustomPurple
        
        if HabitsStore.shared.habit(
            habit, isTrackedIn: HabitsStore.shared.dates[indexPath.row]) == true {
            
            cell.accessoryType = .checkmark
        }
        return cell
    }
}


extension HabitDetailsViewController: ModalViewControllerDelegate {
    func backToHabitsVC() {
        navigationController?.dismiss(animated: false)
        navigationController?.popToRootViewController(animated: true)
    }
}

