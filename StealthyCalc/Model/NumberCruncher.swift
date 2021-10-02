//
//  NumberCruncher.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import Foundation

struct CalculatedResult {
    var result: Double? = nil
    var resultIsPending: Bool = false
    var negativeIsPending: Bool = false
    var expressionString: String = ""
    var error: CalculationError? = nil
}

enum CalculationError: Error {
    case notANumber
    case infinite
    case unaccountedFor
}

struct NumberCruncher {
    typealias NullaryFunction = (() -> (result: Double, stringResult: String))
    typealias UnaryMathFunction = ((_ operand: Double) -> Double)
    typealias UnaryStringFunction = ((_ operand: String) -> String)
    typealias BinaryMathFunction = ((_ firstOperand: Double, _ secondOperand: Double) -> Double)
    typealias BinaryStringFunction = ((_ firstOperand: String, _ secondOperand: String) -> String)
    typealias RepeatsOnEquals = Bool
    typealias Precedence = Int
    
    private enum ExpressionElement {
        case operand(Double)
        case operation(String)
    }
    
    private enum Operation {
        case constant(Double)
        case nullary(NullaryFunction)
        case unary(UnaryMathFunction, UnaryStringFunction, UnaryStringFunction?, RepeatsOnEquals)
        case binary (BinaryMathFunction, BinaryStringFunction, Precedence, RepeatsOnEquals)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let mathFunction: BinaryMathFunction
        var stringFunction: BinaryStringFunction
        let firstOperand: Double
        var firstOperandString: String
        var prevPrecedence: Int
        var precedence: Int
        
        func performMath(with secondOperand: Double) throws -> Double {
            let result = mathFunction(firstOperand, secondOperand)
            
            if result.isInfinite {
                throw CalculationError.infinite
            }
            if result.isNaN {
                throw CalculationError.notANumber
            }
            
            return result
        }
        
        func performString(with secondStringOperand: String) -> String {
            var newStringOp = firstOperandString
//            if prevPrecedence < precedence {
//                newStringOp = "(\(newStringOp))"
//            }
            return stringFunction(newStringOp, secondStringOperand)
        }
    }
    
    private var expressionStack = [ExpressionElement]()
    private var operationsDict = [
        "Rand": Operation.nullary({
            return (Double(arc4random())/Double(UInt32.max), "RAND")
        }),
        //
        "e": Operation.constant(M_E),
        "π": Operation.constant(Double.pi),
        //
        "ᐩ/˗": Operation.unary({ -$0 }, { "˗(\($0))" },  { "˗\($0)" }, false),
        "%": Operation.unary({ $0 / 100 },  { "(\($0))%" }, { "\($0)%" }, false),
        "х²": Operation.unary({ $0 * $0 }, { "(\($0))²" }, { "\($0)²" }, true),
        "х³": Operation.unary({ $0 * $0 * $0 }, { "(\($0))³"}, { "\($0)³" }, true),
        "eˣ": Operation.unary({ pow(M_E, $0) }, { "e^(\($0))" }, { "e^\($0)" }, false),
        "10ˣ": Operation.unary({ pow(10, $0) }, { "10^(\($0))" }, {"10^\($0)" }, false),
        "2ˣ": Operation.unary({ pow(2, $0) }, { "2^(\($0))" }, { "2^\($0)" }, false),
        "¹/ₓ": Operation.unary({ 1/$0 }, { "(\($0))⁻¹" }, { "\($0)⁻¹" }, false),
        "²√ₓ": Operation.unary({ sqrt($0) }, { "√(\($0))" }, { "√\($0)" }, true),
        "³√ₓ": Operation.unary({ $0 < 0 ? -pow(-$0, 1/3) : pow($0, 1/3) }, { "³√(\($0))" }, { "³√\($0)" }, true),
        "㏑": Operation.unary({ log($0) } , { "㏑(\($0))" }, nil, false),
        "㏒₁₀": Operation.unary({ log10($0) }, { "㏒₁₀(\($0))" }, nil, false),
        "㏒₂": Operation.unary({ log2($0) }, { "㏒₂(\($0))" }, nil, false),
        "х!": Operation.unary({ op in
            guard let i = Int(exactly: op), i >= 0 else { return Double.nan}
            if i == 0 { return 1 }
            return (1...i).map(Double.init).reduce(1.0, *)
        }, { "(\($0))!" }, {"\($0)!" }, false),
        //RADIANS
        "sinRAD": Operation.unary({ sin($0).roundTo15Places() }, { "sin(\($0))" }, nil, false),
        "cosRAD": Operation.unary({ cos($0).roundTo15Places() }, { "cos(\($0))" }, nil, false),
        "tanRAD": Operation.unary({ sin($0).roundTo15Places()/cos($0).roundTo15Places() }, { "tan(\($0))" }, nil, false),
        "sin⁻¹RAD": Operation.unary({ asin($0) }, { "sin⁻¹(\($0))"}, nil, false),
        "cos⁻¹RAD": Operation.unary({ acos($0) }, { "cos⁻¹(\($0))"}, nil, false),
        "tan⁻¹RAD": Operation.unary({ atan($0) }, { "tan⁻¹(\($0))"}, nil, false),
        "sinh": Operation.unary({ sinh($0) }, { "sinh(\($0))" }, nil, false),
        "cosh": Operation.unary({ cosh($0) }, { "cosh(\($0))" }, nil, false),
        "tanh": Operation.unary({ tanh($0) }, { "tanh(\($0))" }, nil, false),
        "sinh⁻¹": Operation.unary({ asinh($0) }, { "sinh⁻¹(\($0))"}, nil, false),
        "cosh⁻¹": Operation.unary({ acosh($0) }, { "cosh⁻¹(\($0))"}, nil, false),
        "tanh⁻¹": Operation.unary({ atanh($0) }, { "tanh⁻¹(\($0))"}, nil, false),
        //DEGREES
        "sin": Operation.unary({ sin($0*Double.pi/180) }, { "sin(\($0)°)" }, nil, false),
        "cos": Operation.unary({ cos($0*Double.pi/180) }, { "cos(\($0)°)" }, nil, false),
        "tan": Operation.unary({ __sinpi($0/180)/__cospi($0/180) }, { "tan(\($0)°)" }, nil, false),
        "sin⁻¹": Operation.unary({ asin($0)/Double.pi*180 }, { "sin⁻¹(\($0))"}, nil, false),
        "cos⁻¹": Operation.unary({ acos($0)/Double.pi*180 }, { "cos⁻¹(\($0))"}, nil, false),
        "tan⁻¹": Operation.unary({ atan($0)/Double.pi*180 }, { "tan⁻¹(\($0))"}, nil, false),
        //
        "ʸ√ₓ": Operation.binary({ x, y in
            if x < 0 && abs(y.truncatingRemainder(dividingBy: 2)) == 1 {
                //odd root of a negative number
                return -pow(-x, 1/y)
            }
            return pow(x, 1/y)
        }, { "\($0)^(1/\($1))" }, 2, true),
        "xʸ": Operation.binary({ pow($0, $1) }, { "\($0)^\($1)" }, 2, true),
        "yˣ": Operation.binary({ pow($1, $0) }, { "\($1)^\($0)" }, 2, true),
        "㏒ₓ": Operation.binary({ log($0)/log($1) }, { x, y in
            switch (x.isJustANumber, y.isJustANumber) {
            case (true, true): return "㏒\(y)(\(x))"
            case (false, true): return "㏒\(y)\(x)" // x will have "()" applied later anyway
            case (true, false): return "㏑(\(x))/㏑\(y)" // y will have "()" applied later anyway
            case (false, false): return "㏑\(x)/㏑\(y)" // both will have "()" applied later anyway
            }
        }, 2, true), //should be log(y) {$1.isJustANumber ? "㏒\($1)(\($0))" : "㏑(\($0))/㏑(\($1))"}
        "EE": Operation.binary({ pow(10, $1)*$0 }, {"\($0)e\($1)"}, 2, true),
        "÷": Operation.binary({ $0/$1 }, { "\($0)÷\($1)" }, 1, true),
        "×": Operation.binary({ $0*$1 }, { "\($0)×\($1)" }, 1, true),
        "−": Operation.binary({ $0-$1 }, { "\($0)−\($1)" }, 0, true),
        "+": Operation.binary({ $0+$1 }, { "\($0)+\($1)" }, 0, true),
        "=": Operation.equals
    ]
    #warning("change signs to better match iOS calculator, fix log(x/y)")
    #warning("Add parenthesis")
    #warning("Test clear and defined operations, add AC") //7
    #warning("Integration Testing for Memory") //8
    #warning("Unary functions with no input (operand of 0) not working")
    #warning("Precedence not working") //6
    
    mutating func setOperand(_ operand: Double) {
        expressionStack.append(ExpressionElement.operand(operand))
    }
    
    mutating func performOperation(_ symbol: String) {
        expressionStack.append(ExpressionElement.operation(symbol))
    }
    
    mutating func clear() {
        expressionStack.removeAll()
    }
    
    mutating func undo() {
        if !expressionStack.isEmpty {
            expressionStack.removeLast()
        }
    }
    
    func evaluate() -> CalculatedResult {
        var cache: (accumulator: Double?, expressionAccumulator: String?)
        var err: CalculationError?
        var prevPrecedence = Int.max
        var operationOfRecord: (symbol: String, operand: Double?)?
        var pbo: PendingBinaryOperation?
        var negativeIsPending = false //added to support backwards entry (e.g. tap "-" then "6" is the same as tap "6" then "-")
        
        var expressionString: String? {
            get {
                if pbo == nil {
                    return cache.expressionAccumulator
                } else {
                    return pbo!.stringFunction(pbo!.firstOperandString, cache.expressionAccumulator ?? "")
                }
            }
        }
        
        var result: Double? {
            get {
                return cache.accumulator
            }
        }
        
        var resultIsPending: Bool {
            get {
                return pbo != nil
            }
        }
        
        func setOperand(_ operand: Double) {
            cache.accumulator = operand
            if let value = cache.accumulator {
                cache.expressionAccumulator = DisplayNumberFormatter.formatter.string(from: NSNumber(value: value)) ?? ""
                prevPrecedence = Int.max
            }
        }
        
        func performOperation(_ symbol: String) {
            if let operation = operationsDict[symbol] {
                err = nil
                switch operation {
                case .constant(let value):
                    cache = (accumulator: value, expressionAccumulator: symbol)
                    
                case .nullary(let nullaryFunction):
                    let function = nullaryFunction()
                    cache = (accumulator: function.result, expressionAccumulator: function.stringResult)
                    
                case .unary(let mathFunction, let complexStringFunction, let simpleStringFunction, let repeats):
                    if let accumulator = cache.accumulator {
                        let mathResult = mathFunction(accumulator)
                        if mathResult.isInfinite {
                            err = CalculationError.infinite
                        } else if mathResult.isNaN {
                            err = CalculationError.notANumber
                        } else {
                            cache.accumulator = mathResult
                        }
                        
                        if repeats {
                            operationOfRecord = (symbol, nil)
                        }
                        var stringFunction: UnaryStringFunction {
                        //decide which string function to use based on if exp accumulator is a simply a number or a more complex expression
                            guard simpleStringFunction != nil else { return complexStringFunction }
                            return cache.expressionAccumulator!.isJustANumber ? simpleStringFunction! : complexStringFunction
                        }
                        cache.expressionAccumulator = stringFunction(cache.expressionAccumulator!)
                    } else if symbol == "ᐩ/˗" {
                        negativeIsPending = !negativeIsPending
                        cache.accumulator = 0
                        cache.expressionAccumulator = "0"
                    }
                    
                case .binary(let mathFunction, let basicStringFunction, let precedence, let repeats):
                    performPendingBinaryOperation()
                    if let accumulator = cache.accumulator {
                        let stringFunction: BinaryStringFunction = { x, y in
                            //put parentheses around complex expressions, leave simple numbers alone
                            let _x = x.isJustANumber ? x : "(\(x))"
                            let _y = y.isJustANumber ? y : "(\(y))"
                            return basicStringFunction(_x, _y)
                        }
                        pbo = PendingBinaryOperation(mathFunction: mathFunction,
                                                     stringFunction: stringFunction,
                                                     firstOperand: accumulator,
                                                     firstOperandString: cache.expressionAccumulator!,
                                                     prevPrecedence: prevPrecedence,
                                                     precedence: precedence)
                        if repeats {
                            operationOfRecord = (symbol, nil)
                        }
                        cache = (nil, nil)
                    }
                    
                case .equals:
                    if let opOfRecord = operationOfRecord,
                       let op = operationsDict[opOfRecord.symbol] {
                        switch op {
                        case .unary(_, _, _, _):
                            performOperation(opOfRecord.symbol)
                        case .binary(let math, let string, let prec, _):
                            let stringFunction: BinaryStringFunction = { x, y in
                                //put parentheses around complex expressions, leave simple numbers alone
                                let _x = x.isJustANumber ? x : "(\(x))"
                                let _y = y.isJustANumber ? y : "(\(y))"
                                return string(_x, _y)
                            }
                            if let firstOperand = cache.accumulator,
                               let firstOperandString = cache.expressionAccumulator,
                               let secondOperand = opOfRecord.operand {
                                let pb = PendingBinaryOperation(
                                    mathFunction: math,
                                    stringFunction: stringFunction,
                                    firstOperand: firstOperand,
                                    firstOperandString: firstOperandString,
                                    prevPrecedence: prevPrecedence,
                                    precedence: prec)
                                do {
                                    cache.accumulator = try pb.performMath(with: secondOperand)
                                } catch CalculationError.infinite {
                                    err = CalculationError.infinite
                                } catch CalculationError.notANumber {
                                    err = CalculationError.notANumber
                                } catch {
                                    err = CalculationError.unaccountedFor
                                }
                                
                                cache.expressionAccumulator = pb.performString(with: DisplayNumberFormatter.formatter.string(from: NSNumber(value: secondOperand)) ?? "")
                                prevPrecedence = pb.precedence
                            }
                        default:
                            break
                        }
                    }
                    performPendingBinaryOperation()
                }
            }
        }
        
        func performPendingBinaryOperation() {
            if negativeIsPending {
                performOperation("ᐩ/˗")
            }
            negativeIsPending = false
            if let pb = pbo, let accumulator = cache.accumulator, let exp = cache.expressionAccumulator {
                //run the math and string functions, update cache
                do {
                    cache.accumulator = try pb.performMath(with: accumulator)
                } catch CalculationError.infinite {
                    err = CalculationError.infinite
                } catch CalculationError.notANumber {
                    err = CalculationError.notANumber
                } catch {
                    err = CalculationError.unaccountedFor
                }
                cache.expressionAccumulator = pb.performString(with: exp)
                prevPrecedence = pb.precedence
                if let symbol = operationOfRecord?.symbol,
                   case let Operation.binary(_, _, _, repeats) = operationsDict[symbol]!,
                   repeats {
                    operationOfRecord?.operand = accumulator
                }
                pbo = nil
            }
        }
    
        //MARK: EVALUATE()
        guard !expressionStack.isEmpty else { return CalculatedResult() }
        prevPrecedence = Int.max
        pbo = nil
        for element in expressionStack {
            switch element {
            case .operand(let operand):
                setOperand(operand)
            case .operation(let operation):
                performOperation(operation)
            }
        }
        return CalculatedResult(result: result, resultIsPending: resultIsPending, negativeIsPending: negativeIsPending, expressionString: expressionString ?? "", error: err)
        //

    }
      
}

extension Double {
    func roundTo15Places() -> Double {
        let divisor = 1000000000000000.0
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    var isJustANumber: Bool {
        get {
            return Double(self) != nil || self == "e" || self == "π"
        }
    }
}
