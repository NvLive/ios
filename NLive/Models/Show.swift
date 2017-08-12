//
//  Show.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import RealmSwift

class ShowStore: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var descriptionString: String? = nil
    dynamic var placeholderImageUrlString: String? = nil
//    dynamic var schedule: String
    let broadcasts = List<BroadcastStore>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    override static func ignoredProperties() -> [String] {
//        return []
//    }
}

extension ShowStore {
    
    convenience init(withDTO data: ShowDTO.Entity) {
        self.init()
        
        id = data.id
        title = data.title
        descriptionString = data.description
        placeholderImageUrlString = data.placeholderImageUrl?.absoluteString
        broadcasts.append(objectsIn: data.broadcasts.map { BroadcastStore(withDTO: $0) })
    }
}

