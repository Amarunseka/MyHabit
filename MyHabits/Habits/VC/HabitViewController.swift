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
    
    private let scrollView = UIScrollView()
    
    
    private let containerView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        return view
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_Ru")
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()

    
    private let titleForNameOfHabitLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "НАЗВАНИЕ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    private let nameHabitTextField: UITextField = {
        let text = UITextField()
        text.toAutoLayout()
        text.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        text.font = UIFont(name: "SFProText-Semibold", size: 13)
        text.sizeToFit()
        text.returnKeyType = UIReturnKeyType.done
        text.textColor = .black
        text.textAlignment = .left
        return text
    }()
    
    
    private let titleForColorOfHabitLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "ЦВЕТ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    private let colorOfHabitView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 30, height: 30)
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.isUserInteractionEnabled = true
        view.toAutoLayout()
        return view
    }()
    
    
    private let titleForTimeOfHabitLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "ВРЕМЯ"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        label.sizeToFit()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    private let timeOfHabitLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "SFProText-Semibold", size: 13)
        text.sizeToFit()
        text.textColor = .black
        text.textAlignment = .left
        text.text = "Каждый день в "
        text.toAutoLayout()
        return text
    }()
    
    
    private let setTimeOfHabitPickerView: UIDatePicker = {
        let time = UIDatePicker()
        time.preferredDatePickerStyle = .wheels
        time.datePickerMode = .time
        time.addTarget(self, action: #selector (chooseTime), for: .valueChanged)
        time.toAutoLayout()
        return time
    }()
    
    
    private let buttonDeleteHabit: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.sizeToFit()
        button.backgroundColor = .clear
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupColorHabit()
        setupDeleteButton()
        setupConstraints()
    }
    

    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить",
            style: .plain, target: self, action: #selector(closeWindow))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
            style: .plain, target: self, action: #selector(saveHabit))
    }
    
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(
            titleForNameOfHabitLabel,
            nameHabitTextField,
            titleForColorOfHabitLabel,
            colorOfHabitView,
            titleForTimeOfHabitLabel,
            timeOfHabitLabel,
            setTimeOfHabitPickerView,
            buttonDeleteHabit)
        
        scrollView.keyboardDismissMode = .onDrag
    }
    
    
    private func editHabit() {
        if let habit = habit {
            nameHabitTextField.text = habit.name
            nameHabitTextField.textColor = habit.color
            colorOfHabitView.backgroundColor = habit.color
            colorOfHabitView.layer.borderWidth = 0
            setTimeOfHabitPickerView.date = habit.date
            timeOfHabitLabel.text = habit.dateString
            navigationItem.title = "Править"
            buttonDeleteHabit.isHidden = false
            editDate()
        } else {
            nameHabitTextField.text = ""
            colorOfHabitView.backgroundColor = .white
            setTimeOfHabitPickerView.date = Date()
            navigationItem.title = "Создать"
            buttonDeleteHabit.isHidden = true
        }
    }
 
    
    private func setupConstraints(){
        let allElementHeigh = view.frame.size.height - (
            titleForNameOfHabitLabel.frame.size.height
            + nameHabitTextField.frame.size.height
            + titleForColorOfHabitLabel.frame.size.height
            + colorOfHabitView.frame.size.height
            + titleForTimeOfHabitLabel.frame.size.height
            + timeOfHabitLabel.frame.size.height
            + setTimeOfHabitPickerView.frame.size.height
            + buttonDeleteHabit.frame.size.height
        )
        
        scrollView.toAutoLayout()
        let constraints = [
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
            
            timeOfHabitLabel.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            timeOfHabitLabel.topAnchor.constraint(equalTo: titleForTimeOfHabitLabel.bottomAnchor, constant: 7),
            timeOfHabitLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32),
            
            setTimeOfHabitPickerView.leadingAnchor.constraint(equalTo: titleForNameOfHabitLabel.leadingAnchor),
            setTimeOfHabitPickerView.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor),
            
            buttonDeleteHabit.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: allElementHeigh),
            buttonDeleteHabit.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonDeleteHabit.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18),
            buttonDeleteHabit.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    
   // MARK: - ColorView setup
    
    private func setupColorHabit() {
        colorOfHabitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choseColor)))
    }
    
    
    @objc private func choseColor(sender: UITapGestureRecognizer) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.selectedColor = colorOfHabitView.backgroundColor ?? .black
        present(colorPickerVC, animated: true)
    }

    
    internal func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorOfHabitView.backgroundColor = color
        colorOfHabitView.layer.borderWidth = 0
        nameHabitTextField.textColor = color
        
    }
    
    internal func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorOfHabitView.backgroundColor = color
        colorOfHabitView.layer.borderWidth = 0
        nameHabitTextField.textColor = color
    }
    

    
    
    // MARK: - TimeTextField setup
    
    @objc private func chooseTime(sender:UIDatePicker) {
        habit?.date = sender.date
        let string: String = "Каждый день в "
        let time: String = dateFormatter.string(from: sender.date)
        
        let textFullTimeTextField = NSMutableAttributedString(string: string + time)
        
        textFullTimeTextField.addAttribute(.foregroundColor, value: UIColor.systemCustomPurple ?? UIColor.red, range: NSRange(location: string.count, length: time.count))
        
        timeOfHabitLabel.attributedText = textFullTimeTextField
    }

    
    private func editDate(){
        guard let tempString = timeOfHabitLabel.text else {return}
        let string: String = "Каждый день в "
        
        let textFullTimeTextField = NSMutableAttributedString(string: tempString)

        textFullTimeTextField.addAttribute(.foregroundColor, value: UIColor.systemCustomPurple ?? UIColor.red, range: NSRange(location: string.count, length: tempString.count - string.count))
        
        timeOfHabitLabel.attributedText = textFullTimeTextField
    }

    
    
    // MARK: - CreateOrEditNewHabit setup

    @objc private func saveHabit(){
        var notification: String?
        if nameHabitTextField.text!.isEmpty {
            notification = "НАЗВАНИЕ"
        } else if colorOfHabitView.backgroundColor == .white {
            notification = "ЦВЕТ"
        } else if timeOfHabitLabel.text!.count <= 14 {
            notification = "ВРЕМЯ"
        }
        
        guard notification == nil else {
            dontCreateHabitAlert(notification!)
            return
        }
        
        if let habit = habit {
            habit.name = nameHabitTextField.text ?? ""
            habit.date = setTimeOfHabitPickerView.date
            habit.color = colorOfHabitView.backgroundColor ?? .white
            HabitsStore.shared.save()
        } else {
            let newHabit = Habit(name: nameHabitTextField.text ?? "",
                                 date: setTimeOfHabitPickerView.date,
                                 color: colorOfHabitView.backgroundColor ?? .white)
            
            let store = HabitsStore.shared
            store.habits.append(newHabit)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTitle"), object: nil)

        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - DeleteHabit setup
    
    private func setupDeleteButton() {
        buttonDeleteHabit.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)

    }
    
    @objc private func deleteHabit(_ sender: UIButton) {
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
    @objc private func closeWindow(){
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - extension KeyboardSetup
extension HabitViewController {
    
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
}


// MARK: - notification about Habit
extension HabitViewController {
    
    private func dontCreateHabitAlert (_ notification: String){
        let alert = UIAlertController(
            title: "Заполните поле:\n",
            message: notification,
            preferredStyle: .alert)
        
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20,weight: UIFont.Weight.regular),NSAttributedString.Key.foregroundColor :UIColor.systemCustomPurple!]), forKey: "attributedMessage")
        
        alert.view.tintColor = .black

                
        let ok = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(ok)
 
        self.present(alert, animated: true, completion: nil)
    }
}

