//
//  CategoryRepository.swift
//  iosapp
//
//  Created by alexander on 05.05.2022.
//

import Foundation
import RemoteDataService

class CategoryRepository {

   func getSubCategories(
    categoryId: Int,
    callback: @escaping (Response) -> Void
   ) {
       let url = "\(RemoteDataConstant.BASE_URL)/api/categories/\(categoryId)"
       RemoteDataService.get(url: url, dataType: FailableCodableArray<Category>.self, callback: callback)
   }
}
