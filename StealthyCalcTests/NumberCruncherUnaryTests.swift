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
        
        sut.setOperand(0)
        sut.performOperation("ᐩ/˗")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 0)
        XCTAssertEqual(result.expressionString, "˗0")
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
        
        sut.setOperand(0)
        sut.performOperation("10ˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "10^0")
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
        
        sut.setOperand(0)
        sut.performOperation("2ˣ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "2^0")
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
        
        sut.setOperand(0)
        sut.performOperation("¹/ₓ")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "0⁻¹")
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
        
        sut.setOperand(0)
        sut.performOperation("²√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "√0")
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
        
        sut.setOperand(0)
        sut.performOperation("³√ₓ")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "³√0")
    }
    
    
    func testNaturalLog() {
        sut.setOperand(8)
        sut.performOperation("㏑")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 2.079441541679836, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏑(8)")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 2.079441541679836, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏑(8)")
        
        sut.setOperand(0)
        sut.performOperation("㏑")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏑(0)")
        
        sut.setOperand(1)
        sut.performOperation("㏑")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "㏑(1)")
        
        sut.clear()
        sut.setOperand(2)
        sut.performOperation("㏑")
        sut.performOperation("㏑")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.366512920581664, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏑(㏑(2))")
        

        sut.performOperation("㏑")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏑(㏑(㏑(2)))")
        
        sut.setOperand(2)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("㏑")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏑(˗2)")
        
        sut.performOperation("e")
        sut.performOperation("㏑")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "㏑(e)")
    }
    
    func testLog10() {
        sut.setOperand(8)
        sut.performOperation("㏒₁₀")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.903089986991944, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒₁₀(8)")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.903089986991944, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒₁₀(8)")
        
        sut.setOperand(0)
        sut.performOperation("㏒₁₀")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏒₁₀(0)")
        
        sut.clear()
        sut.setOperand(2)
        sut.performOperation("㏒₁₀")
        sut.performOperation("㏒₁₀")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.521390227654325, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒₁₀(㏒₁₀(2))")
        

        sut.performOperation("㏒₁₀")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏒₁₀(㏒₁₀(㏒₁₀(2)))")
        
        sut.setOperand(2)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("㏒₁₀")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏒₁₀(˗2)")
        
        sut.performOperation("e")
        sut.performOperation("㏒₁₀")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.434294481903252, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒₁₀(e)")
        
        sut.setOperand(1)
        sut.performOperation("㏒₁₀")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "㏒₁₀(1)")
        
        sut.setOperand(10)
        sut.performOperation("㏒₁₀")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "㏒₁₀(10)")
    }
    
    func testLog2() {
        sut.setOperand(8)
        sut.performOperation("㏒₂")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 3)
        XCTAssertEqual(result.expressionString, "㏒₂(8)")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 3)
        XCTAssertEqual(result.expressionString, "㏒₂(8)")
        
        sut.setOperand(0)
        sut.performOperation("㏒₂")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏒₂(0)")
        
        sut.clear()
        sut.setOperand(3)
        sut.performOperation("㏒₂")
        sut.performOperation("㏒₂")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.664448707453889, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒₂(㏒₂(3))")
        

        sut.performOperation("㏒₂")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.589770260860788, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒₂(㏒₂(㏒₂(3)))")
        
        sut.setOperand(5)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("㏒₂")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "㏒₂(˗5)")
        
        sut.performOperation("e")
        sut.performOperation("㏒₂")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.442695040888963, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "㏒₂(e)")
        
        sut.setOperand(1)
        sut.performOperation("㏒₂")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0)
        XCTAssertEqual(result.expressionString, "㏒₂(1)")
        
        sut.setOperand(2)
        sut.performOperation("㏒₂")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "㏒₂(2)")
    }
    
    func testFactorial() {
        sut.setOperand(8)
        sut.performOperation("х!")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 40320)
        XCTAssertEqual(result.expressionString, "8!")
        
        sut.performOperation("х!")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "(8!)!")
        
        sut.setOperand(0)
        sut.performOperation("х!")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "0!")
        
        sut.clear()
        sut.setOperand(1)
        sut.performOperation("х!")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "1!")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1)
        XCTAssertEqual(result.expressionString, "1!")
        
        sut.performOperation("e")
        sut.performOperation("х!")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "e!")
        
        sut.setOperand(4)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("х!")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "(˗4)!")
    }
    
}
