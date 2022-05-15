//
//  PresentModeType.swift
//  iosapp
//
//  Created by alexander on 02.05.2022.
//

import Foundation
import UIKit

enum PresentModeType: String, CaseIterable {
    case grid
    case table

    var buttonImage: UIImage {
        switch self {
        case .table: return  #imageLiteral(resourceName: "table_icon")
        case .grid: return #imageLiteral(resourceName: "grid_icon")
        }
    }

    static func parseByImage(image: UIImage) -> PresentModeType {
        switch image {
        case #imageLiteral(resourceName: "table_icon"): return .table
        case #imageLiteral(resourceName: "grid_icon"): return .grid
        default:
            break
        }
        return .grid
    }
    
    mutating func toggle() {
        switch self {
        case .grid:
            self = .table
        case .table:
            self = .grid
        }
    }
}
