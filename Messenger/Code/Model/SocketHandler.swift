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
    
    var connected : Bool {
        get {
            return socket.status == SocketIOClientStatus.connected
        }
    }
    
    private var messageListeners : [(Message) -> Void] = []
    private var userListeners : [(User) -> Void] = []
    
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
    
    private func addHandlers() {
        socket.on("connect") { (response, ack) in
            print("SocketHandler: received 'connect' from socket. Ack expected: \(ack.expected). We're up and running!")
        }
        
        socket.on("error") { (response, ack) in
            print("SocketHandler: received 'error' from socket. Ack expected: \(ack.expected)")
        }
        
        socket.on("message") { (response, ack) in
            print("SocketHandler: received 'message' from socket. Ack expected: \(ack.expected)")
            do {
                let json = try JSONSerialization.data(withJSONObject: response[0], options: .prettyPrinted)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom(customISODateDecoder)
                let message = try decoder.decode(Message.self, from: json)
                self.messageListeners.forEach({ (listener) in
                    listener(message)
                })
            } catch let e {
                print("SocketHandler: Error decoding message:")
                print(e)
            }
        }
        
        socket.on("user") { (response, ack) in
            print("SocketHandler: received 'user' from socket. Ack expected: \(ack.expected)")
            do {
                let json = try JSONSerialization.data(withJSONObject: response[0], options: .prettyPrinted)
                let user = try JSONDecoder().decode(User.self, from: json)
                self.userListeners.forEach({ (listener) in
                    listener(user)
                })
            } catch let e {
                print("SocketHandler: Error decoding user:")
                print(e)
            }
        }
    }
    
    static func create() throws {
        SocketHandler.shared = try SocketHandler()
    }
    
    struct MissingTokenError : Error {
        let message : String
    }
    
    func onMessage(callback: @escaping (Message) -> Void) {
        messageListeners.append(callback)
    }
    
    func onUser(callback: @escaping (User) -> Void) {
        userListeners.append(callback)
    }
}
