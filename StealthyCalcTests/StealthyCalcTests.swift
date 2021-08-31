//
//  StealthyCalcTests.swift
//  StealthyCalcTests
//
//  Created by Stephen McKenna on 6/4/21.
//

import XCTest
@testable import StealthyCalc

class NumberCruncherTests: XCTestCase {
    var sut: NumberCruncher!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NumberCruncher()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testSignChange() {
        // "8" "+/-" RETURNS -8 PRINTS "-8"
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        XCTAssertEqual(sut.result, -8)
        XCTAssertEqual(sut.equation, "˗8")
        
        // "8" "+/-" "=" RETURNS -8 PRINTS "-8" (= should be added in UI)
        sut.performOperation("=")
        XCTAssertEqual(sut.result, -8)
        XCTAssertEqual(sut.equation, "˗8")
        
        // "8" "+/-" "=" "=" RETURNS -8 PRINTS "-8"
        sut.performOperation("=")
        XCTAssertEqual(sut.result, -8)
        XCTAssertEqual(sut.equation, "˗8")
        
        // "8" "+/-" "=" "=" "+/-" RETURNS 8 PRINTS "-(-8)"
        sut.performOperation("ᐩ/˗")
        XCTAssertEqual(sut.result, 8)
        XCTAssertEqual(sut.equation, "˗(˗8)")
        
        // "8" "+/-" "=" "=" "+/-" "=" RETURNS 8 PRINTS "-(-8)"
    }
    
    func testNumberCruncherMath() {
        /* rule: typing "=" reduces everything in parentheses */
        
        
        // "8" "%" RETURNS 0.08 PRINTS "8%"
        // "8" "%" "=" RETURNS 0.08 PRINTS "8% ="
        // "8" "%" "=" "=" RETURNS 0.08 PRINTS "8% ="
        
        // "8" "x^2" RETURNS 64 PRINTS "8^2 ="
        // "8" "x^2" "=" RETURNS 4,096 PRINTS "64^2 ="
        // "8" "x^2" "x^2" RETURNS 4,096 PRINTS "(8^2)^2 ="
        // "8" "x^2" "x^2" "+" "5" RETURNS 5 PRINTS "(8^2)^2 +"
        // "8" "x^2" "x^2" "+" "5" "=" RETURNS 4,101 PRINTS "64^2+5 ="
        // "8" "x^2" "x^2" "+" "5" "=" "=" RETURNS 4,106 PRINTS "64^2+5+5 ="
        
        // "8" "x" "+/-" RETURNS -0 PRINTS "8 x"
        // "8" "x" "+/-" "7" RETURNS -7 PRINTS "8 x"
        // "8" "x" "+/-" "7" "=" RETURNS -56 PRINTS "8 x -7 ="
        // "8" "x" "7" "+/-" RETURNS -7 PRINTS "8 x"
        // "8" "x" "7" "+/-" "=" RETURNS -56 PRINTS "8 x -7 ="
        
        
        // "9" "÷" "3" "=" RETURNS 3
        sut.setOperand(9)
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        XCTAssertEqual(sut.result, 3)
        XCTAssertEqual(sut.equation, "9÷3")
        
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        XCTAssertEqual(sut.result, 1)
        // "9" "x" "9" "=" RETURNS 81
        // "5" "-" "1.7" "=" RETURNS 3.3
        // "7" "+" "1" "=" RETURNS 8
        // "7" "+" "1" "=" "=" RETURNS 9
        // "8" "x" "(" "5" "+" "5" ")" RETURNS 10
        // "8" "x" "(" "5" "+" "5" ")" "=" RETURNS 80
        // "8" "x" "(" "5" "+" "5" ")" "=" "=" RETURNS 90
        // "8" "x" "(" "5" "+" "5" ")" "=" "=" "x^2" RETURNS 8,100
        // "8" "x" "(" "5" "+" "5" ")" "=" "=" "x^2" "=" RETURNS 65,610,000
        
        #warning("Solve for large numbers like in Fib problem")
        #warning("Solve for printing long equations")
    }
    
    func testAnotherTest() {
        sut.setOperand(3)
        XCTAssertEqual(sut.result, 3)
    }

}
