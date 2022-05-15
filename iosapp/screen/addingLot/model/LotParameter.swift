//
//  LotParameter.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

import Foundation
struct LotParameter: Codable {
    let id: Int
    let name: String
    let type: String
    let isRequired: Bool
    // пока что из за того что так отдает бек
    let values: [String]?
    var choosenValues: [String]?
}
