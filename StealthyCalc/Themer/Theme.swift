//
//  Constants.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/5/21.
//

import UIKit

enum CalcTheme: ThemeProtocol {
    case classic, iOS
    
    var settings: ThemeSettings {
        switch self {
        case .classic:
            return ThemeSettings.classicTheme
        default:
            return ThemeSettings.classicTheme //won't be needed later
        }
    }
}

struct ThemeSettings: ThemeModelProtocol {
    let digitButtonColor: UIColor
    let operationButtonColor: UIColor
    let equalsButtonColor: UIColor
    let clearButtonColor: UIColor
    let buttonTextColor: UIColor
    let caseColor: UIColor
    let numberPadColor: UIColor
    let displayColor: UIColor
    let displayTextColor: UIColor
    let buttonCornerRadius: CGFloat
    
    static let classicTheme = ThemeSettings(
        digitButtonColor: UIColor(named: "ClassicWhite")!,
        operationButtonColor: UIColor(named: "ClassicTan")!,
        equalsButtonColor: UIColor(named: "ClassicOrange")!,
        clearButtonColor: UIColor(named: "ClassicTan")!,
        buttonTextColor: UIColor(named: "ClassicBlack")!,
        caseColor: UIColor(named: "ClassicTan")!,
        numberPadColor: UIColor(named: "ClassicBlack")!,
        displayColor: UIColor(named: "ClassicRedBlack")!,
        displayTextColor: UIColor(named: "ClassicRed")!,
        buttonCornerRadius: 5
    )
}

extension Themer where Theme == CalcTheme {
    private static var instance: Themer?
    static var shared: Themer? {
        if instance == nil {
            instance = Themer(defaultTheme: .classic)
        }
        return instance!
    }
}
