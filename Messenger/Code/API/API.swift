//
//  API.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String : Any]

public enum Result<T> {
    case success(T)
    case error(Error)
}

extension Alamofire.DataRequest {
    public func responseCodable<T: Decodable>(callback: @escaping (Result<T>) -> Void) {
        
        responseData(queue: nil) { response in
            switch response.result {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    callback(.success(try decoder.decode(T.self, from: value)))
                } catch let e {
                    if let result = response.result.value {
                        if let output = String(data: result, encoding: .utf8) {
                            print("failed to decode response:\n" + output + "\n========")
                        }
                    }
                    callback(.error(e))
                }
            case .failure(let e):
                callback(.error(e))
            }
        }
    }
}


class API {
    static let shared = API()
    
    static private let rootUrl = "https://api.deermichel.me:4000/api/v1/"
    
    private init() {
    }
    
    private var headers: HTTPHeaders? {
        if let authManager = AuthManager.shared {
            return ["Authorization" : "Bearer \(authManager.token)"]
        }
        return nil
    }
    
    func performRequest<T : Decodable>(route: Route, parameters: JSON?, callback: @escaping (Result<T>) -> Void) {
        
        Alamofire.request(route.url, method: route.method, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .responseCodable(callback: callback)
    }
    
    func reloadMe(token: String) {
        self.performRequest(route: .me, parameters: nil) { (result: Result<User>) in
            
            switch result {
            case .success(let user):
                AuthManager.shared?.user = user
                
            case .error(let error):
                print(error)
            }
        }
    }
    
    struct Route {
        
        // auth routes
        static let login = Route(method: HTTPMethod.post, path: "auth/login")
        static let register = Route(method: .post, path: "auth/register")
        static let logout = Route(method: .post, path: "auth/logout")
        
        // user routes
        static let me = Route(method: .get, path: "user/me")
        
        // message routes
        static let message_all = Route(method: .get, path: "message/all")
        static let message_send = Route(method: .post, path: "message/send")
        static let message_filter = Route(method: .get, path: "message/filter")
        
        //contact routes
        static let contact_all = Route(method: .get, path: "contact/all")
        static let contact_add = Route(method: .post, path: "contact/add")
        static let contact_delete = Route(method: .post, path: "contact/delete")
        
        var method: HTTPMethod
        var path: String
        
        var url: String {
            return API.rootUrl + self.path
        }
        
        func extendPath(suffix: String) -> Route {
            return Route(method: self.method, path: self.path + "/" + suffix)
        }
    }
}
