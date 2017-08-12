//
//  NetworkService.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 29/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import Moya

enum BroadcastNetworkRouter: NetworkRouter {
    case last(count: Int)
    case current
    case show(id: Int, lastCount: Int)
    case entity(id: Int)
}

extension BroadcastNetworkRouter {
    
    var path:String {
        switch self {
        case .last(count: let count):
            return "/broadcasts/last/\(String(count))"
        case .current:
            return "/broadcasts/current"
        case .show(id: let id, lastCount: let lastCount):
            return "/broadcasts/show/\(String(id))/last/\(String(lastCount))"
        case .entity(id: let id):
            return "/broadcast/\(String(id))"
        }
    }
    
//    var sampleData: Data {
//        switch self {
//        case .list:
//            return readSampleData(forRequest: "show")
//        }
//    }
}

class BroadcastNetworkService: NetworkService<BroadcastNetworkRouter> {
    
    internal func requestList(countLast count: Int, completion: @escaping ((_ decodedObject: BroadcastDTO.List?, _ error: NetworkError?)->()))
    {
        provider.requestDecodable(.last(count: count), completion: completion)
    }
    
    internal func requestListCurrent(completion: @escaping ((_ decodedObject: BroadcastDTO.List?, _ error: NetworkError?)->()))
    {
        provider.requestDecodable(.current, completion: completion)
    }
    
    internal func requestList(forShowId showId: Int, countLast count: Int, completion: @escaping ((_ decodedObject: BroadcastDTO.List?, _ error: NetworkError?)->()))
    {
        provider.requestDecodable(.show(id: showId, lastCount: count), completion: completion)
    }
    
    internal func requestEntity(id: Int, completion: @escaping ((_ decodedObject: BroadcastDTO.EntityContainer?, _ error: NetworkError?)->()))
    {
        provider.requestDecodable(.entity(id: id), completion: completion)
    }
}
