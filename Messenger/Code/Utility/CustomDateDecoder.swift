//
//  CustomDateDecoder.swift
//  Messenger
//
//  Created by Nico Weidmann on 27.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

func customISODateDecoder(dateDecoder : Decoder) throws -> Date {
    
    let container = try dateDecoder.singleValueContainer()
    let dateStr = try container.decode(String.self)

    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    if let date = formatter.date(from: dateStr) {
        return date
    }
    print("API: Error decoding date: \(dateStr)")
    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date does not match expected ISO 8601 format.")
}
