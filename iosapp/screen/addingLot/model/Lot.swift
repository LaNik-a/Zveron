//
//  Lot.swift
//  iosapp
//
//  Created by Никита Ткаченко on 04.05.2022.
//

import Foundation
import UIKit

struct Lot: Codable {
    var title: String?
    var description: String?
    var price: Int?
    var gender: String?
    var id_lot_form: Int?
    var id_category: Int?
    var address: Address?
    var contact: Contact?
    var parameters: [DopParamsLot]?
    var photos: [Photo]?
}
