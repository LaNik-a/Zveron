//
//  CategoryType.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation

public enum CategoryType: String, CaseIterable {
    case animal = "Животные"
    case goods = "Товары"

    static func parseType(_ name: String) -> CategoryType {
        guard let type = CategoryType.init(rawValue: name) else {
            fatalError("")
        }
        return type
    }

    func getModel() -> Category {
        switch self {
        case .animal: return Category(id: 1, name: self.rawValue)
        case .goods: return Category(id: 2, name: self.rawValue)
        }
    }
}
