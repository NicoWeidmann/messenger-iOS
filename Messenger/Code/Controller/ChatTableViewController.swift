//
//  ChatTableViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit

class ChatTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageTf: UITextField!
    
    private var messages: [Message] = []
    
    // the conversation partner
    var contact: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadMessages()
        SocketHandler.shared?.onMessage(callback: { (message) in
            if message.sender.id == self.contact?.id || message.sender.id == AuthManager.shared?.user?.id {
                if !self.messages.contains(where: { existing -> Bool in existing.id == message.id }) {
                    // message is new
                    self.messages.append(message)
                    self.chatTable.reloadData()
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = contact?.username
    }
    
    func reloadMessages() {
        
        guard let user_id = contact?.id else {
            print("ChatTableViewController: contact is nil but needed")
            return
        }
        
        API.shared.performRequest(route: API.Route.message_filter.extendPath(suffix: user_id), parameters: nil) { (response: Result<MessageContainer>) -> Void in
            switch response {
            case .error(let error):
                print(error)
            case .success(let result):
                self.messages = result.messages
                self.chatTable.reloadData()
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = messageTf.text else {
            print("ChatTableViewController: missing reference to messageTf!")
            return
        }
        guard !text.isEmpty else {
            messageTf.becomeFirstResponder()
            return
        }
        let parameters = [
            "recipient": contact?.id as Any,
            "message": text
        ]
        API.shared.performRequest(route: .message_send, parameters: parameters) { (response: Result<Message>) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let result):
                self.messages.append(result)
                self.chatTable.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let message = self.messages[row]
        
        let cellType = (message.sender.id != AuthManager.shared?.user?.id) ? "foreignMessageCell" : "ownMessageCell"
        let cell: ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! ChatTableViewCell
        
        cell.messageLabel.text = message.message
        if (cellType != "ownMessageCell") {
            // don't set name for own messages (leave 'You')
            cell.nameLabel.text = message.sender.username
        }
        
        var dateStyle : DateFormatter.Style = .short
        var timeStyle : DateFormatter.Style = .none
        
        if Date().timeIntervalSince(message.timestamp).isLess(than: 24*60*60) {
            dateStyle = DateFormatter.Style.none
            timeStyle = DateFormatter.Style.short
        }
        
        cell.dateLabel.text = DateFormatter.localizedString(from: message.timestamp, dateStyle: dateStyle, timeStyle: timeStyle)
        
        return cell
    }
}
