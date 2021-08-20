//
//  File.swift
//  MyHabits
//
//  Created by Миша on 20.08.2021.
//

import UIKit


func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}

//        Timer.scheduledTimer(timeInterval: 3, target:self, selector: #selector(reload), userInfo: nil, repeats: true)

