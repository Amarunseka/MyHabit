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
        
    var habit: Habit? {
        didSet {
            editHabit()
        }
    }
    
    let scrollView = UIScrollView()
    
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        text.sizeToFit()
        text.returnKeyType = UIReturnKeyType.done
        text.textColor = .black
        text.textAlignment = .left
        return text
    }()
    
    
    let titleForColorOfHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
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
        label.sizeToFit()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    let timeOfHabitTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: "SFProText-Semibold", size: 13)
        text.sizeToFit()
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
        button.sizeToFit()
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
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    

    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить",
            style: .plain, target: self, action: #selector(closeWindow))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
            style: .plain, target: self, action: #selector(saveHabit))
    }
    
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleForNameOfHabitLabel)
        containerView.addSubview(nameHabitTextField)
        containerView.addSubview(titleForColorOfHabitLabel)
        containerView.addSubview(colorOfHabitView)
        containerView.addSubview(titleForTimeOfHabitLabel)
        containerView.addSubview(timeOfHabitTextField)
        containerView.addSubview(setTimeOfHabitPickerView)
        containerView.addSubview(buttonDeleteHabit)

    }
    
    
    func editHabit() {
        if let habit = habit {
            nameHabitTextField.text = habit.name
            nameHabitTextField.textColor = habit.color
            colorOfHabitView.backgroundColor = habit.color
            colorOfHabitView.layer.borderWidth = 0
            tempDateOfHabit = habit.date
            tempDateString = habit.dateString
            navigationItem.title = "Править"
            buttonDeleteHabit.isHidden = false
            editDate()
        } else {
            nameHabitTextField.text = ""
            colorOfHabitView.backgroundColor = .white
            tempDateOfHabit = Date()
            navigationItem.title = "Создать"
            buttonDeleteHabit.isHidden = true
        }
    }
 
    
    func setupConstraints(){
        let allHeigh = view.frame.size.height - (
            titleForNameOfHabitLabel.frame.size.height
            + nameHabitTextField.frame.size.height
            + titleForColorOfHabitLabel.frame.size.height
            + colorOfHabitView.frame.size.height
            + titleForTimeOfHabitLabel.frame.size.height
            + timeOfHabitTextField.frame.size.height
            + setTimeOfHabitPickerView.frame.size.height
            + buttonDeleteHabit.frame.size.height
            + 0)
        print(allHeigh)

        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            titleForNameOfHabitLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleForNameOfHabitLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleForNameOfHabitLabel.widthAnchor.constraint(equalToConstant: 75),
            
            nameHabitTextField.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            nameHabitTextField.topAnchor.constraint(equalTo: titleForNameOfHabitLabel.bottomAnchor, constant: 7),
            nameHabitTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32),
            
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
            timeOfHabitTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32),
            
            setTimeOfHabitPickerView.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            setTimeOfHabitPickerView.topAnchor.constraint(equalTo: timeOfHabitTextField.bottomAnchor),
            
            buttonDeleteHabit.topAnchor.constraint(equalTo: timeOfHabitTextField.bottomAnchor, constant: allHeigh),
            buttonDeleteHabit.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonDeleteHabit.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18),
            buttonDeleteHabit.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32)
            
        ] .forEach{$0 .isActive = true}
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
        
        if let habit = habit {
            habit.name = nameHabitTextField.text ?? ""
            habit.date = tempDateOfHabit ?? Date()
            habit.color = colorOfHabitView.backgroundColor ?? .white
            HabitsStore.shared.save()
        } else {
            let newHabit = Habit(name: nameHabitTextField.text ?? "",
                                 date: tempDateOfHabit ?? Date(),
                                 color: colorOfHabitView.backgroundColor ?? .white)
            
            let store = HabitsStore.shared
            store.habits.append(newHabit)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTitle"), object: nil)

        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - DeleteHabit setup
    
    func setupDeleteButton() {
        buttonDeleteHabit.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)

    }
    
    @objc func deleteHabit(_ sender: UIButton) {
        guard let habit = habit else {return}
        let alert = UIAlertController(
            title: "Удалить привычку",
            message: "Вы хотите удалить привычку \n\(habit.name)?",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        let deleteHabit = UIAlertAction(title: "Удалить", style: .default)
        {_ in
            HabitsStore.shared.habits.removeAll{$0 == self.habit}
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


