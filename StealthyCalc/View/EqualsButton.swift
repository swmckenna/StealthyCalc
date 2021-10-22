//
//  EqualsButton.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 10/21/21.
//

import UIKit

class EqualsButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
    }
    
    private func setUpButton() {
        Themer.shared?.register(target: self, action: EqualsButton.handleTheme(_:))
        clipsToBounds = true
    }
    
    private func handleTheme(_ theme: CalcTheme) {
        backgroundColor = theme.settings.equalsButtonColor
        setTitleColor(theme.settings.buttonTextColor, for: .normal)
        layer.cornerRadius = theme.settings.buttonCornerRadius
    }

}
