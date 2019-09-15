//
//  LoginViewController.swift
//  MapApp
//
//  Created by Elias Hall on 8/19/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emailPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 0.0)) //left padding textfields
        let passWordPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 0.0))
        emailText.leftView = emailPadding
        passwordText.leftView = passWordPadding
        emailText.leftViewMode = .always
        passwordText.leftViewMode = .always
   }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = true //initially keeping activityIndicatior hidden
        loggingIn(false)
        emailText.text = "" //clearing email and password textfields for logout
        passwordText.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
                loggingIn(true) //login animation control //later try and set to false
                DispatchQueue.main.async {
                print("made it login tapped")
                    UdacityClient.createSessionId(username: self.emailText.text ?? "", password: self.passwordText.text ?? "", completion: self.handleLoginResponse(success: error:))
        
    }
    }
    
    

    @IBAction func signUpTapped(_ sender: Any) {
        let app = UIApplication.shared
         app.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")!, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        
        if success {
            print(UdacityClient.Auth.sessionId)
            performSegue(withIdentifier: "pushLogin", sender: nil)
        }
        else { print("Failure")
            
        }
        
//        let nextController = self.storyboard!.instantiateViewController(withIdentifier: "accessTab") as! UITabBarController
//
//        self.navigationController!.pushViewController(nextController,animated: true)
        
    }
    

    
    func handleSessionResponse(success: Bool, error: Error?) {
        
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }

    func loggingIn(_ login: Bool) { //UI changing function
        
        activityIndicator.isHidden = !login //activity controller appears when login is tapped
        if login {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }

        emailText.isEnabled = !login //disabling textfields and buttons
        passwordText.isEnabled = !login
        loginButton.isEnabled = !login
        signUpButton.isEnabled = !login

    }

}


