//
//  SortingType.swift
//  iosapp
//
//  Created by alexander on 02.05.2022.
//

import Foundation

public enum SortingType: String, CaseIterable {
    case popularity = "Популярные"
    case cheap = "Дешевые"
    case expensive = "Дорогие"
    case near = "Рядом с вами"
    case sellerRating = "С высоким рейтингом"

    static func parseType(_ name: String) -> SortingType {
        guard let type = SortingType.init(rawValue: name) else {
            fatalError("")
        }
        return type
    }
}
