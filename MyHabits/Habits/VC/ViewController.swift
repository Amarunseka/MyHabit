//
//  ViewController.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit

class ViewController: UITabBarController {

    let habits = UINavigationController(rootViewController: HabitsViewController())
    let info = UINavigationController(rootViewController: InfoViewController())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    func setupTabBar() {
        
        habits.tabBarItem.title = "Привычки"
        habits.tabBarItem.image = UIImage(systemName: "rectangle.grid.1x2.fill")
        
        info.tabBarItem.title = "Информация"
        info.tabBarItem.image = UIImage(systemName: "info.circle.fill")
        
        viewControllers = [habits, info]
        
    }

}

