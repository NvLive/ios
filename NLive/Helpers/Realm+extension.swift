//
//  Realm+extension.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 29/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import RealmSwift

extension Results {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}
