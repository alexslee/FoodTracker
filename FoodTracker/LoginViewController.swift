//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Alex Lee on 2017-07-03.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard.value(forKey: "user")
        guard let userDict = defaults as? [String:String] else {
            return
        }
        
        guard (usernameField.text! as String) == (userDict["username"]) else {
            return
        }
        
        let postData = [
            "username": usernameField.text ?? "",
            "password": passwordField.text ?? ""
        ]
        
        let CloudTracker = CloudTrackerMiddleman()
        CloudTracker.login(postData: postData, completion: {
            (data) in
            
            guard userDict["username"] == data["user"]!["username"] else {
                print("bad login attempt")
                return
            }
            
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
