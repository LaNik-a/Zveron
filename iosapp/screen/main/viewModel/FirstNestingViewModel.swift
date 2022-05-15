//
//  FirstNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxRelay

protocol FirstNestingViewModelHeader: NestingViewModelBase {
    var selectedCategory: PublishRelay<Category> { get }
}

class FirstNestingViewModel: NestingViewModel, FirstNestingViewModelHeader {
    let selectedCategory = PublishRelay<Category>()

    override init(_ lotRepository: LotRepository) {
        super.init(lotRepository)
    }
}
