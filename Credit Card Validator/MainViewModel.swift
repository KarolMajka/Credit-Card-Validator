//
//  MainViewModel.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

// MARK: - MainViewModelDelegate protocol
protocol MainViewModelDelegate {
    func validateMessageDidChange(_ message: String)
}

// MARK: - MainViewModel
class MainViewModel {
    
    // MARK: Fileprivate properties
    fileprivate let networking = NetworkLoader.shared
    fileprivate let generator = CreditCardGenerator.shared
    
    // MARK: Public properties
    public var delegate: MainViewModelDelegate?
    public var validateMessage = "" {
        didSet {
            self.delegate?.validateMessageDidChange(validateMessage)
        }
    }
}

// MARK: Public methods
extension MainViewModel {
    public func validate(creditCard: String) {
        self.networking.download(creditCard: creditCard, block: { creditCard in
            DispatchQueue.main.async {
                print(creditCard.valid)
                if creditCard.valid {
                    self.validateMessage = "Credit Card is valid"
                } else {
                    self.validateMessage = "Credit Card is invalid"
                }
            }
        }, error: { error in
            DispatchQueue.main.async {
                self.validateMessage = error.localizedDescription
            }
        })
    }
    
    func generate() -> String {
        self.generator.generate()
        var creditCardNumber = self.generator.toString()
        var creditCard = ""
        for (i, c) in creditCardNumber.characters.enumerated() {
            if i%4 == 0 && i > 0 {
                creditCard += " "
            }
            creditCard += String(c)
        }
        return creditCard
    }
}
