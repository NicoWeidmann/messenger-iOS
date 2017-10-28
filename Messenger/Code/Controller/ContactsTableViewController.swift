//
//  ContactsTableViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 22.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController, ContactsManagerListener {
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let pressedLocation = sender.location(in: self.tableView)
            if let pressedIndexPath = tableView.indexPathForRow(at: pressedLocation) {
                let selectedContact = ContactsManager.shared.contacts[pressedIndexPath.row]
                
                // show confirmation alert
                let confirmDelete = UIAlertController(title: "Delete \(selectedContact.username)?", message: nil, preferredStyle: .alert)
                confirmDelete.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                confirmDelete.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    let parameters = [
                        "user": selectedContact.id
                    ]
                    API.shared.performRequest(route: .contact_delete, parameters: parameters, callback: { (response : Result<ContactsContainer>) in
                        switch response {
                        case .error(let error):
                            print(error)
                        case .success(let result):
                            // update contact manager
                            ContactsManager.shared.contacts = result.contacts
                        }
                    })
                }))
                self.present(confirmDelete, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadContacts()
        ContactsManager.shared.addListener(listener: self)
        // add long press gesture recognizer for delete contact action
        self.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(ContactsTableViewController.longPress(_:))))
    }

    private func reloadContacts() {
        print("ContactsTableViewController: reloading contacts")
        ContactsManager.shared.update()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactsManager.shared.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contact = ContactsManager.shared.contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
        
        cell.nameLabel.text = contact.username
        
        switch contact.last_seen {
        case .online:
            cell.lastSeenLabel.textColor = UIColor.green
            cell.lastSeenLabel.text = "online"
        case .offline(let lastSeen):
            cell.lastSeenLabel.textColor = UIColor.lightGray
            cell.lastSeenLabel.text = "last seen: \(lastSeen.formatDateCustom())"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func notify(origin: ContactsManager) {
        print("ContactsTableViewController: Notified of updated Contacts")
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChat" {
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            let contact = ContactsManager.shared.contacts[indexPath.row]
            (segue.destination as! ChatTableViewController).contact = contact
        }
    }
}
