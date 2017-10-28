//
//  AddContactViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 23.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit

class AddContactViewController: ViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private var searchResults : [User] = []

    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let result = searchResults[row]
        
        let cell : ContactsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
        
        cell.profileImageView.image = nil
        cell.nameLabel.text = result.username
        cell.lastSeenLabel.text = result.mail
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // search bar has no content
            searchResults = []
            self.resultTable.reloadData()
        } else {
            let parameters = [
                "q": searchText
            ]
            API.shared.performRequest(route: .user_search, parameters: parameters, callback: { (response : Result<UserSearchContainer>) in
                switch response {
                case .error(let error):
                    print(error)
                case .success(let result):
                    self.searchResults = result.users
                    self.resultTable.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = self.searchResults[indexPath.row]
        let parameters = [
            "user": selected.id
        ]
        API.shared.performRequest(route: .contact_add, parameters: parameters) { (response: Result<ContactsContainer>) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let result):
                ContactsManager.shared.contacts = result.contacts
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
