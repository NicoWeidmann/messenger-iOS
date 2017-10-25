//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController {

    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    
    @IBAction func register(_ sender: UIButton) {
        // register button clicked
        guard let username = self.usernameTf.text,
            let password = self.passwordTf.text,
            let email = self.emailTf.text else {
                print("IBOutlets missing but required :/")
                return
        }
        
        guard !username.isEmpty else {
            self.usernameTf.becomeFirstResponder()
            return
        }
        
        guard !password.isEmpty else {
            self.passwordTf.becomeFirstResponder()
            return
        }
        
        guard !email.isEmpty else {
            self.emailTf.becomeFirstResponder()
            return
        }
        
        let parameters: JSON = [
            "username": username,
            "password": password,
            "mail": email
        ]
        
        API.shared.performRequest(route: .register, parameters: parameters) { (response: Result<AuthManager>) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let result):
                // store authentication data
                AuthManager.shared = result
                
                // do some debugging :)
                print("Manager created with Token \(result.token)")
                if let user = result.user {
                    print("logged in User is \(user.username) with email \(user.mail ?? "<no mail>")")
                } else {
                    print("logged in without a user")
                }
                
                self.performSegue(withIdentifier: "proceedToChat", sender: nil)
            }
        }
    }
}
