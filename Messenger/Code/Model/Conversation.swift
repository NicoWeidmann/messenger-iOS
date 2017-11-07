//
//  Conversation.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

struct Conversation : ModelObject, Decodable {
    
    var last_message : SparseMessage
    var participants : [User]
    var id : String
    
    // the conversation partner that is not the user himself
    // returns nil if foreign user cannot be determined
    var foreign : User? {
        get {
            guard let user = AuthManager.shared?.user else {
                print("Missing authenticated user!")
                return nil
            }
            for i in participants {
                if !(i == user) {
                    return i
                }
            }
            return nil
        }
    }
}


