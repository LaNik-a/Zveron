//
//  CardLotPreview.swift
//  iosapp
//
//  Created by Никита Ткаченко on 15.05.2022.
//

import Foundation
import UIKit

struct CardLotPreview: Codable {
    var id: Int
    //var photos: [Photo]
    var title: String
    var gender: String
    //var address: Address
    var statics: Statics
    //var parameters: [DopParamsLot]
    var description: String
    //var seller: Seller
    var price: Int
    //var contact: ContactWays
    var isFavoriteLot: Bool
    var isOwnLot: Bool
    var canAddReview: Bool
    
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case photos
//        case title
//        case gender
//        case address
//        case statics
//        case parameters
//        case description
//        case seller
//        case price
//        case contact
//        case isFavoriteLot
//        case isOwnLot
//        case canAddReview
//    }
}

