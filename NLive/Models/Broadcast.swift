//
//  Broadcast.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import RealmSwift

class BroadcastStore: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var descriptionString: String? = nil
    dynamic var placeholderImageUrlString: String? = nil
    dynamic var startDate: Date = Date()
    dynamic var endDate: Date? = nil
    dynamic var transcript: String? = nil
    dynamic var contents: String? = nil
    dynamic var streamUrlString: String = ""
    dynamic var localPathString: String? = nil
    dynamic var youtubeUrlString: String? = nil
    dynamic var isLive: Bool = false
    dynamic var isFeatured: Bool = false
    
    let show = LinkingObjects(fromType: ShowStore.self, property: "broadcasts")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension BroadcastStore {
    
    convenience init(withDTO data: BroadcastDTO.Entity) {
        self.init()
        
        id = data.id
        title = data.title
        descriptionString = data.description
        placeholderImageUrlString = data.placeholderImageUrl?.absoluteString
        startDate = data.startDate
        endDate = data.endDate
        transcript = data.transcript
        contents = data.contents
        youtubeUrlString = data.youtubeUrl?.absoluteString
        streamUrlString = data.streamUrl.absoluteString
        isLive = data.isLive
        isFeatured = data.isFeatured
    }
}
