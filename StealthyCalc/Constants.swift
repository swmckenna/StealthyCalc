//
//  Constants.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/5/21.
//

import UIKit

enum DefaultKeys {
    static let theme = "THEME"
}

enum Theme: String {
    case classic, iOS
}

private struct ThemeSettings {
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
}


private let classicTheme = ThemeSettings(
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
