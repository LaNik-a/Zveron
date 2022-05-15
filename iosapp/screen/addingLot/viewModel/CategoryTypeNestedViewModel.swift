//
//  AddingLotCategoryViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import RemoteDataService

class CategoryTypeNestedViewModel: ViewModel {
    
    let disposeBag = DisposeBag()
    private let lotRepository: LotRepository
    
    
    init(_ lotRepository: LotRepository) {
        self.lotRepository = lotRepository
    }
    
    
}
