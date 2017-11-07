//
//  ConversationsTableViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit

class ConversationsTableViewController: UITableViewController, ConversationManagerListener {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConversationManager.shared.update()
        ConversationManager.shared.addListener(listener: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationManager.shared.conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let conversation = ConversationManager.shared.conversations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        
        cell.nameLabel.text = conversation.foreign?.username
        cell.messageLabel.text = conversation.last_message.message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChat" {
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            let contact = ConversationManager.shared.conversations[indexPath.row].foreign
            (segue.destination as! ChatTableViewController).contact = contact
        }
    }
    
    func notify(origin: ConversationManager) {
        self.tableView.reloadData()
    }
}
