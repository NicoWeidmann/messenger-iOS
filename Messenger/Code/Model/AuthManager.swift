//
//  AuthManager.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

class AuthManager : Decodable {
    
    // AuthManager singleton
    static var shared : AuthManager?
    
    var user : User?
    var token : String {
        didSet {
            UserDefaults.standard.set(AuthManager.shared?.token, forKey: "token")
        }
    }
    
    private init(_ user : User?, _ token : String) {
        self.user = user
        self.token = token
    }
    
    // creates the global AuthManager with the specified user and token
    // call this before accessing AuthManager.shared
    static func create(user : User?, usingToken token : String) {
        shared = AuthManager(user, token)
    }
}
