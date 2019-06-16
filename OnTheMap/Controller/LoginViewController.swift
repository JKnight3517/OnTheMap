//
//  ViewController.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/26/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import UIKit
import MapKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setUI(true)
        guard (((usernameTextField?.text) != nil) && ((passwordTextField?.text) != nil)) else {
            showLoginFailure(message: "Please enter a Username and a password to login.")
            return
        }
        var requestObject = RequestSession(username: usernameTextField.text!, password: passwordTextField.text!)
        UdacityClient.Login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }

    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            self.setUI(false)
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            print("made it here")
            self.setUI(false)
            self.showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            UIApplication.shared.open(UdacityClient.Endpoints.createNewAccount.url, options: [:], completionHandler: nil)
        }
    }
    
    // Disables UI components and activates spinning acivity indicator
    func setUI(_ disabled: Bool) {
        if disabled {
            activityIndicator.startAnimating()
            self.view.alpha = 0.75
        } else {
            activityIndicator.stopAnimating()
            self.view.alpha = 1.0
        }
        activityIndicator.isHidden = !disabled
        usernameTextField.isEnabled = !disabled
        passwordTextField.isEnabled = !disabled
        loginButton.isEnabled = !disabled
        signUpButton.isEnabled = !disabled
    }
    
    // Call when wanting to display errors on top of UI
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
