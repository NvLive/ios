//
//  NetworkService.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 27/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import Moya
import Decodable
import protocol Decodable.Decodable
// Structures

enum NetworkError: Swift.Error {
    case network(error: Swift.Error, statusCode: Int?)
    case deserialization(error: Swift.Error)
    case validation(errorMessage: String?)
}

struct NetworkParameters {
//    static let baseApiUrl = URL(string: "http://194.177.20.219/api/v1/")!
//    static let baseReachabilityHostname = "http://194.177.20.219/"
    
    static let baseApiUrl = URL(string: "http://util.nikans.com/navalny-live/api/v1")!
    static let baseReachabilityHostname = "nikans.com"
}


// Network Service

class NetworkService<R: NetworkRouter> {
    
    internal let provider = MoyaProvider<R>() // plugins: [NetworkLoggerPlugin(verbose: true)]

}

extension MoyaProvider {
    
    internal func requestDecodable<C: Decodable>(_ target: Target, completion: @escaping ((_ decodedObject: C?, _ error: NetworkError?)->()))
    {
        self.request(target, completion: { (result) in
            
            switch result {
            case let .success(response):
                do {
                    let decodedObject = try response.mapObject(to: C.self)
                    completion(decodedObject, nil)
                } catch {
                    completion(nil, NetworkError.deserialization(error: error))
                }
                
            case let .failure(error):
                completion(nil, NetworkError.network(error: error, statusCode: error.response?.statusCode))
            }
        })
    }
}


// Network Router

protocol NetworkRouter: NetworkSerializer {
}

extension NetworkRouter {
    func readSampleData(forRequest requestPath: String) -> Data {
        if let path = Bundle.main.path(forResource: "NetworkSampleData/"+requestPath, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return "".data(using: .utf8)!
    }
}


// Network Serializer/Deserializer

protocol NetworkSerializer: TargetType {
    var baseURL: URL { get }
}

extension NetworkSerializer {
    var baseURL: URL { return NetworkParameters.baseApiUrl }
    var parameters:[String:Any]? { return nil }
    var method: Moya.Method { return .get }
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    var sampleData: Data { return "".data(using: .utf8)! }
    var task: Task { return .requestPlain }
    var validate: Bool { return true }
    var headers: [String: String]? {
//        if let token = store.state.authState.token {
//            return ["X-Access-Token": token]
//        }
//        else { return nil }
        return nil
    }
}

protocol NetworkDeserializer {
}
protocol NetworkEntity: Decodable {
}
