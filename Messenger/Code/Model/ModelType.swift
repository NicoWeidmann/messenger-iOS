//
//  ModelType.swift
//  Messenger
//
//  Created by Nico Weidmann on 07.11.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

protocol ModelObject : Decodable {
    var id : String { get set }
}

func ==(lhs: ModelObject, rhs: ModelObject) -> Bool {
    return lhs.id == rhs.id
}
