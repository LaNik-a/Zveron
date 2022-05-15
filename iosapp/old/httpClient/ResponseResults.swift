//
//  ResponseResult.swift
//  iosapp
//
//  Created by alexander on 14.03.2022.
//

import Foundation

public protocol ResponseResult {}

public struct DataResponseResult<T : Codable> : ResponseResult {
    let value: T
}

public struct ErrorResponseResult: ResponseResult {
    let errorCode: Int
    let errorDescription: String
}
