//
//  AuthRepository.swift
//  iosapp
//
//  Created by alexander on 17.04.2022.
//

import Foundation
import RemoteDataService

class AuthRepository {
    
    func sendPhoneCall(
        phone: String,
        callback: @escaping (Response) -> Void
    ) {
        let url = "\(RemoteDataConstant.BASE_URL)/api/phone/send"
        let params: [String: Any] = ["phone": phone]
        RemoteDataService.post(dataType: Nothing.self, url: url, params: params, callback: callback)
    }
    
    func checkCode(
        phone: String,
        code: String,
        fingerPrint: String,
        callback: @escaping (Response) -> Void
    ) {
        let url = "\(RemoteDataConstant.BASE_URL)/api/phone/check"
        let params: [String: String] = [
            "phone": phone,
            "code": code,
            "fingerPrint": fingerPrint
        ]
        RemoteDataService.post(dataType: Expires.self, url: url, params: params, isReturnHeaders: true) { response in
            guard let response = response as? SuccessResponseWithHeaders<Expires> else {
                callback(response)
                return
            }
            TokenRefreshService.setUp(
                initHeaders: response.headers,
                expiresIn: response.data.expiresIn,
                fingerPrint: fingerPrint
            )
            TokenRefreshService.start()
            callback(response)
        }
    }
    
    func registration(
        request: RegistrationRequest,
        callback: @escaping (Response) -> Void
    ) {
        let url = "\(RemoteDataConstant.BASE_URL)/api/auth/register"
        let params = [
            "phone": request.phone,
            "password": request.password.toBase64(),
            "name": request.name,
            "surname": request.surname,
            "fingerPrint": request.fingerPrint
        ]
        RemoteDataService.post(dataType: Expires.self, url: url, params: params, isReturnHeaders: true) { response in
            guard let response = response as? SuccessResponseWithHeaders<Expires> else {
                callback(response)
                return
            }
            TokenRefreshService.setUp(
                initHeaders: response.headers,
                expiresIn: response.data.expiresIn,
                fingerPrint: request.fingerPrint
            )
            TokenRefreshService.start()
            callback(response)
        }
    }
    
    func signIn(
        phone: String,
        password: String,
        fingerPrint: String,
        callback: @escaping (Response) -> Void
    ) {
        let url = "\(RemoteDataConstant.BASE_URL)/api/auth/login/password"
        let params = [
            "phone": phone,
            "password": password.toBase64(),
            "fingerPrint": fingerPrint
        ]
        RemoteDataService.post(dataType: Expires.self, url: url, params: params, isReturnHeaders: true) { response in
            guard let response = response as? SuccessResponseWithHeaders<Expires> else {
                callback(response)
                return
            }
            TokenRefreshService.setUp(
                initHeaders: response.headers,
                expiresIn: response.data.expiresIn,
                fingerPrint: fingerPrint
            )
            TokenRefreshService.start()
            callback(response)
        }
    }
    
    func signInByMessenger(
        url: URL,
        fingerPrint: String,
        callback: @escaping (Response) -> Void
    ) {
        RemoteDataService.getNoRedirect(dataType: Nothing.self, url: url, fingerPrint: fingerPrint) { response in
            guard let response = response as? SuccessResponseWithHeaders<Nothing> else {
                callback(response)
                return
            }
            TokenRefreshService.setUp(
                initHeaders: response.headers,
                expiresIn: 30,
                fingerPrint: fingerPrint
            )
            TokenRefreshService.start()
            callback(response)
        }
    }
}
