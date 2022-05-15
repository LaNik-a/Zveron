//
//  AddingLotPriceViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 10.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import RemoteDataService

class AddingLotPriceViewModel: ViewModel {
    
    let disposeBag = DisposeBag()
    let priceLot = BehaviorRelay<String?>(value: "")
    let continueBtn = PublishRelay<Bool>()
    let alert = PublishRelay<AlertModel?>()
    let isSpecificPrice = BehaviorRelay<Bool>(value: false)
    
    private var isValidPriceLot: Observable<Bool> {
        return priceLot.map {
            guard let value = $0 else { return false }
            return value.numericCharactersOnly && Int(value) ?? 1000000000 <= 1000000000
        }
    }
    
    private var isValidForm: Observable<Bool> {
        return Observable.combineLatest(isValidPriceLot, isSpecificPrice) { $0 || $1 }
    }
    
    init() {
        bindViews()
    }
    
    func bindViews() {
        isValidForm.bind(to: continueBtn).disposed(by: disposeBag)
        
        isValidPriceLot.bind(onNext: { valid in
            if valid {
                self.alert.accept(nil)
            } else {
                guard let value = self.priceLot.value else { return }
                if Int(value) ?? 0 > 1000000000 {
                    self.alert.accept(AlertModel(
                        message: "Цена не может быть больше 1 млрд",
                        mode: .warning))
                }
                else {
                    self.alert.accept(AlertModel(
                        message: "Цена имеет неверный формат",
                        mode: .warning))
                }
            }
        }).disposed(by: disposeBag)
    }
}
