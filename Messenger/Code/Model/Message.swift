//
//  Message.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

struct Message : ModelObject, Decodable {
    var recipient : User
    var sender : User
    var message : String
    var timestamp : Date
    var id : String
}

struct SparseMessage : ModelObject, Decodable {
    var recipient : String
    var sender : String
    var message : String
    var timestamp : Date
    var id : String
}
