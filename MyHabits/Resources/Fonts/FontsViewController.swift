//
//  FontsViewController.swift
//  MyHabits
//
//  Created by Миша on 09.08.2021.
//

import UIKit

class FontsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names:\(names)")
        }
    }
}
