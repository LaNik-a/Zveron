//
//  Seller.swift
//  iosapp
//
//  Created by Никита Ткаченко on 15.05.2022.
//

import Foundation
struct Seller: Codable {
    var id: Int
    var name: String
    var surname: String
    var rating: Int
    var online: Bool
    var dateOnline: String
}
