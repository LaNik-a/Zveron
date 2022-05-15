//
//  MainAuthViewController.swift
//  iosapp
//
//  Created by alexander on 25.04.2022.
//

import Foundation
import RemoteDataService
import RxSwift
import RxRelay

class MainAuthViewModel: ViewModel {
    // MARK: Events
    let signInByMessenger = PublishRelay<Bool>()

    // MARK: Properties
    let disposeBag = DisposeBag()
    private let authReposutory: AuthRepository
    
    init(_ authRepository: AuthRepository) {
        self.authReposutory = authRepository
    }
    
    func signInByMessenger(url: URL, fingerPrint: String) {
        authReposutory.signInByMessenger(url: url, fingerPrint: fingerPrint) { response in
            self.signInByMessenger.accept(response is SuccessResponseWithHeaders<Nothing>)
        }
    }
}
