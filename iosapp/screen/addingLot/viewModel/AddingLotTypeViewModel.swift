//
//  AddingLotTypeViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import RemoteDataService

class AddingLotTypeViewModel: ViewModel {
    
    let disposeBag = DisposeBag()
    private let categoryRepository: CategoryRepository
    
    
    init(_ categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    
    
}
