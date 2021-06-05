//
//  NumberCruncher.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import Foundation

struct NumberCruncher {
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let f: (Double, Double) -> Double
        let lhs: Double
        
        func perform(with rhs: Double) -> Double {
            return f(lhs, rhs)
        }
    }
    
    var result: Double? {
        get {
            return tally
        }
    }
    private var tally: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var operationsDict = [
        "ᐩ/˗": Operation.unary({ -$0}),
        "%": Operation.unary({$0 / 100.0}),
        "÷": Operation.binary({ $0 / $1 }),
        "×": Operation.binary({ $0 * $1 }),
        "−": Operation.binary({ $0 - $1 }),
        "+": Operation.binary({ $0 + $1 }),
        "=": Operation.equals
    ]
    
    mutating func setOperand(_ value: Double) {
        tally = value
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operationsDict[symbol] {
            switch operation {
            case .unary(let function):
                if let tally = tally {
                    self.tally = function(tally)
                }
            case .binary(let function):
                if let tally = tally {
                    pendingBinaryOperation = PendingBinaryOperation(f: function, lhs: tally)
                }
            case .equals:
                performPendingBinaryOperation()
            default:
                break
            }
        }
    }
    
    mutating func performPendingBinaryOperation() {
        if let pbo = pendingBinaryOperation, let tally = tally {
            self.tally = pbo.perform(with: tally)
            pendingBinaryOperation = nil
        }
    }
    
}
