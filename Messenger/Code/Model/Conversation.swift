//
//  Conversation.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

struct Conversation : Decodable {
    
    var partner : User
    var lastMessage : String
    // TODO
}
