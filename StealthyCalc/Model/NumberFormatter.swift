//
//  NumberFormatter.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/19/21.
//

import Foundation

class DisplayNumberFormatter: NumberFormatter {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        self.locale = NSLocale.current
        self.numberStyle = .decimal
        self.maximumFractionDigits = 10
        self.notANumberSymbol = "Error"
        self.groupingSeparator = ","
    }
    
    static var formatter = DisplayNumberFormatter()
}
