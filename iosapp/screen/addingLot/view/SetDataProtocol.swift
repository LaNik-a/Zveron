//
//  SetDataProtocol.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import Foundation

protocol SetDataProtocol {
    func setUpData(data: [TableInfo], lot: Lot, parameters: [LotParameter])
}
