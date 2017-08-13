//
//  NetworkEntities.swift
//  NLive
//
//  Created by Eliah Snakin on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import Decodable

struct ShowDTO: NetworkDeserializer {
    
    struct Entity: NetworkEntity {
        let id: Int
        let title: String
        let description: String?
        let placeholderImageUrl: URL?
        let broadcasts: [BroadcastDTO.Entity]
        
        static func decode(_ json: Any) throws -> Entity {
            var placeholderImageUrl: URL? = nil
            if let stringUrl: String = try json =>? "placeholder_image_url" {
                placeholderImageUrl = URL(string: stringUrl)
            }
            
            return try Entity(
                id: json => "id",
                title: json => "title",
                description: json => "description",
                placeholderImageUrl: placeholderImageUrl,
                broadcasts: json => "broadcasts"
            )
        }
    }
    
    struct List: NetworkEntity {
        let entities: [Entity]
        
        static func decode(_ json: Any) throws -> List {
            return try List(entities: json => "list")
        }
    }
    
    struct EntityContainer: NetworkEntity {
        let entity: Entity
        
        static func decode(_ json: Any) throws -> EntityContainer {
            return try EntityContainer(entity: json => "entity")
        }
    }
}

struct BroadcastDTO: NetworkDeserializer {
    
    struct Entity: NetworkEntity {
        let id: Int
        let title: String
        let description: String?
        let placeholderImageUrl: URL?
        let startDate: Date
        let endDate: Date?
        let transcript: String?
        let contents: String?
        let streamUrl: URL
        let youtubeUrl: URL?
        let isLive: Bool
        let isFeatured: Bool
        let showId: Int
        
        static func decode(_ json: Any) throws -> Entity {
            var placeholderImageUrl: URL? = nil
            if let stringUrl: String = try json =>? "placeholder_image_url" {
                placeholderImageUrl = URL(string: stringUrl)
            }
            let startDateString: String = try json => "start_date"
            let endDateString: String? = try json => "end_date"
            
            var youtubeUrl: URL? = nil
            if let stringUrl: String = try json =>? "youtube_url" {
                youtubeUrl = URL(string: stringUrl)
            }
            
            return try Entity(
                id: json => "id",
                title: json => "title",
                description: json => "description",
                placeholderImageUrl: placeholderImageUrl,
                startDate: startDateString.dateFromISO8601!,
                endDate: endDateString?.dateFromISO8601,
                transcript: json =>? "transcript",
                contents: json =>? "contents",
                streamUrl: URL(string: (json => "stream_url")!)!,
                youtubeUrl: youtubeUrl,
                isLive: json => "is_live",
                isFeatured: json => "is_featured",
                showId: json => "show_id"
            )
        }
    }
    
    struct List: NetworkEntity {
        let entities: [Entity]
        
        static func decode(_ json: Any) throws -> List {
            return try List(entities: json => "list")
        }
    }
    
    struct EntityContainer: NetworkEntity {
        let entity: Entity
        
        static func decode(_ json: Any) throws -> EntityContainer {
            return try EntityContainer(entity: json => "entity")
        }
    }
}
