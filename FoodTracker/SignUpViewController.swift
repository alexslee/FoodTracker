//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Alex Lee on 2017-07-03.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        passwordField.delegate = self
        usernameField.delegate = self
        signUpButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        signUpButton.isEnabled = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((passwordField.text?.characters.count) != nil && textField.text!.characters.count >= 6) {
            signUpButton.isEnabled = true
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard usernameField.text as String! != nil else {
            return
        }
        guard passwordField.text as String! != nil else {
            return
        }
        
        let userData = ["username":usernameField.text ?? "",
            "password":passwordField.text ?? ""]
        
        let cloudTracker = CloudTrackerMiddleman()
        
        cloudTracker.post(postData: userData, completion: {
            (data) in
            UserDefaults.standard.set(data["user"], forKey: "user")
            self.dismiss(animated: true, completion: nil)
            
        })
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
