//
//  AddingLotDescriptionViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import RemoteDataService

class AddingLotDescriptionViewModel: ViewModel {
    
    let disposeBag = DisposeBag()
    let descLot = BehaviorRelay<String?>(value: "")
    let ageLot = BehaviorRelay<String?>(value: "")
    let continueBtn = PublishRelay<Bool>()
    let alert = PublishRelay<AlertModel?>()
    
    
    private var isValidAgeLot: Observable<Bool> {
        return ageLot.map {
            guard let value = $0 else { return false }
            let utcISODateFormatter = ISO8601DateFormatter()

            if utcISODateFormatter.date(from: value) != nil {
                return true
            }
            return false
        }
    }
    
    private var isValidDescLot: Observable<Bool> {
        return descLot.map {
            guard let value = $0 else { return false }
            return value.count <= 1000
        }
    }
    
    private var isValidForm: Observable<Bool> {
        return Observable.combineLatest(isValidAgeLot, isValidDescLot) { $0 && $1 }
    }
    
    init() {
        bindViews()
    }
    
    func bindViews() {
        isValidForm.bind(to: continueBtn).disposed(by: disposeBag)
        
        isValidDescLot.bind(onNext: { valid in
            if valid {
                self.alert.accept(nil)
            } else {
                guard let value = self.descLot.value else { return }
                if value.count > 1000 {
                    self.alert.accept(AlertModel(
                        message: "Описание содержит много символов",
                        mode: .warning))
                }
            }
        }).disposed(by: disposeBag)
    }
}
