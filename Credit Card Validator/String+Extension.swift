//
//  String+Extension.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

extension String {

    // MARK: Public methods
    func getString(withoutSeparator separator: String) -> String {
        return self.components(separatedBy: separator).joined()
    }

    func length() -> Int {
        return self.characters.count
    }

    func getRange(from: Int, to: Int) -> Range<String.Index> {
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to)
        let range = start..<end
        return range
    }

    // MARK: Subscripts
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }

    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }
}
