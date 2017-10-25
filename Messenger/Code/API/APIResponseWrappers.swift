//
//  APIResponseWrappers.swift
//  Messenger
//
//  Created by Nico Weidmann on 23.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

struct ContactsContainer : Decodable {
    var contacts : [User]
}

struct MessageContainer : Decodable {
    var messages: [Message]
}
