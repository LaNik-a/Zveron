//
//  PhonePasswordPickerViewModel.swift
//  iosapp
//
//  Created by alexander on 24.04.2022.
//

import Foundation
import RemoteDataService
import RxSwift
import RxRelay

class PhonePasswordPickerViewModel: ViewModel {
    // MARK: Events
    let signIn = PublishRelay<Void>()
    let setErrorScreenState = PublishRelay<String?>()
    let completeButton = PublishRelay<Bool>()
    let phone = PublishRelay<String?>()
    let password = PublishRelay<String?>()
    let alert = PublishRelay<AlertModel?>()
    
    // MARK: Processed Events
    private var isValidFields: Observable<Bool> {
        return Observable.combineLatest(isValidPhone, isValidPassword) { $0 && $1 }
    }
    private var isValidPassword: Observable<Bool> {
        return password.map {
            guard let value = $0 else { return false }

            guard value.range(of: "^(?=.*[а-яА-ЯёЁ]).{0,}", options: .regularExpression) == nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль не может содержать буквы кириллицы",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[A-Z].*[A-Z]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 2 буквы в верхнем регистре",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[a-z].*[a-z].*[a-z]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 3 буквы в нижнем регистре",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[!@#$&*]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 1 спец-символ ! @ # $ & *",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[0-9].*[0-9]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 2 цифры",
                    mode: .warning))
                return false
            }

            guard value.count >= 8 else {
                self.alert.accept(AlertModel(
                    message: "Пароль не может быть короче 8 символов",
                    mode: .warning))
                return false
            }

            self.alert.accept(nil)
            return true
        }
    }
    
    private  var isValidPhone: Observable<Bool> {
        return phone.map {
            guard let phone = $0 else { return false }
            return phone.count == 16
        }
    }
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    private let authReposutory: AuthRepository
    
    init(_ authRepository: AuthRepository) {
        self.authReposutory = authRepository
        
        setErrorScreenState.subscribe(onNext: { errorMessage in
            let isErrorState = errorMessage == nil
            if !isErrorState { self.completeButton.accept(false) }
            if !isErrorState { self.alert.accept(AlertModel(message: errorMessage!, mode: .error)) }
        }).disposed(by: disposeBag)
        
        isValidFields.bind(to: completeButton).disposed(by: disposeBag)
        
        isValidPhone.subscribe(onNext: { valid in
            if valid {
                self.alert.accept(nil)
            } else {
                self.alert.accept(AlertModel(message: "Введите номер телефона", mode: .warning) )
            }
        }).disposed(by: disposeBag)
    }
    
    func signIn(phone: String, password: String, fingerPrint: String) {
        let formattedPhone = phone
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        authReposutory.signIn(phone: formattedPhone, password: password, fingerPrint: fingerPrint) { response in
            guard let response = response as? ErrorResponse else {
                self.signIn.accept(Void())
                return
            }
            
            self.setErrorScreenState.accept(response.message)
        }
    }
}
