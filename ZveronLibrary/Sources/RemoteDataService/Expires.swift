//
//  File.swift
//  
//
//  Created by alexander on 13.04.2022.
//

import Foundation

public struct Expires: Codable {
    public let expiresIn: Int64
    public let refreshExpiresIn: Int64
}
