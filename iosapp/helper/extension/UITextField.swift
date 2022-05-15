//
//  UITextField.swift
//  iosapp
//
//  Created by alexander on 29.04.2022.
//

import UIKit

extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        let icon = (isSecureTextEntry ? #imageLiteral(resourceName: "eye_off_icon") : #imageLiteral(resourceName: "eye_icon")).withTintColor(.orange)
        let alpha = isSecureTextEntry ? 0.5 : 1.0
        button.setImage(icon, for: .normal)
        button.alpha = alpha
    }
    
    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }

    @IBAction func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        if let existingText = text, isSecureTextEntry {
            deleteBackward()
            text = existingText
        }
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
        setPasswordToggleImage((sender as? UIButton)!)
    }
}
