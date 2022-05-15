//
//  FilterModel.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation

struct FilterModel {
    let sortingType: SortingType
    let category: Category?
    let subCategory: Category?
    let parameters: [LotParameter]

    init(
        sortingType: SortingType,
        category: Category? = nil,
        subCategory: Category? = nil,
        parameters: [LotParameter] = []
    ) {
        self.sortingType = sortingType
        self.category = category
        self.subCategory = subCategory
        self.parameters = parameters
    }

    func updateFields(
        sortingType: SortingType? = nil,
        category: Category? = nil,
        subCategory: Category? = nil,
        parameters: [LotParameter]? = nil
    ) -> FilterModel {
        let oldModel = self
        let newModel = FilterModel(
            sortingType: sortingType != nil ? sortingType! : oldModel.sortingType,
            category: category != nil ? category! : oldModel.category,
            subCategory: subCategory != nil ? subCategory! : oldModel.subCategory,
            parameters: parameters != nil ? parameters! : oldModel.parameters
        )

        return newModel
    }
}
