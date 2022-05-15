//
//  NavigationItem.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import Foundation
import UIKit

enum NavigationButton {
    case back
    case close
    
    private var closeButton: UIButton {
        let closeButton = UIButton(type: .system)
        let closeIcon = #imageLiteral(resourceName: "close_icon")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = .black
        return closeButton
    }
    
    private var backButton: UIButton {
        let backButton = UIButton(type: .system)
        let backIcon = #imageLiteral(resourceName: "back_icon")
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = .black
        return backButton
    }

    var button: UIButton {
        switch self {
        case .back: return backButton
        case .close: return closeButton
        }
    }
}
