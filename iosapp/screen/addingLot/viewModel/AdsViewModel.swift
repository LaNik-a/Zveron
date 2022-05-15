//
//  AdsViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 04.05.2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RemoteDataService

class AdsViewModel: ViewModel {
    
    let disposeBag = DisposeBag()
    let isAuthorized = PublishRelay<Bool>()
    
    func checkLogInUser() {
        if TokenRefreshService.isStarted {
            self.isAuthorized.accept(true)
        } else {
            self.isAuthorized.accept(false)
        }
    }
}
