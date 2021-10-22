//
//  DigitButton.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/5/21.
//

import UIKit

class DigitButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
    }
    
    private func setUpButton() {
        Themer.shared?.register(target: self, action: DigitButton.handleTheme(_:))
        clipsToBounds = true
    }
    
    private func handleTheme(_ theme: CalcTheme) {
        backgroundColor = theme.settings.digitButtonColor
        setTitleColor(theme.settings.buttonTextColor, for: .normal)
        titleLabel?.font = theme.settings.buttonFont
        layer.cornerRadius = theme.settings.buttonCornerRadius
    }

}
