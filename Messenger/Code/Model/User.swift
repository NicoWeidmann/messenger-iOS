//
//  User.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

struct User : Decodable {
    var username : String
    var mail : String?
    var id : String
    
}
