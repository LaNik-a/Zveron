//
//  SecondNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxRelay
import RemoteDataService

protocol SecondNestingViewModelHeader: NestingViewModelBase {
    var needShowAllSubCategories: PublishRelay<Void?> { get }
    var subCategories: BehaviorRelay<[Category]> { get }
    func selectSubCategoryAt(index: Int)
}

class SecondNestingViewModel: NestingViewModel, SecondNestingViewModelHeader {

    let needShowAllSubCategories = PublishRelay<Void?>()
    let selectedSubCategory = PublishRelay<Category>()
    let subCategories = BehaviorRelay<[Category]>(value: [])

    private let categoryRepository: CategoryRepository
    init(_ lotRepository: LotRepository, _ categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
        super.init(lotRepository)
    }

    func selectSubCategoryAt(index: Int) {
        let subCategory = subCategories.value[index]
        selectedSubCategory.accept(subCategory)
    }

    func getSubCategories(category: Category) {
        categoryRepository.getSubCategories(categoryId: category.id) { res in
            guard let response = res as? SuccessResponse<FailableCodableArray<Category>> else {
                return
            }
            let subCategories = response.data.elements
            self.subCategories.accept(subCategories.sorted(by: { $0.id < $1.id }))
        }
    }
}
