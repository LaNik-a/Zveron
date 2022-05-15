//
//  Gender.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

import Foundation
enum Gender: String {
    case MALE
    case FEMALE
    case METIS
    
    static func gender(id: Int) -> String? {
        switch id {
        case 0: return Gender.MALE.rawValue
        case 1: return Gender.FEMALE.rawValue
        default: return Gender.METIS.rawValue
        }
    }
}
