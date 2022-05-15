//
//  SendCodePickerViewModel.swift
//  iosapp
//
//  Created by alexander on 21.04.2022.
//

import Foundation
import RxSwift
import RemoteDataService
import RxRelay
import SwiftUI

class CodePickerViewModel: ViewModel {
    // MARK: Events
    let checkCode = PublishRelay<CheckCodeStatus>()
    let setErrorScreenState = PublishRelay<String?>()
    let codeTextFieldState = PublishRelay<Bool>()
    let alert = PublishRelay<String?>()
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    private let authReposutory: AuthRepository
    
    init(_ authRepository: AuthRepository) {
        self.authReposutory = authRepository
        
        setErrorScreenState.subscribe(onNext: { errorMessage in
            let isErrorState = errorMessage == nil
            self.codeTextFieldState.accept(isErrorState)
            self.alert.accept(errorMessage)
        }).disposed(by: disposeBag)
    }
    
    func reSendCode(phone: String) {
        let phoneFormatted = phone
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        authReposutory.sendPhoneCall(phone: phoneFormatted) { [weak self] response in
            guard let response = response as? ErrorResponse else { return }
            self?.setErrorScreenState.accept(response.message)
        }
    }
    
    func checkCode(phone: String, code: String, fingerPrint: String) {
        let phoneFormatted = phone
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        authReposutory.checkCode(phone: phoneFormatted, code: code, fingerPrint: fingerPrint) { [weak self] response in
            switch response {
            case is SuccessResponseWithHeaders<Expires>: self?.checkCode.accept(.loginSuccess)
            case is SuccessResponse<Nothing>: self?.checkCode.accept(.needRegistration)
            case is ErrorResponse:
                self?.setErrorScreenState.accept((response as? ErrorResponse)!.message)
            default:
                fatalError("Not implemented handler for response \(response)")
            }
        }
    }
}

public enum CheckCodeStatus {
    case loginSuccess
    case needRegistration
}
