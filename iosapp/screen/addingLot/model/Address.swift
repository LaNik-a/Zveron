//
//  Address.swift
//  iosapp
//
//  Created by Никита Ткаченко on 04.05.2022.
//

import Foundation

struct Address: Codable {
    let region: String
    let district: String
    let town: String
    let street: String
    let house: String
    let longitude: Double
    let latitude: Double
}
