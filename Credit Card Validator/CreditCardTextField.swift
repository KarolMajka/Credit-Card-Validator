//
//  CreditCardTextField.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

// MARK: - CreditCardDelegate protocol
public protocol CreditCardDelegate {
    func filled(_ filled: Bool, forTextField textField: UITextField)
}

// MARK: - CreditCard protocol
internal protocol CreditCard {
    var number: String { get }
    var requiredDigits: Int { get }
    var isFilled: Bool { get }
    func reformated(_ text: String) -> String
}

// MARK: - CreditCardTextField class
public class CreditCardTextField: UITextField, CreditCard {
    
    // MARK: Public properties
    public var delegateMethods: CreditCardDelegate?
    public var requiredDigits: Int { get { return 0 } }
    public var number: String = "" {
        didSet {
            if self.isFilled != (self.number.getString(withoutSeparator: self.separator).length() >= self.requiredDigits) {
                self.isFilled = !self.isFilled
            }
            self.didChangeValue(forKey: "number")
        }
    }
    public var isFilled: Bool = false {
        didSet {
            self.delegateMethods?.filled(self.isFilled, forTextField: self)
            self.didChangeValue(forKey: "isFilled")
        }
    }
    
    // MARK: Internal properties
    internal var separator: String { get { return "" } }
    
    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.keyboardType = .numberPad
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: CreditCardNumber methods
extension CreditCardTextField {
    internal func reformated(_ text: String) -> String {
        let denseText = text.getString(withoutSeparator: self.separator)
        return denseText
    }
}
