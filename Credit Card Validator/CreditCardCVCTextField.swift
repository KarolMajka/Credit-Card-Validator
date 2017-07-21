//
//  CreditCardCVCTextField.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

// MARK: - CreditCardCVCTextField class
public class CreditCardCVCTextField: CreditCardTextField {

    // MARK: Fileprivate properties
    fileprivate static let placeholderText = "CVC"
    
    // MARK: Public properties
    public override var requiredDigits: Int { get { return 3 } }
    
    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.placeholder = CreditCardCVCTextField.placeholderText
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension CreditCardCVCTextField: UITextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField) {
        textField.text = self.reformated(textField.text!)
        self.number = textField.text!
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
        
        let newRange = textField.text!.getRange(from: range.location, to: range.location+range.length)
        let proposeString = textField.text!.replacingCharacters(in: newRange, with: string)
        if proposeString.getString(withoutSeparator: self.separator).length() > self.requiredDigits {
            return false
        }
        return true
    }
}
