//
//  CreditCard.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

// MARK: - CreditCard class
class CreditCard {
    
    // MARK: Public properties
    public let valid: Bool
    
    // MARK: Initialization
    init(valid: Bool) {
        self.valid = valid
    }
}

// MARK: Networking
extension CreditCard {
    enum JSONKey: String {
        case bin, bank, card, type, level, country, countrycode, website, phone, valid
    }
    
    convenience init?(json: [String : Any]) {
        guard let valid = json[JSONKey.valid.rawValue] as? String,
            let validBool = Bool(valid) else { return nil }
        self.init(valid: validBool)
    }
}
