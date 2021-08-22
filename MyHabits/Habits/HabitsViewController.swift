//
//  FirstViewController.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit

class HabitsViewController: UIViewController {
        
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInsetReference = .fromSafeArea
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
        
    let appearanceNB = UINavigationBarAppearance()
    
    let habitCellID = "HabitCellID"
    let progressCellID = "ProgressCellID"
    let sideSpacing: CGFloat = 16
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        setupCollectionView()
        setupConstraints()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        viewDidLoad()
        setupNavigationBar()
    }

    
    func setupNavigationBar() {
        appearanceNB.configureWithOpaqueBackground()
        appearanceNB.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceNB
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(createNewHabit))
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: habitCellID)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: progressCellID)
    }
    
    
    func setupConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ].forEach{$0 .isActive = true}
    }
    
    
    @objc func createNewHabit() {
        let createNewHabit = HabitViewController()
        createNewHabit.habit = nil
        let habitViewController = UINavigationController(rootViewController: createNewHabit)
        habitViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        habitViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(habitViewController, animated: true)
    }
}




// MARK: - extension UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HabitsStore.shared.habits.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: progressCellID, for: indexPath) as! ProgressCollectionViewCell
            cell.setupProgress(progress: HabitsStore.shared.todayProgress)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: habitCellID, for: indexPath) as! HabitCollectionViewCell
            
            cell.configure(with: HabitsStore.shared.habits[indexPath.item])
            cell.delegate = self
            return cell
        }
    }
}


// MARK: - extension UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsWidth = CGFloat(view.frame.size.width - (sideSpacing * 2))
        let progressCellHeight: CGFloat = 60
        let habitsCallHeight: CGFloat = 130
        
        if indexPath.section == 0 {
            return CGSize(width: cellsWidth, height: progressCellHeight)
        } else {
            return CGSize(width: cellsWidth, height: habitsCallHeight)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 18
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0)
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.section > 0 else { return }
        let detailsViewController = HabitDetailsViewController(habit: HabitsStore.shared.habits[indexPath.item])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}


extension HabitsViewController: HabitCollectionCellDelegate {
    func reloadData() {

        self.collectionView.reloadData()
    }
}


   

