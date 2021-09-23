//
//  MemoryTally.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 9/21/21.
//

import Foundation

struct MemoryTally {
    
    private var current: Double?
    
    mutating func add(_ operand: Double) {
        current = (current ?? 0) + operand
        print("STEVE \(current!)")
    }
    
    mutating func subtract(_ operand: Double) {
        current = (current ?? 0) - operand
        print("STEVE \(current!)")
    }
    
    mutating func clear() {
        current = nil
        print("STEVE \(String(describing: current))")
    }
    
    func recall() -> Double? {
        print("STEVE \(String(describing: current))")
        return current
    }
}
