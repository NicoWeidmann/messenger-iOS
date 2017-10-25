//
//  ConversationsTableViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit

class ConversationsTableViewController: UITableViewController {
    
    private var conversations: [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadConversations()
    }
    
    func reloadConversations() {
        
        let fakeUser : User = User(username: "Donald J. Trump", mail: "nomail", id: "noid")
        let fakeConf : Conversation = Conversation(partner: fakeUser, lastMessage: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        
        let fakeConf2 = Conversation(partner: fakeUser, lastMessage: "")
        
        conversations = [fakeConf, fakeConf2, fakeConf]
        // TODO implemented as soon as API provides functionality
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let conversation = self.conversations[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        
        cell.nameLabel.text = conversation.partner.username
        cell.messageLabel.text = conversation.lastMessage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
}
