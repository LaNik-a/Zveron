//
//  KostulyMiniLot.swift
//  iosapp
//
//  Created by alexander on 10.05.2022.
//

import Foundation

public struct KostulyMiniLot: Codable {
    let id: Int
    let title: String
    let price: Int?
    let dateOfPublication: String
    let status: String
    let firstImageId: Int
    let inFavorites: Bool
}
