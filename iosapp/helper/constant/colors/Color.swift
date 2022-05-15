//
//  Color.swift
//  iosapp
//
//  Created by Никита Ткаченко on 25.04.2022.
//

import Foundation
import UIKit

enum Color {
    case backgroundScreen
    case title
    case subTitle
    case inputDesc
    case tabBarTintColor
    case tabBarBarTintColor
    case imageBorder

    var color: UIColor {
        switch self {
        case .backgroundScreen: return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        case .title: return #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1058823529, alpha: 1)
        case .subTitle: return #colorLiteral(red: 0.4, green: 0.4039215686, blue: 0.4392156863, alpha: 1)
        case .inputDesc: return #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1)
        case .tabBarTintColor: return #colorLiteral(red: 0.8862745098, green: 0.5098039216, blue: 0.07058823529, alpha: 1)
        case .tabBarBarTintColor: return #colorLiteral(red: 0.7300779223, green: 0.7376068234, blue: 0.7575351596, alpha: 1)
        case .imageBorder: return #colorLiteral(red: 0.6745098039, green: 0.6823529412, blue: 0.7058823529, alpha: 1)
        }
    }
}
