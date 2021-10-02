//
//  StealthyCalcTests.swift
//  StealthyCalcTests
//
//  Created by Stephen McKenna on 6/4/21.
//

import XCTest
@testable import StealthyCalc

class NumberCruncherBinaryTests: XCTestCase {
    var sut: NumberCruncher!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NumberCruncher()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testNthRoot() {
        sut.setOperand(8)
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(3)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 2)
        XCTAssertEqual(result.expressionString, "8^(1/3)")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.259921049894873, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "(8^(1/3))^(1/3)")

        sut.setOperand(16)
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(4)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 2)
        XCTAssertEqual(result.expressionString, "16^(1/4)")

        sut.clear()
        sut.setOperand(5)
        sut.performOperation("ʸ√ₓ")
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(2)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 2.23606797749979, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "5^(1/2)")

        sut.clear()
        sut.setOperand(8)
        sut.performOperation("ʸ√ₓ")
        sut.performOperation("ᐩ/˗")
        sut.setOperand(3)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.5)
        XCTAssertEqual(result.expressionString, "8^(1/(˗3))")

        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(3)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -2)
        XCTAssertEqual(result.expressionString, "(˗8)^(1/3)")

        sut.setOperand(0)
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(9)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "0^(1/9)")
        
        sut.setOperand(9)
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(0)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "9^(1/0)")
        
        sut.setOperand(16)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(4)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "(˗16)^(1/4)")
        
        sut.setOperand(16)
        sut.performOperation("ʸ√ₓ")
        sut.setOperand(4)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.5)
        XCTAssertEqual(result.expressionString, "16^(1/(˗4))")
    }
    
    func testExponent() {
        sut.setOperand(0)
        sut.performOperation("xʸ")
        sut.setOperand(8)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "0^8")
        
        sut.setOperand(1)
        sut.performOperation("xʸ")
        sut.setOperand(8)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "1^8")
        
        sut.setOperand(8)
        sut.performOperation("xʸ")
        sut.setOperand(6)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 262144)
        XCTAssertEqual(result.expressionString, "8^6")
        
        sut.setOperand(8)
        sut.performOperation("xʸ")
        sut.setOperand(6)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.000003814697266, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "8^(˗6)")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("xʸ")
        sut.setOperand(3)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -512)
        XCTAssertEqual(result.expressionString, "(˗8)^3")
        
        sut.setOperand(8)
        sut.performOperation("xʸ")
        sut.setOperand(0)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "8^0")
        
        sut.setOperand(16)
        sut.performOperation("xʸ")
        sut.setOperand(0.25)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 2)
        XCTAssertEqual(result.expressionString, "16^0.25")
    }
    
    func testReverseExponent() {
        sut.setOperand(0)
        sut.performOperation("yˣ")
        sut.setOperand(8)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "8^0")
        
        sut.setOperand(1)
        sut.performOperation("yˣ")
        sut.setOperand(8)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 8)
        XCTAssertEqual(result.expressionString, "8^1")
        
        sut.setOperand(8)
        sut.performOperation("yˣ")
        sut.setOperand(6)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1679616)
        XCTAssertEqual(result.expressionString, "6^8")
        
        sut.setOperand(8)
        sut.performOperation("yˣ")
        sut.setOperand(6)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1679616)
        XCTAssertEqual(result.expressionString, "(˗6)^8")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("yˣ")
        sut.setOperand(3)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.000152415790276, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "3^(˗8)")
        
        sut.setOperand(8)
        sut.performOperation("yˣ")
        sut.setOperand(0)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "0^8")
        
        sut.setOperand(16)
        sut.performOperation("yˣ")
        sut.setOperand(0.25)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.000000000232831, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "0.25^16")
    }
    
    func testLogYofX() {
        sut.setOperand(8)
        sut.performOperation("㏒ₓ")
        sut.setOperand(2)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 3)
        XCTAssertEqual(result.expressionString, "㏒2(8)")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.584962500721156, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒2(㏒2(8))")
        
        sut.setOperand(0)
        sut.performOperation("㏒ₓ")
        sut.setOperand(3)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏒3(0)")

        sut.setOperand(3)
        sut.performOperation("㏒ₓ")
        sut.performOperation("ᐩ/˗")
        sut.setOperand(2)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏑(3)/㏑(˗2)")
        
        sut.clear()
        sut.setOperand(16)
        sut.performOperation("㏒ₓ")
        sut.setOperand(0.5)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -4)
        XCTAssertEqual(result.expressionString, "㏒0.5(16)")
        

        sut.performOperation("㏒ₓ")
        sut.setOperand(2)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏒2(㏒0.5(16))")
        
        sut.performOperation("e")
        sut.performOperation("㏒ₓ")
        sut.performOperation("e")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "㏒e(e)")
        
        sut.setOperand(1)
        sut.performOperation("㏒ₓ")
        sut.performOperation("π")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "㏒π(1)")
    }
    
    func testEE() {
        sut.setOperand(3)
        sut.performOperation("EE")
        sut.setOperand(23)
        sut.performOperation("=")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 3e23)
        XCTAssertEqual(result.expressionString, "3e23")
        
        sut.setOperand(7)
        sut.performOperation("EE")
        sut.setOperand(69)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 7e69)
        XCTAssertEqual(result.expressionString, "7e69")
        
        sut.setOperand(5)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("EE")
        sut.setOperand(55)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -5e55)
        XCTAssertEqual(result.expressionString, "(˗5)e55")
        
        sut.setOperand(5)
        sut.performOperation("EE")
        sut.performOperation("ᐩ/˗")
        sut.setOperand(55)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 5e-55)
        XCTAssertEqual(result.expressionString, "5e(˗55)")
        
        sut.setOperand(0)
        sut.performOperation("EE")
        sut.setOperand(55)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "0e55")
        
        sut.setOperand(105)
        sut.performOperation("EE")
        sut.setOperand(0)
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 105)
        XCTAssertEqual(result.expressionString, "105e0")
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
        XCTAssertEqual(result.expressionString, "(12÷2)÷3")
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
        XCTAssertEqual(result.expressionString, "(27÷3)÷3")
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
        XCTAssertEqual(result.expressionString, "(24÷3)÷2")
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
    
    func testMulitplyByAlternativeInputNegative() {
        sut.setOperand(8)
        sut.performOperation("×")
        sut.performOperation("ᐩ/˗")
        sut.setOperand(7)
        sut.performOperation("=")
        let result = sut.evaluate()
        XCTAssertEqual(result.result, -56)
        XCTAssertEqual(result.expressionString, "8×(˗7)")
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
        
        #warning("Solve for printing long equations")
        #warning("Test precedence")
    }

}
