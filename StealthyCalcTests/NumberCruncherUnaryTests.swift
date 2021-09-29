//
//  NumberCruncherUnaryTests.swift
//  StealthyCalcTests
//
//  Created by Stephen McKenna on 9/28/21.
//

import XCTest

class NumberCruncherUnaryTests: XCTestCase {
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

        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗8")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗8")

        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗8")

        sut.performOperation("ᐩ/˗")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "˗(˗8)")

        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "˗(˗8)")
    }
    
    func testPercentage() {
        sut .setOperand(8)
        sut.performOperation("%")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("%")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -0.08)
        XCTAssertEqual(result.expressionString, "(˗8)%")
        
    }
    
    func testSquared() {
        sut.setOperand(8)
        sut.performOperation("х²")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 64)
        XCTAssertEqual(result.expressionString, "8²")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 4096)
        XCTAssertEqual(result.expressionString, "(8²)²")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("х²")
        sut.performOperation("х²")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 4096)
        XCTAssertEqual(result.expressionString, "(8²)²")

    }
    
    func testCubed() {
        sut.setOperand(8)
        sut.performOperation("х³")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 512)
        XCTAssertEqual(result.expressionString, "8³")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 134217728)
        XCTAssertEqual(result.expressionString, "(8³)³")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("х³")
        sut.performOperation("х³")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 134217728)
        XCTAssertEqual(result.expressionString, "(8³)³")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("х³")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -512)
        XCTAssertEqual(result.expressionString, "(˗8)³")
    }
    
    func testEPower() {
        sut.setOperand(8)
        sut.performOperation("eˣ")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 2980.957987041727) //actually 2980.957987041728 on iOS calculator
        XCTAssertEqual(result.expressionString, "e^8")

        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 2980.957987041727) //actually 2980.957987041728 on iOS calculator
        XCTAssertEqual(result.expressionString, "e^8")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("eˣ")
        sut.performOperation("eˣ")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "e^(e^8)")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("eˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.000335462627903, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "e^(˗8)")
    }
    
    func test10Power() {
        sut.setOperand(8)
        sut.performOperation("10ˣ")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 100000000)
        XCTAssertEqual(result.expressionString, "10^8")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 100000000)
        XCTAssertEqual(result.expressionString, "10^8")
        
        sut.setOperand(28)
        sut.performOperation("10ˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1e28)
        XCTAssertEqual(result.expressionString, "10^28")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("10ˣ")
        sut.performOperation("10ˣ")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "10^(10^8)")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("10ˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.00000001)
        XCTAssertEqual(result.expressionString, "10^(˗8)")
    }
    
    func test2Power() {
        sut.setOperand(8)
        sut.performOperation("2ˣ")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 256)
        XCTAssertEqual(result.expressionString, "2^8")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 256)
        XCTAssertEqual(result.expressionString, "2^8")
        
        sut.setOperand(28)
        sut.performOperation("2ˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 268435456)
        XCTAssertEqual(result.expressionString, "2^28")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("2ˣ")
        sut.performOperation("2ˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.157920892373e77, accuracy: 1e65)
        XCTAssertEqual(result.expressionString, "2^(2^8)")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("2ˣ")
        sut.performOperation("2ˣ")
        sut.performOperation("2ˣ")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "2^(2^(2^8))")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("2ˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.00390625)
        XCTAssertEqual(result.expressionString, "2^(˗8)")
    }
    
    func testInverse() {
        sut.setOperand(8)
        sut.performOperation("¹/ₓ")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 1/8)
        XCTAssertEqual(result.expressionString, "8⁻¹")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1/8)
        XCTAssertEqual(result.expressionString, "8⁻¹")
        
        sut.setOperand(28)
        sut.performOperation("¹/ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1/28)
        XCTAssertEqual(result.expressionString, "28⁻¹")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("¹/ₓ")
        sut.performOperation("¹/ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 8)
        XCTAssertEqual(result.expressionString, "(8⁻¹)⁻¹")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("¹/ₓ")
        sut.performOperation("¹/ₓ")
        sut.performOperation("¹/ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1/8)
        XCTAssertEqual(result.expressionString, "((8⁻¹)⁻¹)⁻¹")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("¹/ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -1/8)
        XCTAssertEqual(result.expressionString, "(˗8)⁻¹")
    }
    
    func testSquareRoot() {
        sut.setOperand(8)
        sut.performOperation("²√ₓ")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 2.82842712474619, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "√8")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.681792830507429, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "√(√8)")
        
        sut.setOperand(16)
        sut.performOperation("²√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 4)
        XCTAssertEqual(result.expressionString, "√16")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("²√ₓ")
        sut.performOperation("²√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.681792830507429, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "√(√8)")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("²√ₓ")
        sut.performOperation("²√ₓ")
        sut.performOperation("²√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.29683955465101, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "√(√(√8))")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("²√ₓ")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "√(˗8)")
    }

    func testCubeRoot() {
        sut.setOperand(8)
        sut.performOperation("³√ₓ")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 2)
        XCTAssertEqual(result.expressionString, "³√8")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.259921049894873, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "³√(³√8)")
        
        sut.setOperand(16)
        sut.performOperation("³√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 2.519842099789746, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "³√16")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("³√ₓ")
        sut.performOperation("³√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.259921049894873, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "³√(³√8)")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("³√ₓ")
        sut.performOperation("³√ₓ")
        sut.performOperation("³√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.080059738892306)
        XCTAssertEqual(result.expressionString, "³√(³√(³√8))")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("³√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -2)
        XCTAssertEqual(result.expressionString, "³√(˗8)")
    }

}
