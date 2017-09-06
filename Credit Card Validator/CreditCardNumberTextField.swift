//
//  CreditCardNumberTextField.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 20/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

// MARK: - CreditCardNumberTextField class
public class CreditCardNumberTextField: CreditCardTextField {

    // MARK: Fileprivate properties
    fileprivate static let placeholderText = "1234 5678 9012 3456"

    // MARK: Internal properties
    internal override var separator: String {
        get {
            return " "
        }
        set { }
    }

    // MARK: Public properties
    public override var requiredDigits: Int {
        get {
            return 16
        }
        set { }
    }

    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.placeholder = CreditCardNumberTextField.placeholderText
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.delegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Helpers
fileprivate extension CreditCardNumberTextField {

}

// MARK: UITextFieldDelegate
extension CreditCardNumberTextField: UITextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        let reformatedText = self.reformated(text)
        textField.text = reformatedText
        self.number = reformatedText
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }

        let denseString = string.getString(withoutSeparator: self.separator)
        let charset = CharacterSet(charactersIn: "1234567890").inverted
        if denseString.rangeOfCharacter(from: charset) != nil {
            return false
        }

        let text = textField.text ?? ""
        let newRange = text.getRange(from: range.location, to: range.location+range.length)
        let proposeString = text.replacingCharacters(in: newRange, with: string)
        if proposeString.getString(withoutSeparator: self.separator).length() > self.requiredDigits {
            return false
        }
        return true
    }

}

// MARK: CreditCard methods
extension CreditCardNumberTextField {
    internal override func reformated(_ text: String) -> String {
        let denseText = super.reformated(text)
        var newString = ""
        for (i, c) in denseText.characters.enumerated() {
            if i%4 == 0 && i > 0 {
                newString += self.separator
            }
            newString += String(c)
        }
        return newString
    }
}
