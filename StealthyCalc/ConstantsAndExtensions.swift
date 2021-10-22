//
//  Constants.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/5/21.
//

import Foundation


enum DefaultKeys {
    static let theme = "THEME"
}

extension UserDefaults {
    @objc dynamic var theme: CalcTheme {
        get {
            return CalcTheme(rawValue: integer(forKey: DefaultKeys.theme)) ?? .classic
        }
        set {
            setValue(newValue.rawValue, forKey: DefaultKeys.theme)
        }
    }
}
