//
//  NumberCruncher.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import Foundation

struct NumberCruncher {
    typealias NullaryFunction = (() -> (result: Double, stringResult: String))
    typealias UnaryMathFunction = ((_ operand: Double) -> Double)
    typealias UnaryStringFunction = ((_ operand: String) -> String)
    typealias UnaryValidationFunction = ((_ operand: Double) -> String?)
    typealias BinaryMathFunction = ((_ firstOperand: Double, _ secondOperand: Double) -> Double)
    typealias BinaryStringFunction = ((_ firstOperand: String, _ secondOperand: String) -> String)
    typealias BinaryValidationFunction = ((_ firstOperand: Double, _ secondOperand: Double) -> String?)
    typealias RepeatsOnEquals = Bool
    typealias Precedence = Int
    
    private enum ExpressionElement {
        case operand(Double)
        case operation(String)
    }
    
    private enum Operation {
        case constant(Double)
        case nullary(NullaryFunction)
        case unary(UnaryMathFunction, UnaryStringFunction?, UnaryValidationFunction?, RepeatsOnEquals)
        case binary (BinaryMathFunction, BinaryStringFunction?, BinaryValidationFunction?, Precedence, RepeatsOnEquals)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let mathFunction: BinaryMathFunction
        var stringFunction: BinaryStringFunction
        let firstOperand: Double
        var firstOperandString: String
        var validation: BinaryValidationFunction?
        var prevPrecedence: Int
        var precedence: Int
        
        func performMath(with secondOperand: Double) -> Double {
            return mathFunction(firstOperand, secondOperand)
        }
        
        func performString(with secondStringOperand: String) -> String {
            var newStringOp = firstOperandString
            if prevPrecedence < precedence {
                newStringOp = "(\(newStringOp))"
            }
            return stringFunction(newStringOp, secondStringOperand)
        }
        
        func validate(with secondOperand: Double) -> String? {
            guard let validation = validation else { return nil }
            return validation(firstOperand, secondOperand)
        }
    }
    
    private var expressionStack = [ExpressionElement]()
    private var operationsDict = [
        "Rand": Operation.nullary({
            return (Double(arc4random())/Double(UInt32.max), "RAND")
        }),
        "ᐩ/˗": Operation.unary({-$0}, {"˗(\($0))"}, nil, false),
        "%": Operation.unary({$0 / 100}, {"\($0)%"}, nil, false),
        "х²": Operation.unary({$0 * $0}, { "\($0)²"}, nil, true),
        "÷": Operation.binary({ $0/$1 }, nil, { $1 == 0 ? "Error" : nil }, 1, true),
        "=": Operation.equals
    ]
    
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
    
    func evaluate() -> (result: Double?, isPending: Bool, expressionString: String, error: String?) {
        var cache: (accumulator: Double?, expressionAccumulator: String?) {
            didSet {
                print("STEVE: cache \(cache.accumulator)")
            }
        }
        var error: String?
        var prevPrecedence = Int.max
        var operationOfRecordKey: String?
        var operandOfRecord: String?
        var pbo: PendingBinaryOperation?
        
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
                operandOfRecord = cache.expressionAccumulator
                prevPrecedence = Int.max
            }
        }
        
        func performOperation(_ symbol: String) {
            if let operation = operationsDict[symbol] {
                error = nil
                switch operation {
                case .constant(let value):
                    cache = (accumulator: value, expressionAccumulator: symbol)
                    
                case .nullary(let nullaryFunction):
                    let function = nullaryFunction()
                    cache = (accumulator: function.result, expressionAccumulator: function.stringResult)
                    
                case .unary(let mathFunction, var stringFunction, let validationFunction, let repeats):
                    if let accumulator = cache.accumulator {
                        error = validationFunction?(accumulator)
                        cache.accumulator = mathFunction(accumulator)
                        if repeats {
                            operationOfRecordKey = symbol
                        }
                        if stringFunction == nil {
                            stringFunction = { "\(symbol)(\($0))" }
                        }
                        cache.expressionAccumulator = stringFunction!(cache.expressionAccumulator!)
                    }
                    
                case .binary(let mathFunction, var stringFunction, let validationFunction, let precedence, let repeats):
                    performPendingBinaryOperation()
                    if let accumulator = cache.accumulator {
                        if repeats {
                            operationOfRecordKey = symbol
                        }
                        if stringFunction == nil {
                            stringFunction = { "\($0)\(symbol)\($1)" }
                        }
                        pbo = PendingBinaryOperation(mathFunction: mathFunction,
                                                     stringFunction: stringFunction!,
                                                     firstOperand: accumulator,
                                                     firstOperandString: cache.expressionAccumulator!,
                                                     validation: validationFunction,
                                                     prevPrecedence: prevPrecedence,
                                                     precedence: precedence)
                        cache = (nil, nil)
                    }
                    
                case .equals:
                    if let operationSymbol = operationOfRecordKey, let operation = operationsDict[operationSymbol] {
                        switch  operation {
                        case .unary(_, _, _, _):
                            performOperation(operationSymbol)
                        case .binary(let mathFunction, var stringFunction, let validation, let precedence, _):
                            if let accumulator = cache.accumulator, pbo == nil {
                                if stringFunction == nil {
//                                    stringFunction = { "\($0)\(operationSymbol)\($1)" }
                                    stringFunction = { (op1, op2) in
                                        return "\(op2)\(operationSymbol)\(operandOfRecord!)"
                                    }
                                }
                                print("STEVE: \(cache.expressionAccumulator!), \(result!)")
                                pbo = PendingBinaryOperation(mathFunction: mathFunction,
                                                             stringFunction: stringFunction!,
                                                             firstOperand: accumulator,
                                                             firstOperandString: cache.expressionAccumulator!,
                                                             validation: validation,
                                                             prevPrecedence: prevPrecedence,
                                                             precedence: precedence)
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
            if let pb = pbo, let accumulator = cache.accumulator, let exp = cache.expressionAccumulator {
                //run the math and string functions, update cache
                error = pb.validate(with: accumulator)
                cache.accumulator = pb.performMath(with: accumulator)
                cache.expressionAccumulator = pb.performString(with: exp)
                prevPrecedence = pb.precedence
                pbo = nil
            }
        }
    
        //MARK: EVALUATE()
        guard !expressionStack.isEmpty else { return (result: nil, isPending: false, expressionString: "", error: nil) }
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
        return (result, resultIsPending, expressionString ?? "", error)
        //

    }
    

    
//    private typealias Tally = (Double, String)
//    private typealias Precedence = Int
//    private typealias IsCommutative = Bool
//    private enum Operation {
//        case constant(Double)
//        case unary((Tally) -> Tally)
//        case binary(Precedence, IsCommutative, (Tally, Double) -> Tally)
//        case equals
//    }
//
//    private struct PendingBinaryOperation {
//        let f: (Tally, Double) -> Tally
//        let lhs: Tally
//
//        func perform(with rhs: Double) -> Tally {
//            return f(lhs, rhs)
//        }
//    }
//
//    var result: Double? {
//        get {
//            return tally?.value
//        }
//    }
//
//    var equation: String? {
//        get {
//            return tally?.expression
//        }
//    }
//
//    private var tally: (value:Double, expression:String)?
//    private var pendingBinaryOperation: PendingBinaryOperation?
//    private var operationsDict = [
//        "ᐩ/˗": Operation.unary({ (-$0.0, self.pendingBinaryOperation == nil &&  "˗\($0.1)") }), //TODO: parenthesis depends on if contains binary operation
//        "%": Operation.unary({ ($0.0 / 100.0, "(\($0.1))%") }), //TODO: parenthesis depends on if contains binary operation
//        "÷": Operation.binary(2, false, { ($0.0 / $1, "\($0.1)÷" + DisplayNumberFormatter.formatter.string(from: NSNumber(value: $1))!) }),
////        "×": Operation.binary({ $0 * $1 }),
////        "−": Operation.binary({ $0 - $1 }),
////        "+": Operation.binary({ $0 + $1 }),
//        "=": Operation.equals //TODO: add "=" in UI (not in number cruncher tally)
//    ]
//
//    mutating func setOperand(_ value: Double) {
//        let string = DisplayNumberFormatter.formatter.string(from: NSNumber(value: value))!
//        let newExpression: String = tally?.expression ?? "" + string
//        tally = (value, newExpression)
//    }
//
//    mutating func performOperation(_ symbol: String) {
//        if let operation = operationsDict[symbol] {
//            switch operation {
//            case .unary(let function):
//                if let tally = tally {
//                    self.tally = function(tally)
//                }
//            case .binary(_, _, let function):
//                if let tally = tally {
//                    pendingBinaryOperation = PendingBinaryOperation(f: function, lhs: tally)
//                }
//            case .equals:
//                performPendingBinaryOperation()
//            default:
//                break
//            }
//        }
//    }
//
//    mutating func performPendingBinaryOperation() {
//        if let pbo = pendingBinaryOperation, let tally = tally {
//            self.tally = pbo.perform(with: tally.value)
//            pendingBinaryOperation = nil
//        }
//    }
    
}
