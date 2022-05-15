//
//  GradientColors.swift
//  iosapp
//
//  Created by Никита Ткаченко on 24.04.2022.
//

import Foundation
import UIKit
typealias GradientColor = (firstColor: UIColor, secondColor: UIColor)

enum GradientColorForElements {
    case mainButton
    case phoneButton
    
    var firstColor: UIColor {
        return colors.firstColor
    }
    
    var secondColor: UIColor {
        return colors.secondColor
    }
    
    var colors: GradientColor {
        switch self {
        case .mainButton:
            return (
                UIColor(red: 226.0/255.0, green: 130.0/255.0, blue: 19.0/255.0, alpha: 1.0),
                UIColor(red: 255.0/255.0, green: 188.0/255.0, blue: 55.0/255.0, alpha: 1.0))
            
        case .phoneButton:
            return (
                UIColor(red: 11.0/255.0, green: 172.0/255.0, blue: 8.0/255.0, alpha: 1.0),
                UIColor(red: 29.0/255.0, green: 191.0/255.0, blue: 2.0/255.0, alpha: 1.0))
        }
    }
}
