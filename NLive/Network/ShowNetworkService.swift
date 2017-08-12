//
//  NetworkService.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 29/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import Moya

enum ShowNetworkRouter: NetworkRouter {
    case list
    case entity(id: Int)
}

extension ShowNetworkRouter {
    
    var path:String {
        switch self {
        case .list:
            return "/shows"
        case .entity(id: let id):
            return "/show/\(String(id))"
        }
    }
    
//    var sampleData: Data {
//        switch self {
//        case .list:
//            return readSampleData(forRequest: "show")
//        }
//    }    
}

class ShowNetworkService: NetworkService<ShowNetworkRouter> {
    
    internal func requestList(completion: @escaping ((_ decodedObject: ShowDTO.List?, _ error: NetworkError?)->()))
    {
        provider.requestDecodable(.list, completion: completion)
    }
    
    internal func requestEntity(id: Int, completion: @escaping ((_ decodedObject: ShowDTO.EntityContainer?, _ error: NetworkError?)->()))
    {
        provider.requestDecodable(.entity(id: id), completion: completion)
    }
}
