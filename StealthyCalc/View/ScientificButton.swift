//
//  ScientificButton.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 9/19/21.
//

import UIKit

class ScientificButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
    }
    
    private func setUpButton() {
        Themer.shared?.register(target: self, action: ScientificButton.handleTheme(_:))
        clipsToBounds = true
    }
    
    private func handleTheme(_ theme: CalcTheme) {
        backgroundColor = theme.settings.digitButtonColor
        setTitleColor(theme.settings.buttonTextColor, for: .normal)
        layer.cornerRadius = theme.settings.buttonCornerRadius
    }

}
