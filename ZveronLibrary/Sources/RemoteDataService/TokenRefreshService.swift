//
//  File.swift
//  
//
//  Created by alexander on 12.04.2022.
//
import Foundation
import Alamofire

public struct TokenRefreshService {
    private static var accessHeader: HTTPHeader?
    private static var expiresIn: Int64 = 0
    private static var fingerPrint: String = ""
    private static var lastUpdateAccessHeader: Date?
    private static let deltaBeforeExpiration: Int64 = Int64(RemoteDataConstant.DELTA_BEFORE_EXPIRATION)

    public static var isStarted: Bool {
        return lastUpdateAccessHeader != nil
    }

    public static func setUp(initHeaders: HTTPHeaders, expiresIn: Int64, fingerPrint: String) {
        self.accessHeader = initHeaders.first { $0.name == "Authorization" }!
        self.expiresIn = expiresIn
        self.fingerPrint = fingerPrint
        self.lastUpdateAccessHeader = Date()
    }

    public static func start() {
        DispatchQueue.global(qos: .background).async {
            updateAccessHeader(withInterval: UInt32(RemoteDataConstant.REFRESH_TOKEN_RATE))
        }
    }

    public static func getAccessHeader () -> HTTPHeader? {
        return accessHeader
    }

    private static func updateAccessHeader(withInterval intervalUpdating: UInt32) {
        while true {
            sleep(intervalUpdating)

            print("[RefreshTokenService]: Попытка обновить токены")

            let secondInterval = Date().timeIntervalSince(lastUpdateAccessHeader!)
            // Токен истекает надо обновить
            guard Int64(secondInterval) >= expiresIn - deltaBeforeExpiration else {
                print("[RefreshTokenService]: Токен не нуждается в обновлении")
                continue
            }

            // запрос на обновление токенов, если все классно обновляем инстансе хедера
            RemoteDataService.post(
                dataType: Expires.self,
                url: "\(RemoteDataConstant.BASE_URL)/api/auth/refresh-token",
                params: ["fingerPrint": fingerPrint],
                isReturnHeaders: true
            ) { response in
                guard let response = response as? SuccessResponseWithHeaders<Expires> else {
                    print("[RefreshTokenService]: Токен необновлен, ошибка")
                    return
                }
                
                // Обновление время жизни токена-доступа,
                // заголовка с токеном-доступом
                // и времени последнего обновления токена-доступа
                TokenRefreshService.expiresIn = response.data.expiresIn
                TokenRefreshService.accessHeader = response.headers.first { $0.name == "Authorization" }!
                TokenRefreshService.lastUpdateAccessHeader = Date()
                print("[RefreshTokenService]: Токен успешно обновлен")
            }
        }
    }
}
