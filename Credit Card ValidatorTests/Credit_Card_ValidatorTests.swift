//
//  Credit_Card_ValidatorTests.swift
//  Credit Card ValidatorTests
//
//  Created by Karol Majka on 20/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import XCTest
@testable import Credit_Card_Validator

class Credit_Card_ValidatorTests: XCTestCase {
    
    var validCards: [String]!
    var invalidCards: [String]!
    var generator: CreditCardGenerator!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.validCards = self.loadPropertyList("ValidCardNumbers")
        self.invalidCards = self.loadPropertyList("InvalidCardNumbers")
        self.generator = CreditCardGenerator()
    }
    
    func loadPropertyList(_ name: String) -> [String] {
        let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "plist")
        XCTAssertNotNil(path)
        
        let array = NSArray(contentsOfFile: path!) as? [String]
        XCTAssertNotNil(array)
        return array!
    }

    func toArray(card: String) -> [Int] {
        var array: [Int] = []
        for (i, c) in card.characters.enumerated() {
            if i > 16 {
                XCTAssert(false)
            }
            let integer = Int(String(c))
            XCTAssertNotNil(integer)
            array.append(integer!)
        }
        XCTAssert(array.count == 16)
        return array
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidCards() {
        for card in self.validCards {
            self.generator.array = self.toArray(card: card)
            XCTAssert(self.generator.isValid())
        }
    }
    
    func testInvalidCards() {
        for card in self.invalidCards {
            self.generator.array = self.toArray(card: card)
            XCTAssert(!self.generator.isValid())
        }
    }
    
}
