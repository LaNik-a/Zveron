//
//  HttpClient.swift
//  iosapp
//
//  Created by alexander on 14.03.2022.
//

import Foundation
import Alamofire

private let BASE_API = "http://localhost:8080/api/v1/phone/"
private let URL_SEND_PHONE = "send"
private let URL_CHECK_CODE = "check"
private let baseHeaders = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])

func evulate<T: Codable>(res: AFDataResponse<Data?>, dataType: T.Type, callback: ((ResponseResult) -> Void)? ) {

    guard res.response!.statusCode == 200 else {
        callback?(ErrorResponseResult(errorCode: res.response!.statusCode, errorDescription: "Ошибка"))
        return

    }

    guard let val = res.data else { return }

    var decodedData: T?
    do {
    decodedData =  try JSONDecoder().decode(dataType, from: val)
    } catch {}
    callback?(DataResponseResult<T>(value: decodedData!))
}

func sendCodeOnPhoneRequest(withData number: String, withResult callback:@escaping((ResponseResult) -> Void)) {

    let url = BASE_API + URL_SEND_PHONE

    let params: [String: String] = ["phone": number, "isAuth": "false"]

    AF.request(URL(string: url)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: baseHeaders).response { res in
        evulate(res: res, dataType: Empty.self, callback: callback)
        return
    }
}

func checkCodeForAuth(withPhone phone: String, withCode code: String, withResult callback:@escaping((ResponseResult) -> Void)) {
    let url = BASE_API + URL_CHECK_CODE
    let params: [String: String] = ["phone": phone, "code": code ]

    AF.request(URL(string: url)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: baseHeaders).response { res in
        evulate(res: res, dataType: Empty.self, callback: callback)
        return
    }
}
