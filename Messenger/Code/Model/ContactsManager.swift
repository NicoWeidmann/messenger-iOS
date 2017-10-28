//
//  ContactsManager.swift
//  Messenger
//
//  Created by Nico Weidmann on 23.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

class ContactsManager {
    
    var contacts : [User] = [] {
        didSet {
            notifyListeners()
        }
    }
    private var listeners : [ContactsManagerListener] = []
    
    static var shared : ContactsManager = ContactsManager()
    
    private init() {
        // we'll listen to user events to update the last seen status
        SocketHandler.shared?.onUser(callback: { (user) in
            for (i, current) in self.contacts.enumerated() {
                if current.id == user.id {
                    // found the culprit :D replacing him with the updated version
                    self.contacts.remove(at: i)
                    self.contacts.insert(user, at: i)
                    return
                }
            }
        })
    }
    
    func update() {
        print("ContactsManager: updating contacts")
        API.shared.performRequest(route: .contact_all, parameters: nil) { (response : Result<ContactsContainer>) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let result):
                self.contacts = result.contacts
            }
            print("ContactsManager: updated contacts")
        }
    }
    
    func addListener(listener : ContactsManagerListener) {
        listeners.append(listener)
    }
    
    private func notifyListeners() {
        print("ContactsManager: Notifying listeners with following contacts:")
        contacts.forEach { (user) in
            print(user.username)
        }
        self.listeners.forEach({ (listener) in listener.notify(origin: self) })
    }
}

protocol ContactsManagerListener {
    func notify(origin : ContactsManager) -> Void
}
