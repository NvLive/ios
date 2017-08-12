//
//  Response+Decodable.swift
//
//  Created by Valentin Pertuisot on 11/01/2016.
//

import Moya
import Decodable

public extension Response {
    
    /// Maps data received into an object which implements the Decodable protocol.
    public func mapObject<T: Decodable>(to type: T.Type) throws -> T {
        return try T.decode(try mapJSON())
    }
    
    /// Maps data received into an array of objects which implement the Decodable
    /// protocol.
    public func mapObjectArray<T: Decodable>(to type: T.Type) throws -> [T] {
        return try [T].decode(try mapJSON())
    }
    
}
