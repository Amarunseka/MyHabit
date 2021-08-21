//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Миша on 11.08.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    let cellID = "CellID"
    var habit: Habit
        
    let activityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "АКТИВНОСТЬ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
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
        NotificationCenter.default.addObserver(self, selector: #selector(changeTitle), name: NSNotification.Name(rawValue: "changeTitle"), object: nil)
    }
    
    @objc func changeTitle() {
        navigationItem.title = habit.name
    }
    
    func setupView(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit))
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        view.addSubview(activityLabel)
    }
    
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
    }
    
    
    func setupConstraints(){
        [
            activityLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            activityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            activityLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 7),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ] .forEach{$0 .isActive = true}
    }

    
    @objc func editHabit(){
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

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        cell.contentConfiguration = cellContent
        cell.tintColor = UIColor(red: 0.631, green: 0.0863, blue: 0.8, alpha: 1)
        
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

