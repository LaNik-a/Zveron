//
//  LotModel.swift
//  iosapp
//
//  Created by alexander on 01.05.2022.
//

import Foundation

public struct MiniLot: Codable {
    let id: Int
    let title: String
    let price: Int?
    let dateOfPublication: String
    let status: String?
    let firstImageId: Int
    let isFavoriteLot: Bool
}
