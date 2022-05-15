//
//  File.swift
//  
//
//  Created by alexander on 13.04.2022.
//

import Foundation

public struct Nothing: Codable {
    private init() {}
    public static let instance = Nothing()
}
