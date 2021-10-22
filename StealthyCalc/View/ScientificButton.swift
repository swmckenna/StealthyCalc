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
    @IBInspectable var isReadyToShip: Bool = true
    #warning("Remove above var when parenthesis and memory functionality is added")

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
        backgroundColor = isReadyToShip ? theme.settings.scientificButtonColor : .clear
        setTitleColor(theme.settings.buttonTextColor, for: .normal)
        layer.cornerRadius = theme.settings.buttonCornerRadius
    }

}

class TrigButton: ScientificButton {
    
}
