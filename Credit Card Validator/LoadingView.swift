//
//  LoadingView.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 10/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit
import PureLayout

// MARK: - LoadingView class
class LoadingView: UIView {

    // MARK: Fileprivate properties
    fileprivate let activityIndicatorView = UIActivityIndicatorView()
    fileprivate let darkView = UIView()

    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear

        self.addSubview(darkView)
        darkView.autoPinEdgesToSuperviewEdges()
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0.2

        self.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
        activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        activityIndicatorView.alpha = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public methods
extension LoadingView {
    public func show() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }

    public func hide() {
        self.isHidden = true
        self.activityIndicatorView.stopAnimating()
    }
}
