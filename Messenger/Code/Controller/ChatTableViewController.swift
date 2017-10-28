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
    
    // holds cached row heights to prevent jumping of tableView when scrolling
    private var rowHeights: [Int: CGFloat] = [:]
    
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
                    self.scrollChatToBottom(animated: true)
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = contact?.username
        
        // subscribe to keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe from keyboard event
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        UIView.animate(withDuration: (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    // making sure the view doesn't glich around when rotating the device with keyboard activated
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        super.viewWillTransition(to: size, with: coordinator)
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
                self.scrollChatToBottom(animated: false)
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
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
        messageTf.text = nil
        API.shared.performRequest(route: .message_send, parameters: parameters) { (response: Result<Message>) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let result):
                print("successfully sent message '\(result.message)'")
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
        cell.dateLabel.text = message.timestamp.formatDateCustom()
        
        // cache cell height
        self.rowHeights[indexPath.row] = cell.bounds.height
        return cell
    }
    
    private func scrollChatToBottom(animated: Bool) {
        self.chatTable.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = rowHeights[indexPath.row] {
            return height
        }
        return 53 // good average value, as most messages are only one line
        
    }
}
