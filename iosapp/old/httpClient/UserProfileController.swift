//
//  UserProfileController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 15.03.2022.
//

import Foundation
import Alamofire
import UIKit

private let BASE_API = "http://localhost:8080/profile/"
private let URL_OTHER_PROFILE_INFO = "public/"
private var baseHeaders = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])

func evaluate<T: Codable>(res: AFDataResponse<Data?>, dataType: T.Type, callback: ((ResponseResult) -> Void) ) {

    guard res.response!.statusCode == 200 else {
        callback(ErrorResponseResult(errorCode: res.response!.statusCode, errorDescription: ""))
        return

    }
    guard let val = res.data else { return }

    var decodedData: T?
    do {
    decodedData =  try JSONDecoder().decode(dataType, from: val)
    } catch {}
    callback(DataResponseResult<T>(value: decodedData!))
}

func getFullInfoAboutProfile(withData id: Int, withResult callback:@escaping((ResponseResult) -> Void)) {

    let url = BASE_API // + URL_OTHER_PROFILE_INFO + String(id)

    if RefreshTokenService.getAccessHeader() != nil {
        baseHeaders.add(RefreshTokenService.getAccessHeader()!)
    }

    // let params : [String: String] = ["phone" : number]

    AF.request(URL(string: url)!, method: .get, encoding: JSONEncoding.default, headers: baseHeaders).response { res in
        evaluate(res: res, dataType: Profile.self, callback: callback)
        return
    }
}
