//
//  NumberPickerViewModel.swift
//  iosapp
//
//  Created by alexander on 17.04.2022.
//

import Foundation
import RxSwift
import RemoteDataService
import RxRelay

class PhonePickerViewModel: ViewModel {
    
    // MARK: Events
    let sendCode = PublishRelay<Void>()
    let phone = PublishRelay<String?>()
    let setErrorScreenState = PublishRelay<String?>()
    let continueButtonState = PublishRelay<Bool>()
    let phoneTextFieldState = PublishRelay<Bool>()
    let alert = PublishRelay<String?>()
    
    // MARK: Processed Events
    private var isValidPhone: Observable<Bool> {
        return phone.map { phone in
            phone?.count == 16
        }
    }

    // MARK: Properties
    let disposeBag = DisposeBag()
    private let authReposutory: AuthRepository

    init(_ authRepository: AuthRepository) {
        self.authReposutory = authRepository

        setErrorScreenState.subscribe(onNext: { errorMessage in
            let isErrorState = errorMessage == nil
            if !isErrorState { self.continueButtonState.accept(false) }
            self.phoneTextFieldState.accept(isErrorState)
            self.alert.accept(errorMessage)
        }).disposed(by: disposeBag)
        
        isValidPhone.bind(to: continueButtonState).disposed(by: disposeBag)

        phone.subscribe { _ in
            self.setErrorScreenState.accept(nil)
        }.disposed(by: disposeBag)
    }
    
    func sendCode(phone: String) {
        let formattedPhone = phone
            .replacingOccurrences(of: "+7", with: "7")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")

        authReposutory.sendPhoneCall(phone: formattedPhone) { response in
            guard let response = response as? ErrorResponse else {
                self.sendCode.accept(Void())
                return
            }
            self.setErrorScreenState.accept(response.message)
        }
    }
}
