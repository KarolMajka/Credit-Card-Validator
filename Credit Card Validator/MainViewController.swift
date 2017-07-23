//
//  MainViewController.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 20/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit
import PureLayout

// MARK: - MainViewController class
class MainViewController: UIViewController {
    
    // MARK: Views
    fileprivate lazy var ccNumberTextField: CreditCardNumberTextField = {
        let textField = CreditCardNumberTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)

        textField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.topConstraint = textField.autoPin(toTopLayoutGuideOf: self, withInset: 60)
        textField.autoSetDimension(.width, toSize: 185)

        textField.delegateMethods = self
        return textField
    }()
    fileprivate lazy var ccDateTextField: CreditCardDateTextField = {
        let textField = CreditCardDateTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)

        textField.autoMatch(.height, to: .height, of: self.ccNumberTextField)
        textField.autoPinEdge(.left, to: .left, of: self.ccNumberTextField, withOffset: 0)
        textField.autoPinEdge(.top, to: .bottom, of: self.ccNumberTextField, withOffset: 8)
        textField.autoSetDimension(.width, toSize: 60)

        textField.delegateMethods = self
        return textField
    }()
    fileprivate lazy var ccCVCTextField: CreditCardCVCTextField = {
        let textField = CreditCardCVCTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)

        textField.autoMatch(.height, to: .height, of: self.ccNumberTextField)
        textField.autoPinEdge(.left, to: .right, of: self.ccDateTextField, withOffset: 16)
        textField.autoPinEdge(.top, to: .bottom, of: self.ccNumberTextField, withOffset: 8)
        textField.autoSetDimension(.width, toSize: 35)

        textField.delegateMethods = self
        return textField
    }()
    fileprivate lazy var validateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        
        label.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)

        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var validateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        self.bottomConstraint = button.autoPin(toBottomLayoutGuideOf: self, withInset: 80)
        button.autoAlignAxis(.vertical, toSameAxisOf: button.superview!, withOffset: -75)
        button.autoSetDimension(.width, toSize: 120)

        button.defaultConfig()
        button.setTitle(String.validateButton, for: .normal)
        button.addTarget(self, action: #selector(self.validateTapped), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var generateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)

        button.autoPinEdge(.top, to: .top, of: self.validateButton, withOffset: 0)
        button.autoAlignAxis(.vertical, toSameAxisOf: button.superview!, withOffset: 75)
        button.autoMatch(.width, to: .width, of: self.validateButton)
        
        button.defaultConfig()
        button.setTitle(String.generateButton, for: .normal)
        button.addTarget(self, action: #selector(self.generateTapped), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        view.autoPinEdgesToSuperviewEdges()
        
        return view
    }()
    
    // MARK: Fileprivate properties
    fileprivate let viewModel = MainViewModel()
    fileprivate var topConstraint: NSLayoutConstraint!
    fileprivate var bottomConstraint: NSLayoutConstraint!

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        ccNumberTextField.isHidden = false
        ccDateTextField.isHidden = false
        ccCVCTextField.isHidden = false
        validateButton.isHidden = false
        generateButton.isHidden = false
        validateLabel.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(self.orientationChanged(notification:)),
                         name: NSNotification.Name.UIDeviceOrientationDidChange,
                         object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default
            .removeObserver(self,
                            name: NSNotification.Name.UIDeviceOrientationDidChange,
                            object: nil)
    }
}

// MARK: User Actions
extension MainViewController {
    func validateTapped() {
        self.viewModel.validate(creditCard: ccNumberTextField.getNumber())
    }
    
    func generateTapped() {
        let creditCardNumber = self.viewModel.generate()
        self.ccNumberTextField.text = creditCardNumber
        self.ccNumberTextField.number = creditCardNumber
    }
    
    func hideKeyboard() {
        self.ccNumberTextField.resignFirstResponder()
        self.ccDateTextField.resignFirstResponder()
        self.ccCVCTextField.resignFirstResponder()
    }
}

// MARK: Notifications
extension MainViewController {
    // MARK: Orientation Change Notification
    func orientationChanged(notification: NSNotification) {
        self.orientationChanged(to: UIApplication.shared.statusBarOrientation)
    }
}

// MARK: Helpers
fileprivate extension MainViewController {
    func orientationChanged(to orientation: UIInterfaceOrientation) {
        if orientation.isLandscape {
            self.topConstraint.constant = 40
            self.bottomConstraint.constant = -40
        } else if orientation.isPortrait {
            self.topConstraint.constant = 60
            self.bottomConstraint.constant = -80
        }
    }
}

// MARK: CreditCardDelegate
extension MainViewController: CreditCardDelegate {
    func filled(_ filled: Bool, forTextField textField: UITextField) {
        guard let ccTextField = textField as? CreditCardTextField else { return }
        
        switch ccTextField {
        case ccNumberTextField:
            if filled && ccTextField.isFirstResponder {
                if !ccDateTextField.isFilled {
                    ccDateTextField.becomeFirstResponder()
                } else if !ccCVCTextField.isFilled {
                    ccCVCTextField.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            }
        case ccDateTextField:
            if filled {
                if !ccCVCTextField.isFilled {
                    ccCVCTextField.becomeFirstResponder()
                } else if !ccNumberTextField.isFilled {
                    ccNumberTextField.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            }
        case ccCVCTextField:
            if filled {
                if !ccDateTextField.isFilled {
                    ccDateTextField.becomeFirstResponder()
                } else if !ccNumberTextField.isFilled {
                    ccNumberTextField.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            }
        default:
            return
        }
    }

    func isEmpty(_ textField: UITextField) {
        switch textField {
        case ccNumberTextField:
            break
        case ccDateTextField:
            ccNumberTextField.becomeFirstResponder()
        case ccCVCTextField:
            ccDateTextField.becomeFirstResponder()
        default:
            return
        }
    }

}

// MARK: MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
    func validateMessageDidChange(_ message: String) {
        self.validateLabel.text = message
    }

    func showLoadingView() {
        self.loadingView.show()
    }
    
    func hideLoadingView() {
        self.loadingView.hide()
    }
}
