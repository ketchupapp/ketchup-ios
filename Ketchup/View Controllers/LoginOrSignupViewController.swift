//
//  LoginOrSignupViewController.swift
//  Ketchup
//
//  Created by Brian Dorfman on 3/10/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import UIKit

class LoginOrSignupViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailField.text,
            let password = passwordField.text else {
                return
        }
        LoggedInUser.login(email: email, password: password) { success, error in
            if success {
                // Do nothing, AppDelegate swaps root VC automatically on login change
            } else if let error = error as? LocalizedError {
                // Show error
                self.showError(error)
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        guard let email = emailField.text,
            let password = passwordField.text else {
                return
        }
        
        LoggedInUser.signup(email: email, password: password) { success, error in
            if success {
                // Do nothing, AppDelegate swaps root VC automatically on login change
            } else if let error = error as? LocalizedError {
                // Show error
                self.showError(error)
            }
        }
    }
    
    func showError(_ error: LocalizedError) {
        let alert = UIAlertController(title: "Error",
                                      message: error.errorDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
