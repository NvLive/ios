//
//  Collection+extension.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 29/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Dictionary {
    
    mutating func merge(_ dict: [Key: Value]) {
        dict.forEach {
            self[$0.key as Key] = $0.value
        }
    }
}

extension Collection {
    func mapToDictionary<K, V>(_ map: ((Self.Generator.Element) -> (K,    V)?))  -> [K: V] {
        var d = [K: V]()
        for e in self {
            if let kV = map(e) {
                d[kV.0] = kV.1
            }
        }
        
        return d
    }
    
    func mapToArray<T>(_ map: ((Self.Generator.Element) -> (T)?))  -> [T] {
        var a = [T]()
        for e in self {
            if let o = map(e) {
                a.append(o)
            }
        }
        
        return a
    }
    
    func mapToSet<T>(_ map: ((Self.Generator.Element) -> (T)?))  -> Set<T> {
        return Set(mapToArray(map))
    }
}

extension Set {
    
    mutating func insert(multiple elements: Element...) {
        elements.forEach {
            self.insert($0)
        }
    }
}
