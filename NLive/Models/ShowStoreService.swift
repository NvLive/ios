//
//  StoreService.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation

import RealmSwift

class ShowStoreService {
    
    internal func persistList(withDTO data: ShowDTO.List) {
        
        let realm = try! Realm()

        let entities = data.entities.map({ (entity) -> ShowStore in
            let show = ShowStore(withDTO: entity)
            let broadcasts = realm.objects(BroadcastStore.self).filter("showId = %@", show.id)
            broadcasts.forEach({ (broadcastToAppend) in
                if !show.broadcasts.contains(where: { (br) -> Bool in
                    br.id == broadcastToAppend.id
                }) {
                    show.broadcasts.append(broadcastToAppend)
                }
            })
            return show
        })
        
        try! realm.write {
            realm.add(entities, update: true)
        }
    }
    
    
    internal func readList() -> Results<ShowStore> {
        
        let realm = try! Realm()
        let entities = realm.objects(ShowStore.self)
        
        return entities
    }
}
