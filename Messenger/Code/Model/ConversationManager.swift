//
//  ConversationManager.swift
//  Messenger
//
//  Created by Nico Weidmann on 07.11.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

class ConversationManager {
    
    var conversations : [Conversation] = [] {
        didSet {
            notifyListeners()
        }
    }
    
    private var listeners : [ConversationManagerListener] = []
    
    static var shared : ConversationManager = ConversationManager()
    
    private init() {
        SocketHandler.shared?.onMessage(callback: { (message) in
            // foreign conversation partner
            guard let user = AuthManager.shared?.user else {
                print("ERROR: Missing authenticated user!")
                return
            }
            let foreign = message.recipient == user ? message.sender : message.recipient
            
            // reload conversation with this partner
            API.shared.performRequest(route: API.Route.conversation_with.extendPath(suffix: foreign.id), parameters: nil, callback: { (response : Result<Conversation>) in
                switch response {
                case .error(let error):
                    print(error)
                case .success(let result):
                    // update conversation object
                    for (i, conversation) in self.conversations.enumerated() {
                        if conversation == result {
                            self.conversations.remove(at: i)
                            self.conversations.insert(result, at: 0)
                        }
                    }
                }
            })
        })
    }
    
    func update() {
        print("ConversationManager: Updating Conversations")
        API.shared.performRequest(route: .conversation_all, parameters: nil) { (response : Result<ConversationContainer>) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let result):
                self.conversations = result.conversations
            }
            print("ConversationManager: Updated Conversations")
        }
    }
    
    func addListener(listener : ConversationManagerListener) {
        self.listeners.append(listener)
    }
    
    private func notifyListeners() {
        self.listeners.forEach { (listener) in
            listener.notify(origin: self)
        }
    }
    
}

protocol ConversationManagerListener {
    func notify (origin: ConversationManager) -> Void
}
