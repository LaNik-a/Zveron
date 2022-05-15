//
//  RefreshTokenServer.swift
//  iosapp
//
//  Created by alexander on 15.03.2022.
//

import Foundation
import Alamofire

class RefreshTokenService {

    private static var accessHeader: HTTPHeader?
    private static let accessLive: Int64 = 600
    private static var lastUpdateAccessHeader: Date?
    private static var fingerPrintDevice: String = ""

    static var isStarted: Bool {
        return lastUpdateAccessHeader != nil
    }

    static func initService(withFingerPrint fingerPrint: String, withHeader initAccessHeader: HTTPHeader) {
        fingerPrintDevice = fingerPrint
        accessHeader = initAccessHeader
        lastUpdateAccessHeader = Date()

        DispatchQueue.global(qos: .background).async {
            updateExpiredAccessHeader(withInterval: 5)
        }
    }

    static func getAccessHeader () -> HTTPHeader? {
        return accessHeader
    }

  private static func updateTokenPair(withHeader newAccessHeader: HTTPHeader) {
        accessHeader = newAccessHeader
       lastUpdateAccessHeader = Date()
    }

    private static func updateExpiredAccessHeader(withInterval intervalUpdating: UInt32) {

        while true {
            sleep(intervalUpdating)

            print("[RefreshTokenService]: Попытка обновить токены")
            let secondInterval = Date().timeIntervalSince(lastUpdateAccessHeader!)

            // Токен истекает надо обновить
            guard Int64(secondInterval) >= accessLive - 5 else {
                print("[RefreshTokenService]: Токен не нуждается в обновлении")
                continue
            }

            updateToken(withData: ["fingerPrint": fingerPrintDevice]) {res in
                if res.response?.statusCode == 200 {
                    let accessTokenHeader = res.response!.headers.first {$0.name == "Authorization"}!
                    RefreshTokenService.updateTokenPair(withHeader: accessTokenHeader)
                    print("[RefreshTokenService]: Токен успешно обновлен")
                } else {
                    print("[RefreshTokenService]: Токен необновлен, ошибка")
                }
            }
        }
    }
}
