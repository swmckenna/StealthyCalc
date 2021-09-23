//
//  ScientificButton.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 9/19/21.
//

import UIKit

class ScientificButton: UIButton {
    
    var defaultTitle: String!
    @IBInspectable var secondaryTitle: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
    }
    
    private func setUpButton() {
        defaultTitle = self.title(for: .normal)
        Themer.shared?.register(target: self, action: ScientificButton.handleTheme(_:))
        clipsToBounds = true
    }
    
    private func handleTheme(_ theme: CalcTheme) {
        backgroundColor = theme.settings.scientificButtonColor
        setTitleColor(theme.settings.buttonTextColor, for: .normal)
        layer.cornerRadius = theme.settings.buttonCornerRadius
    }

}

class TrigButton: ScientificButton {
    
}
