//
//  BincodesError.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

// MARK: - BincodesError class
class BincodesError {
    
    // MARK: Public properties
    public let error: String
    public let message: String
    
    // MARK: Initialization
    init(error: String, message: String) {
        self.error = error
        self.message = message
    }
}

// MARK: Networking
extension BincodesError {
    enum JSONKey: String {
        case error, message
    }
    
    convenience init?(json: [String : Any]) {
        guard let error = json[JSONKey.error.rawValue] as? String,
            let message = json[JSONKey.message.rawValue] as? String
            else { return nil }
        self.init(error: error, message: message)
    }
}
