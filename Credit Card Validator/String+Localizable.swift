//
//  String+Localizable.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 23/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

private func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

// MARK: - Localized Strings
extension String {
    // MARK: MainViewController
    static let generateButton = NSLocalizedString("GenerateButton")
    static let validateButton = NSLocalizedString("ValidateButton")
}
