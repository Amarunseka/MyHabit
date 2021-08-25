//
//  AddSubViews.swift
//  MyHabits
//
//  Created by Миша on 24.08.2021.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
