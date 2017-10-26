//
//  SocketHandler.swift
//  Messenger
//
//  Created by Nico Weidmann on 26.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation
import SocketIO

class SocketHandler {
    
    static var shared : SocketHandler? = nil
    private var socket : SocketIOClient
    
    init() throws {
        guard let token = AuthManager.shared?.token else {
            print("SocketHandler: ERROR: need token in order to establish connection")
            throw MissingTokenError(message: "SocketHandler: ERROR: need token in order to establish connection")
        }
        socket = SocketIOClient(socketURL: URL(string: API.rootUrl)!, config: [.connectParams(["auth_token": token]), .reconnects(true), .log(true)])
        addHandlers()
        print("SocketHandler: connecting to socket...")
        socket.connect()
    }
    
    func addHandlers() {
        socket.on("connect") { (response, ack) in
            print("SocketHandler: received 'connect' from socket. Ack expected: \(ack.expected). We're up and running!")
        }
        
        socket.on("error") { (response, ack) in
            print("SocketHandler: received 'error' from socket. Ack expected: \(ack.expected)")
        }
        
        socket.on("message") { (response, ack) in
            print("SocketHandler: received 'message' from socket. Ack expected: \(ack.expected)")
        }
    }
    
    static func create() throws {
        SocketHandler.shared = try SocketHandler()
    }
    
    struct MissingTokenError : Error {
        let message : String
    }
}
