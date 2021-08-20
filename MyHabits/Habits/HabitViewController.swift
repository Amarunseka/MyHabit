//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit

protocol ModalViewControllerDelegate: AnyObject {
    func backToHabitsVC()
}

class HabitViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    weak var backToHabitsVCDelegate: ModalViewControllerDelegate?

    var habitId: Int?
    lazy var trackDates: [Date] = []
        
    var habit: Habit? {
        didSet {
            nameHabitTextField.text = habit?.name
            nameHabitTextField.textColor = habit?.color
            colorOfHabitView.backgroundColor = habit?.color
            trackDates = habit?.trackDates ?? []
            
            tempDateOfHabit = habit?.date
            tempDateString = habit?.dateString
            editDate()
        }
    }
    
    
    let store = HabitsStore.shared
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_Ru")
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()

    
    let titleForNameOfHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    let nameHabitTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        text.font = UIFont(name: "SFProText-Semibold", size: 13)
        text.textColor = .black
        text.textAlignment = .left
        return text
    }()
    
    
    let titleForColorOfHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    let colorOfHabitView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 30, height: 30)
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let titleForTimeOfHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    let timeOfHabitTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: "SFProText-Semibold", size: 13)
        text.textColor = .black
        text.textAlignment = .left
        text.text = "Каждый день в"
        
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    let setTimeOfHabitPickerView: UIDatePicker = {
        let time = UIDatePicker()
        time.preferredDatePickerStyle = .wheels
        time.datePickerMode = .time
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    
    let buttonDeleteHabit: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 0.23, blue: 0.188, alpha: 1), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupColorHabit()
        setupTimeOfHabitTextField()
        setupDeleteButton()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {


    }

    func setupNavigationBar(){
        habitId == nil ? (title = "Создать") : (title = "Править")

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить",
            style: .plain, target: self, action: #selector(closeWindow))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
            style: .plain, target: self, action: #selector(saveHabit))
    }
    
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleForNameOfHabitLabel)
        view.addSubview(nameHabitTextField)
        view.addSubview(titleForColorOfHabitLabel)
        view.addSubview(colorOfHabitView)
        view.addSubview(titleForTimeOfHabitLabel)
        view.addSubview(timeOfHabitTextField)
        view.addSubview(setTimeOfHabitPickerView)
    }
 
    
    func setupConstraints(){
        [
            titleForNameOfHabitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleForNameOfHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleForNameOfHabitLabel.widthAnchor.constraint(equalToConstant: 75),
            
            nameHabitTextField.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            nameHabitTextField.topAnchor.constraint(equalTo: titleForNameOfHabitLabel.bottomAnchor, constant: 7),
            nameHabitTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            
            titleForColorOfHabitLabel.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            titleForColorOfHabitLabel.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 15),
            titleForColorOfHabitLabel.widthAnchor.constraint(equalToConstant: 40),
            
            colorOfHabitView.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            colorOfHabitView.topAnchor.constraint(equalTo: titleForColorOfHabitLabel.bottomAnchor, constant: 7),
            colorOfHabitView.widthAnchor.constraint(equalToConstant: 30),
            colorOfHabitView.heightAnchor.constraint(equalTo: colorOfHabitView.widthAnchor),
            
            titleForTimeOfHabitLabel.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            titleForTimeOfHabitLabel.topAnchor.constraint(equalTo: colorOfHabitView.bottomAnchor, constant: 15),
            titleForTimeOfHabitLabel.widthAnchor.constraint(equalToConstant: 50),
            
            timeOfHabitTextField.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            timeOfHabitTextField.topAnchor.constraint(equalTo: titleForTimeOfHabitLabel.bottomAnchor, constant: 7),
            timeOfHabitTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            
            setTimeOfHabitPickerView.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            setTimeOfHabitPickerView.topAnchor.constraint(equalTo: timeOfHabitTextField.bottomAnchor),
            
        ] .forEach{$0 .isActive = true}
        
        if habitId != nil {
            view.addSubview(buttonDeleteHabit)
            [
                buttonDeleteHabit.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                buttonDeleteHabit.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
                buttonDeleteHabit.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)] .forEach{$0 .isActive = true}
        }
    }
    
    
    
   // MARK: - ColorView setup
    
    func setupColorHabit() {
        colorOfHabitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choseColor)))
    }
    
    @objc func choseColor(sender: UITapGestureRecognizer) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.selectedColor = colorOfHabitView.backgroundColor ?? .black
        present(colorPickerVC, animated: true)
    }

    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorOfHabitView.backgroundColor = color
        colorOfHabitView.layer.borderWidth = 0
        nameHabitTextField.textColor = color
        
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorOfHabitView.backgroundColor = color
        colorOfHabitView.layer.borderWidth = 0
        nameHabitTextField.textColor = color
    }
    

    
    
    // MARK: - TimeTextField setup

    var tempDateOfHabit: Date?
    var tempDateString: String?
    
    func setupTimeOfHabitTextField(){
        timeOfHabitTextField.inputView = setTimeOfHabitPickerView
        setTimeOfHabitPickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        tempDateOfHabit = sender.date
        
        let textFullTimeTextField = NSMutableAttributedString(string: "Каждый день в " + dateFormatter.string(from: tempDateOfHabit!))
        let time = (textFullTimeTextField.string as NSString).range(of: dateFormatter.string(from: tempDateOfHabit!))
        
        textFullTimeTextField.setAttributes([
            .foregroundColor: UIColor(red: 0.631, green: 0.0863, blue: 0.8, alpha: 1),
        ], range: time)
        
        timeOfHabitTextField.attributedText = textFullTimeTextField
    }
   
    
    func editDate(){
        guard let tempString = tempDateString else {return}
        let textFullTimeTextField = NSMutableAttributedString(string: tempString)
        let time = (textFullTimeTextField.string as NSString).range(of: dateFormatter.string(from: tempDateOfHabit!))
        
        textFullTimeTextField.setAttributes([
            .foregroundColor: UIColor(red: 0.631, green: 0.0863, blue: 0.8, alpha: 1),
        ], range: time)
        
        timeOfHabitTextField.attributedText = textFullTimeTextField
    }
    
    
    
    
    // MARK: - CreateOrEditNewHabit setup

    @objc func saveHabit(){
        guard !nameHabitTextField.text!.isEmpty else {return}
        guard tempDateOfHabit != nil else {return}
        guard colorOfHabitView.backgroundColor != nil else {return}
        
        
        let newHabit = Habit(
            name: nameHabitTextField.text!,
            date: tempDateOfHabit!,
            color: colorOfHabitView.backgroundColor!
        )
        newHabit.trackDates = trackDates
        
        if let habitId = habitId {
                        
            store.habits[habitId] = newHabit
            
        } else {
            store.habits.append(newHabit)
        }

        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - DeleteHabit setup
    
    func setupDeleteButton() {
        buttonDeleteHabit.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)

    }
    
    @objc func deleteHabit(_ sender: UIButton) {
        guard let habitId = self.habitId else {return}
        let alert = UIAlertController(
            title: "Удалить привычку",
            message: "Вы хотите удалить привычку \n\(store.habits[habitId].name)?",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        let deleteHabit = UIAlertAction(title: "Удалить", style: .default)
        {_ in
            
            self.store.habits.remove(at: habitId)
            self.habitId = nil
            self.backToHabitsVCDelegate?.backToHabitsVC()
        }
        
        alert.addAction(cancel)
        alert.addAction(deleteHabit)
        
        if let popover = alert.popoverPresentationController{
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
            self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Close window
    @objc func closeWindow(){
        dismiss(animated: true, completion: nil)
    }
}

