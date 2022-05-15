//
//  FavoriteRepository.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import RemoteDataService

class FavoriteRepository {

    func updateLotFavoriteStatus(
        lotId: Int,
        newValue: Bool,
        callback: @escaping (Response) -> Void
    ) {

        let url = "\(RemoteDataConstant.BASE_URL)/api/favorites/lots/\(lotId)"
        if newValue {
            //true
            RemoteDataService.post(dataType: Nothing.self, url: url, callback: callback)
        } else {
            RemoteDataService.delete(dataType: Nothing.self, url: url, callback: callback)
        }
    }

    func getFavoriteLots(
        category: Category,
        callback: @escaping (Response) -> Void
    ) {
        let categoryId = CategoryType.animal.rawValue == category.name ? "animals" : "goods"

        let url = "\(RemoteDataConstant.BASE_URL)/api/favorites/\(categoryId)"
        RemoteDataService.get(url: url, dataType: FailableCodableArray<KostulyMiniLot>.self, callback: callback)
    }
}
