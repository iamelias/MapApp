//
//  LoginViewController.swift
//  MapApp
//
//  Created by Elias Hall on 8/19/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad() //setting up login textfields
        emailText.delegate = self
        passwordText.delegate = self
        activityIndicator.isHidden = true
        let emailPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 0.0)) // padding textfields
        let passWordPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 0.0))
        emailText.leftView = emailPadding
        passwordText.leftView = passWordPadding
        emailText.leftViewMode = .always
        passwordText.leftViewMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //clearView()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loggingIn(true) //login animation control //later try and set to false
        DispatchQueue.main.async {
            //print("made it login tapped")
            UdacityClient.createSessionId(username: self.emailText.text ?? "", password: self.passwordText.text ?? "", completion: self.handleLoginResponse(success: error:))
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        //ErrorDataStruct.ErrorStatus.removeAll
        if success {
            // print(AuthStruct.sessionId)
            performSegue(withIdentifier: "pushLogin", sender: nil) //push to mapview
        }
        else {
            // print("********************: \(String(describing: error))")
            loginFail(message: ErrorDataStruct.ErrorMessage ?? "Connection Issue" ) //calling loginfail alert
            ErrorDataStruct.ErrorMessage = nil
        }
        
        self.loggingIn(false) //resetting view activations
        self.clearView() //resetting view
        
    }
    
    func loginFail(message: String) {//login fail alert
        let alertBox = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertBox.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        show(alertBox, sender: nil)
        
    }
    
    func clearView() {
        activityIndicator.isHidden = true //initially keeping activityIndicatior hidden
        loggingIn(false) //activing deactivating view objects
        emailText.text = "" //clearing email and password textfields for logout
        passwordText.text = ""
    }
    
    @IBAction func signUpTapped(_ sender: Any) { //signup link button
        let app = UIApplication.shared
        app.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")!, options: [:], completionHandler: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
}


