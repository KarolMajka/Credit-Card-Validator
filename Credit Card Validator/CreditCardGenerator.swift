//
//  CreditCardGenerator.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit
import Darwin

// MARK: - CreditCardType enum
enum CreditCardType: Int {
    case visa = 0
    case mastercard = 1
}

// MARK: - CreditCardGenerator class
class CreditCardGenerator {

    // MARK: Fileprivate properties
    fileprivate static let digits: Int = 16

    // MARK: Public properties
    var array: [Int] = Array(repeating: 0, count: CreditCardGenerator.digits)
}

// MARK: Helpers
fileprivate extension CreditCardGenerator {
    func random(from: UInt32, to: UInt32) -> Int {
        return Int(arc4random_uniform(to-from+1)+from)
    }

    func generateRestOfDigits(start: Int) {
        for i in start...CreditCardGenerator.digits-1 {
            array[i] = random(from: 1, to: 9)
        }
    }
}

// MARK: Public methods
extension CreditCardGenerator {
    public func generate(_ type: CreditCardType) {
        if type == .visa {
            array[0] = 4
        } else if type == .mastercard {
            array[0] = 5
            array[1] = random(from: 1, to: 5)
        }

        let start = type == .visa ? 1 : 2
        repeat {
            generateRestOfDigits(start: start)
        } while !isValid()
    }

    public func generate() {
        let creditCardType = CreditCardType(rawValue: random(from: 0, to: 1)) ?? .mastercard
        self.generate(creditCardType)
    }

    public func isValid() -> Bool {
        var duplicateArray = array

        for i in stride(from: 0, to: CreditCardGenerator.digits, by: 2) {
            duplicateArray[i] *= 2
            if duplicateArray[i] >= 10 {
                duplicateArray[i] = duplicateArray[i]%10 + duplicateArray[i]/10
            }
        }
        let sum = duplicateArray.reduce(0, +)
        if sum%10 == 0 {
            return true
        } else {
            return false
        }
    }

    public func toString() -> String {
        return self.array.flatMap({ String($0) }).joined()
    }
}
