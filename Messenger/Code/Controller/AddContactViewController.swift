//
//  AddContactViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 23.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit

class AddContactViewController: ViewController {

    @IBOutlet weak var usernameTf: UITextField!
    
    @IBAction func add(_ sender: UIButton) {
        guard let username = usernameTf.text else {
            print("critical error: expected IBOutlet but found none!")
            return
        }
        
        guard !username.isEmpty else {
            self.usernameTf.becomeFirstResponder()
            return
        }
        
        let parameters = [
            "user": username
        ]
        
        API.shared.performRequest(route: .contact_add, parameters: parameters) { (response : Result<ContactsContainer>) in
            switch response {
                case .error(let error):
                    print(error)
                case .success(let result):
                    ContactsManager.shared.contacts = result.contacts
                    self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernameTf.becomeFirstResponder()
    }
}
