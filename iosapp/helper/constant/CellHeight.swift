//
//  CellHeght.swift
//  iosapp
//
//  Created by alexander on 08.05.2022.
//

import Foundation

import Foundation
import UIKit
enum CellHeight {
    case filterCellTextPicker
    case filterCellDatePicker
    case parameterCell
    case subCategoryCell
    case favoriteTypeCell

    var height: CGFloat {
        switch self {
        case .filterCellTextPicker: return 50.0
        case .filterCellDatePicker: return 120.0
        case .parameterCell: return 40.0
        case .subCategoryCell: return 100.0
        case .favoriteTypeCell: return 40.0
        }
    }
}
