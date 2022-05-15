//
//  NotifyingMaskedTextFieldDelegate.swift
//  iosapp
//
//  Created by alexander on 11.03.2022.
//

import Foundation
import UIKit
import InputMask

class NotifyingMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    weak var editingListener: NotifyingMaskedTextFieldDelegateListener?
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editingListener?.onEditingPhoneChanged(inTextField: textField)
    }
    
    override func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        defer {
            self.editingListener?.onEditingPhoneChanged(inTextField: textField)
        }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

protocol NotifyingMaskedTextFieldDelegateListener: AnyObject {
    func onEditingPhoneChanged(inTextField: UITextField)
}
