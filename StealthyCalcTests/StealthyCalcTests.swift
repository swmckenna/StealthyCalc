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
        #warning("Implement = rule")
        // "8" "+/-" RETURNS -8 PRINTS "-(8)"
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗(8)")
        
        // "8" "+/-" "=" RETURNS -8 PRINTS "-8" (= should be added in UI)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗(8)")

        // "8" "+/-" "=" "=" RETURNS -8 PRINTS "-(8)"
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗(8)")

        // "8" "+/-" "=" "=" "+/-" RETURNS 8 PRINTS "-(-8)"
        sut.performOperation("ᐩ/˗")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "˗(˗(8))")

        // "8" "+/-" "=" "=" "+/-" "=" RETURNS 8 PRINTS "-(-8)"
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "˗(˗(8))")
    }
    
    func testDivision() {
        // "12" "÷" "2" "=" RETURNS 6
        sut.setOperand(12)
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 6)
        XCTAssertEqual(result.expressionString, "12÷2")

        // "12" "÷" "2" "=" "÷" "3" "=" RETURNS 2
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 2)
        XCTAssertEqual(result.expressionString, "12÷2÷3")
    }
    
    func testDivisionRepeats() {
        sut.setOperand(27)
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 9)
        XCTAssertEqual(result.expressionString, "27÷3")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 3)
        XCTAssertEqual(result.expressionString, "27÷3÷3")
    }
    
    func testDivisionRepeatsNewNumber() {
        sut.setOperand(24)
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "24÷3")
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 4)
        XCTAssertEqual(result.expressionString, "24÷3÷2")
    }
    
    func testDivisionRepeatsNewNumberNoEquals() {
        sut.setOperand(24)
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "24÷3")
        sut.setOperand(12)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 4)
        XCTAssertEqual(result.expressionString, "12÷3")
    }
    
    func testPercentage() {
        // "8" "%" RETURNS 0.08 PRINTS "8%"
        sut .setOperand(8)
        sut.performOperation("%")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        // "8" "%" "=" RETURNS 0.08 PRINTS "8%"
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        // "8" "%" "=" "=" RETURNS 0.08 PRINTS "8% ="
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
    }
    
    func testSquared() {
        // "8" "x²" RETURNS 64 PRINTS "8²"
        sut.setOperand(8)
        sut.performOperation("х²")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 64)
        XCTAssertEqual(result.expressionString, "8²")
        
        // "8" "x²" "=" RETURNS 4,096 PRINTS "64² ="
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 4096)
        // "8" "x²" "x^2" RETURNS 4,096 PRINTS "(8²)² ="
        // "8" "x²" "x^2" "+" "5" RETURNS 5 PRINTS "(8²)² +"
        // "8" "x²" "x^2" "+" "5" "=" RETURNS 4,101 PRINTS "64²+5 ="
        // "8" "x²" "x^2" "+" "5" "=" "=" RETURNS 4,106 PRINTS "64²+5+5 ="
    }
    
    func testMulitplyByAlternativeInputNegative() {
        sut.setOperand(8)
        sut.performOperation("×")
        sut.performOperation("ᐩ/˗")
        sut.setOperand(7)
        sut.performOperation("=")
        let result = sut.evaluate()
        XCTAssertEqual(result.result, -56)
        XCTAssertEqual(result.expressionString, "8×˗(7)")
    }
    
    func testGetErrorWhenDivideByZeroAndIncorrectNegativeInput() {
        sut.setOperand(8)
        sut.performOperation("÷")
        sut.performOperation("ᐩ/˗")
        sut.performOperation("+")
        let result = sut.evaluate()
        XCTAssertNotNil(result.error)
    }
    
    func testNumberCruncherMath() {
        /* rule: typing "=" reduces everything in parentheses */
        
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

}
