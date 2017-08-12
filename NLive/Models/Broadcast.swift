//
//  Broadcast.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import Realm

class Broadcast: Object {
    dynamic var startTime: Date
    dynamic var endTime: Date?
    dynamic var title: String
    dynamic var descr: String?
    dynamic var imgURL: URL?
    dynamic var text: String?
    dynamic var contents: String?
    dynamic var youtubeURL: URL?
    dynamic var streamURL: URL
    dynamic var isLive: Bool
    dynamic var isFeatured: Bool
}
