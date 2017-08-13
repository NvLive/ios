//
//  StoreService.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation

import RealmSwift

class BroadcastStoreService {
    
    internal func persistList(withDTO data: BroadcastDTO.List) {
        
        let realm = try! Realm()
        try! realm.write {
            data.entities.forEach({ entity in
                let broadcast = BroadcastStore(withDTO: entity)
                realm.add(broadcast, update: true)
                let show = realm.object(ofType: ShowStore.self, forPrimaryKey: entity.showId)
                show?.broadcasts.append(broadcast)
            })
        }
    }
    
    internal func persistEntity(withDTO data: BroadcastDTO.EntityContainer) {
        
        let realm = try! Realm()
        try! realm.write {
            let entity = data.entity
            let broadcast = BroadcastStore(withDTO: entity)
            realm.add(broadcast, update: true)
            let show = realm.object(ofType: ShowStore.self, forPrimaryKey: entity.showId)
            show?.broadcasts.append(broadcast)
        }
    }
    
    
//    internal func readList(forShowId showId: Int) -> Results<BroadcastStore> {
//        
//        let realm = try! Realm()
//        let entities = realm.objects(ShowStore.self).filter("id = %@", showId).map { $0.broadcasts }
//            
////            .filter("ANY show.id = %@", showId)
//        
//        return entities
//    }
    
    internal func readLast() -> Results<BroadcastStore> {
        
        let realm = try! Realm()
        let entities = realm.objects(BroadcastStore.self).filter("show.@count > 0").sorted(byKeyPath: "startDate", ascending: false)
        
        return entities
    }
    
    internal func readLive() -> Results<BroadcastStore> {
        
        let realm = try! Realm()
        let entities = realm.objects(BroadcastStore.self).filter("show.@count > 0 AND isLive = %@", true).sorted(byKeyPath: "startDate", ascending: false)
        
        return entities
    }
    
    internal func readFeatured() -> Results<BroadcastStore> {
        
        let realm = try! Realm()
        let entities = realm.objects(BroadcastStore.self).filter("show.@count > 0 AND isFeatured = %@", true).sorted(byKeyPath: "startDate", ascending: false)
        
        return entities
    }
    
    internal func readCurrent() -> Results<BroadcastStore> {
        let live = readLive()
        if live.count > 0 { return live }
        return readFeatured()
    }
    
    internal func readEntity(withId id: Int) -> Results<BroadcastStore> {
        
        let realm = try! Realm()
        let entities = realm.objects(BroadcastStore.self).filter("id = %@", id)
        
        return entities
    }
}
