//
//  Constants.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/5/21.
//

import UIKit

@objc enum CalcTheme: Int, ThemeProtocol {
    case classic, iOS
    
    var settings: ThemeSettings {
        switch self {
        case .classic:
            return ThemeSettings.classicTheme
        case .iOS:
            return ThemeSettings.iOSTheme
        }
    }
}

struct ThemeSettings: ThemeModelProtocol {
    let digitButtonColor: UIColor
    let scientificButtonColor: UIColor
    let operationButtonColor: UIColor
    let equalsButtonColor: UIColor
    let clearButtonColor: UIColor
    let buttonTextColor: UIColor
    let caseColor: UIColor
    let numberPadColor: UIColor
    let displayColor: UIColor
    let displayTextColor: UIColor
    let buttonCornerRadius: CGFloat
    var settingsButtonTint: UIColor
    let displayFontName: String
    let buttonFont: UIFont
    
    static let classicTheme = ThemeSettings(
        digitButtonColor: UIColor(named: "ClassicWhite")!,
        scientificButtonColor: UIColor(named: "ClassicKhaki")!,
        operationButtonColor: UIColor(named: "ClassicTan")!,
        equalsButtonColor: UIColor(named: "ClassicOrange")!,
        clearButtonColor: UIColor(named: "ClassicTan")!,
        buttonTextColor: UIColor(named: "ClassicBlack")!,
        caseColor: UIColor(named: "ClassicTan")!,
        numberPadColor: UIColor(named: "ClassicBlack")!,
        displayColor: UIColor(named: "ClassicRedBlack")!,
        displayTextColor: UIColor(named: "ClassicRed")!,
        buttonCornerRadius: 5,
        settingsButtonTint: UIColor(named: "ClassicWhite")!,
        displayFontName: Font.VT323,
        buttonFont: .systemFont(ofSize: 18)
    )
    
    static let iOSTheme = ThemeSettings(
        digitButtonColor: UIColor(named: "iOSGray")!,
        scientificButtonColor: UIColor(named: "iOSDarkGray")!,
        operationButtonColor: UIColor(named: "iOSOrange")!,
        equalsButtonColor: UIColor(named: "iOSOrange")!,
        clearButtonColor: UIColor(named: "iOSLightGray")!,
        buttonTextColor: UIColor(named: "iOSWhite")!,
        caseColor: UIColor(named: "iOSBlack")!,
        numberPadColor: UIColor(named: "iOSBlack")!,
        displayColor: UIColor(named: "iOSBlack")!,
        displayTextColor: UIColor(named: "iOSWhite")!,
        buttonCornerRadius: 15, //TODO: how to get this right? Probably callback.
        settingsButtonTint: .darkGray,
        displayFontName: Font.Helvetica,
        buttonFont: .systemFont(ofSize: 22)
    )
}

extension Themer where Theme == CalcTheme {
    private static var instance: Themer?
    static var shared: Themer? {
        if instance == nil {
            instance = Themer(defaultTheme: UserDefaults.standard.theme)
        }
        return instance!
    }
}
