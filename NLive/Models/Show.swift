//
//  Show.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import Realm

class Show: Object {
    dynamic var title: String = ""
    dynamic var descr: String
    dynamic var imgURL: URL
    dynamic var schedule: String
    dynamic var broadcasts: [Broadcast]
}
