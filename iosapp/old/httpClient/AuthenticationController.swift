//
//  AuthenticationController.swift
//  iosapp
//
//  Created by alexander on 15.03.2022.
//

import Foundation
import Alamofire
import UIKit

private let BASE_API = "http://localhost:8080/api/auth/"
private let URL_REGISTER = "register"
private let URL_SIGN_IN = "login/password"

private let URL_UPDATE_TOKEN = "refresh_token"
private let baseHeaders = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])

func registration(withData data: [String: String], withResult callback:@escaping((ResponseResult) -> Void)) {
    let url = BASE_API + URL_REGISTER
    AF.request(URL(string: url)!, method: .post, parameters: data, encoding: JSONEncoding.default, headers: baseHeaders).response { res in
        // запускаем сервис по обновлению токенов
        if res.response?.statusCode == 200 {
            let accessTokenHeader = res.response!.headers.first {$0.name == "Authorization"}!
            RefreshTokenService.initService(withFingerPrint: data["fingerPrint"]!, withHeader: accessTokenHeader)
        }
        evulate(res: res, dataType: Empty.self, callback: callback)
        return
    }
}

func authByPhoneAndPassword(withData data: [String: String], withResult callback:@escaping((ResponseResult) -> Void)) {
    let url = BASE_API + URL_SIGN_IN
    AF.request(URL(string: url)!, method: .post, parameters: data, encoding: JSONEncoding.default, headers: baseHeaders).response { res in
        // запускаем сервис по обновлению токенов
        if res.response?.statusCode == 200 {
            let accessTokenHeader = res.response!.headers.first {$0.name == "Authorization"}!
            RefreshTokenService.initService(withFingerPrint: data["fingerPrint"]!, withHeader: accessTokenHeader)
        }
        evulate(res: res, dataType: Empty.self, callback: callback)
        return
    }
}

func updateToken(withData data: [String: String], withResult callback:@escaping((AFDataResponse<Data?>) -> Void)) {
    let url = BASE_API + URL_UPDATE_TOKEN
    AF.sessionConfiguration.httpShouldSetCookies = true
    AF.request(URL(string: url)!, method: .post, parameters: data, encoding: JSONEncoding.default, headers: baseHeaders).response(completionHandler: callback)
}
