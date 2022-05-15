//
//  FilterViewModel.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RemoteDataService

class FilterViewModel: ViewModel {
    let disposeBag: DisposeBag = DisposeBag()
    let needPresentPickerForSubCategory = PublishRelay<[Category]>()
    let needPresentPickerForParameter = PublishRelay<LotParameter>()

    var parameters = BehaviorRelay<[LotParameter]>(value: [])
    let selectedSubCategory = BehaviorRelay<Category?>(value: nil)
    var stashedSubCategories: [Category] = []
    let selectedCategory = BehaviorRelay<Category?>(value: nil)



    let sortingMode = BehaviorRelay<SortingType?>(value: nil)
    let presentationMode = BehaviorRelay<PresentModeType>(value: .table)


    let parametersSectionHeight = BehaviorRelay<CGFloat>(value: 0.0)



    var previousSubCategory: Category?

    private let lotRepository: LotRepository
    private let categoryRepository: CategoryRepository
    init(_ lotRepository: LotRepository, _ categoryRepository: CategoryRepository) {
        self.lotRepository = lotRepository
        self.categoryRepository = categoryRepository

        // если указана категория, то загружаем подкатегории
        // и удаляем параметры, если они были указаны
        selectedCategory.bind {
            self.selectedSubCategory.accept(nil)
            self.parameters.accept([])
            self.loadSubCategoriesByCategory($0)
        }.disposed(by: disposeBag)

        selectedSubCategory.bind {
            if self.previousSubCategory != nil {
                self.parameters.accept([])
            }
            self.previousSubCategory = $0
            self.loadParametersBySubCategory($0)
        }.disposed(by: disposeBag)

        Observable.combineLatest(selectedCategory, parameters) { category, parameters in
            var height = 0.0

            if category != nil { height += CellHeight.filterCellTextPicker.height }

            parameters.forEach {
                height += $0.type == "string" ? CellHeight.filterCellTextPicker.height :
                CellHeight.filterCellDatePicker.height
            }

            return height
        }.bind(to: parametersSectionHeight).disposed(by: disposeBag)
    }

    func selectedParameterAt(index: Int) {
        // был произведен клик по подкатегории
        if index == 0 {
            guard !stashedSubCategories.isEmpty else { return }
            needPresentPickerForSubCategory.accept(stashedSubCategories)
        } else {
            let param = parameters.value[index-1]
            guard param.type == "string" else { return }
            needPresentPickerForParameter.accept(param)
        }
    }

    private func loadSubCategoriesByCategory(_ category: Category?) {
        print("term to load subcategories")
        guard category != nil else { return }

        categoryRepository.getSubCategories(categoryId: category!.id) { res in
            guard let response = res as? SuccessResponse<FailableCodableArray<Category>> else {
                return
            }
            let subCategories = response.data.elements
            self.stashedSubCategories = subCategories.sorted(by: { $0.id < $1.id })
            print(self.stashedSubCategories)
        }
    }

    private func loadParametersBySubCategory(_ subCategory: Category?) {
        print("term to load parameters")
        guard parameters.value.isEmpty else { return }
        guard subCategory != nil else { return }

        lotRepository.getLotParameters(categoryId: subCategory!.id) { res in
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

            self.parameters.accept(parameters)
//            let oldFilter = self.filter.value
//            self.filter.accept(oldFilter.updateFields(parameters: parameters))
        }

    }

}
