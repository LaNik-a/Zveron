//
//  File.swift
//  
//
//  Created by alexander on 12.04.2022.
//

import Foundation
import Alamofire

public protocol Response {
    
}

public struct SuccessResponse<T: Codable>: Response {
    public let data: T
}

public struct SuccessResponseWithHeaders<T: Codable>: Response {
    public let data: T
    public let headers: HTTPHeaders
}

public struct ErrorResponse: Response, Codable {
    public let status: Int
    public let message: String?
    public let description: String?
}
