//
//  CreditCardNumberTextField.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 20/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit


// MARK: - CreditCardDelegate protocol
public protocol CreditCardDelegate {
    func filled(_ filled: Bool)
}

// MARK: - CreditCardNumber protocol
fileprivate protocol CreditCardNumber {
    var number: String { get }
    var requiredDigits: Int { get }
    var isFilled: Bool { get }
    func reformated(_ text: String) -> String
}

// MARK: - CreditCardNumberTextField class
class CreditCardNumberTextField: UITextField, CreditCardNumber {
    
    // MARK: Fileprivate properties
    fileprivate static let placeholderText = "1234 5678 9012 3456"
    
    // MARK: Public properties
    public let requiredDigits: Int = 16
    public var number: String = "" {
        didSet {
            if self.isFilled != (self.number.getNumberWithoutWhitespaces().length() >= self.requiredDigits) {
                self.isFilled = !self.isFilled
            }
            self.didChangeValue(forKey: "number")
        }
    }
    public var isFilled: Bool = false {
        didSet {
            self.delegateMethods?.filled(self.isFilled)
            self.didChangeValue(forKey: "isFilled")
        }
    }
    public var delegateMethods: CreditCardDelegate?
    
    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.placeholder = CreditCardNumberTextField.placeholderText
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.delegate = self
        self.keyboardType = .numberPad
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Helpers
fileprivate extension CreditCardNumberTextField {
    
}

// MARK: UITextFieldDelegate
extension CreditCardNumberTextField: UITextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField) {
        textField.text = self.reformated(textField.text!)
        self.number = textField.text!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        let denseString = string.getNumberWithoutWhitespaces()
        let charset = CharacterSet(charactersIn: "1234567890").inverted
        if denseString.rangeOfCharacter(from: charset) != nil {
            return false
        }
        
        let newRange = textField.text!.getRange(from: range.location, to: range.location+range.length)
        let proposeString = textField.text!.replacingCharacters(in: newRange, with: string)
        if proposeString.getNumberWithoutWhitespaces().length() > self.requiredDigits {
            return false
        }
        return true
    }
}

// MARK: CreditCardNumber methods
extension CreditCardNumberTextField {
    fileprivate func reformated(_ text: String) -> String {
        let denseText = text.getNumberWithoutWhitespaces()
        var newString = ""
        for (i, c) in denseText.characters.enumerated() {
            if i%4 == 0 && i > 0 {
                newString += " "
            }
            newString += String(c)
        }
        return newString
    }
}
