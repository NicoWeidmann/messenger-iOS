//
//  LoginViewController.swift
//  Messenger
//
//  Created by Nico Weidmann on 21.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // restoreToken()
    }
    
    private func restoreToken() {
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            print("found token in UserDefaults. Using it to log in.")
            AuthManager.create(user: nil, usingToken: token)
            API.shared.reloadMe(token: token)
            self.performSegue(withIdentifier: "proceedToChat", sender: nil)
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        print("sign in button pressed")
        
        guard let username = self.usernameTf.text,
            let password = self.passwordTf.text else {
                print("nono")
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
        
        // loading symbol pop-up
        let loadingOverlay = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingOverlay.label.text = "logging in"
        loadingOverlay.backgroundView.style = .solidColor
        loadingOverlay.backgroundView.color = .black
        loadingOverlay.backgroundView.alpha = 0.6
        
        let parameters: JSON = [
            "username": username,
            "password": password
        ]
        
        // DEBUG
        // self.performSegue(withIdentifier: "proceedToChat", sender: nil)
        
        API.shared.performRequest(route: .login, parameters: parameters) { (response: Result<AuthManager>) in
            loadingOverlay.hide(animated: true)
            switch response {
            case .error(let error):
                print(error)
                
                let errorAlert = UIAlertController(title: "Login failed", message: "I could have given you a proper error message, but I'm way too lazy :^)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    // nothing to do
                }))
                self.present(errorAlert, animated: true, completion: nil)
                
            case .success(let result):
                // store authentication data
                AuthManager.shared = result
                
                print("Manager created with Token \(result.token)")
                if let user = result.user {
                    print("logged in User is \(user.username) with email \(user.mail ?? "<no mail>") and id \(user.id)")
                } else {
                    print("logged in without a user")
                }
                
                try? SocketHandler.create()
                
                self.performSegue(withIdentifier: "proceedToChat", sender: nil)
            }
        }
    }
}
