//
//  OperationButton.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 10/21/21.
//

import UIKit

class OperationButton: UIButton {
    
    @IBInspectable var useSecondaryColor: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
    }
    
    private func setUpButton() {
        Themer.shared?.register(target: self, action: OperationButton.handleTheme(_:))
        clipsToBounds = true
    }
    
    private func handleTheme(_ theme: CalcTheme) {
        backgroundColor = useSecondaryColor ? theme.settings.clearButtonColor : theme.settings.operationButtonColor
        setTitleColor(theme.settings.buttonTextColor, for: .normal)
        titleLabel?.font = theme.settings.buttonFont
        layer.cornerRadius = theme.settings.buttonCornerRadius
    }
}
