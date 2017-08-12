//
//  NetworkService.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 29/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import Moya

enum PushNetworkRouter: NetworkRouter {
    case subscribe(token: String, showIds: [Int])
    case unsubscribe(token: String)
}

extension PushNetworkRouter {
    
    var path:String {
        switch self {
        case .subscribe(_,_):
            return "/push_service/subscribe"
        case .unsubscribe(_):
            return "/push_service/unsubscribe"
        }
    }
    
    var method: Moya.Method { return .post }
    
    var parameters:[String:Any]? {
        switch self {
        case .subscribe(token: let token, showIds: let showIds):
            return ["token": token, "shows": showIds.map { String($0) }.joined(separator: ",")]
        case .unsubscribe(token: let token):
            return ["token": token]
        }
    }
    
    //    var sampleData: Data {
    //        switch self {
    //        case .list:
    //            return readSampleData(forRequest: "show")
    //        }
    //    }
}

class PushNetworkService: NetworkService<PushNetworkRouter> {
    
//    internal func requestData(completion: @escaping ((_ decodedObject: DashboardDTO.Container?, _ data: Data?, _ error: NetworkError?)->()))
//    {
//        provider.requestDecodableWithRaw(.list, completion: completion)
//    }
}
