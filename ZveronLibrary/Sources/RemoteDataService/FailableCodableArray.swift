//
//  File.swift
//  
//
//  Created by alexander on 02.05.2022.
//

import Foundation

public struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

public struct FailableCodableArray<Element: Codable>: Codable {

   public var elements: [Element]

    public init(from decoder: Decoder) throws {

        var container = try decoder.unkeyedContainer()

        var elements = [Element]()
        if let count = container.count {
            elements.reserveCapacity(count)
        }

        while !container.isAtEnd {
            if let element = try container
                .decode(FailableDecodable<Element>.self).base {

                elements.append(element)
            }
        }

        self.elements = elements
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(elements)
    }
}
