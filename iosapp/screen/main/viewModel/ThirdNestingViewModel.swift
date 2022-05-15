//
//  ThirdNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation

import Foundation
import RxRelay
import RemoteDataService

protocol ThirdNestingViewModelHeader: NestingViewModelBase {
    func selectParameterAt(index: Int)
}

class ThirdNestingViewModel: NestingViewModel, ThirdNestingViewModelHeader {
    var selectedParameter = PublishRelay<LotParameter>()

    override init(_ lotRepository: LotRepository) {
        super.init(lotRepository)
    }

    func getParameters(subCategory: Category) {
        lotRepository.getLotParameters(categoryId: subCategory.id) { res in
            guard let response = res as? SuccessResponse<FailableCodableArray<LotParameter>> else {
                return
            }

            var parameters = response.data.elements
            parameters = parameters.sorted(by: { $0.name < $1.name })
            parameters = parameters.map { parameter in
                LotParameter(
                    id: parameter.id,
                    name: parameter.name,
                    type: parameter.type,
                    isRequired: parameter.isRequired,
                    values: parameter.values,
                    choosenValues: []
                )
            }

            let oldFilter = self.filter.value
            let newFilter = FilterModel(
                sortingType: oldFilter.sortingType,
                category: oldFilter.category,
                subCategory: oldFilter.subCategory,
                parameters: parameters
            )
            self.filter.accept(newFilter)
        }
    }

    func selectParameterAt(index: Int) {
        let parameter = filter.value.parameters[index]
        selectedParameter.accept(parameter)
    }
}
