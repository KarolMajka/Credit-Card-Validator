//
//  UIButton+Extension.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 23/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

extension UIButton {
    func defaultConfig() {
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
        self.backgroundColor = UIColor.init(red: 0, green: 214/255, blue: 100/255, alpha: 1)
    }
}
