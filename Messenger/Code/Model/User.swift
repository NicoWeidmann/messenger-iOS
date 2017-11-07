//
//  User.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

struct User : ModelObject, Decodable {
    var username : String
    var mail : String?
    var id : String
    
    // the time the user was last seen
    var last_seen : LastSeen
    
    // contacts are only provided for the logged in user
    var contacts : [User]?
}

enum LastSeen : Decodable {
    case online()
    case offline(Date)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        
        if raw == "online" {
            // user is currently online
            self = .online()
        } else {
            // trying to decode date
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: raw) {
                self = .offline(date)
            } else {
                // failed to decode date :(
                print("failed decoding '\(raw)' into a valid date for last seen.")
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date does not match expected ISO 8601 format.")
            }
        }
    }
}
