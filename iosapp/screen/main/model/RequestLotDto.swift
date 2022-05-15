//
//  RequestLotDto.swift
//  iosapp
//
//  Created by alexander on 02.05.2022.
//

import Foundation

struct RequestLotDto {
    let pageSize: Int
    var lotId: Int?
    var dateCreationLot: String?
    let filterModel: FilterModel
}
