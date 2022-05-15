//
//  AddingLotAddressViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 10.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import RemoteDataService

class AddingLotAddressViewModel: ViewModel {
    
    let disposeBag = DisposeBag()
    private var lotRepository: LotRepository
    
    let addressLot = BehaviorRelay<String?>(value: "")
    let continueBtn = PublishRelay<Bool>()
    let alert = PublishRelay<AlertModel?>()
    let isPhone = BehaviorRelay<Bool>(value: false)
    let isChat = BehaviorRelay<Bool>(value: false)
    
    private var isValidAddress: Observable<Bool> {
        return addressLot.map {
            guard let value = $0 else { return false }
            return value.count > 3 && value.count < 50
        }
    }
    
    private var isValidForm: Observable<Bool> {
        return Observable.combineLatest(isValidAddress, isPhone, isChat) { $0 && ($1 || $2) }
    }
    
    
    init(_ lotRepository: LotRepository) {
        self.lotRepository = lotRepository
        bindViews()
    }
    
    
    func bindViews() {
        isValidForm.bind(to: continueBtn).disposed(by: disposeBag)
        
        isValidAddress.bind(onNext: { valid in
            if valid {
                self.alert.accept(nil)
            } else {
                guard let value = self.addressLot.value else { return }
                if value.count <= 3 {
                    self.alert.accept(AlertModel(
                        message: "Название города слишком короткое",
                        mode: .warning))
                }
                else {
                    self.alert.accept(AlertModel(
                        message: "Название города слишком длинное",
                        mode: .warning))
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    func createLot(lot: Lot) {
        lotRepository.setLot(lot: lot, callback: { res in
            guard let response = res as? SuccessResponse<Nothing> else {
                print(res)
                return
            }
            print(response)
        })
    }
}
