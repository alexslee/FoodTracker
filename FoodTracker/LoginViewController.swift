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
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            
            print("could not serialize json")
            return
        }
        
        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/login")!)
        
        req.httpBody = postJSON
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
            
            guard let data = data else {
                
                print("no data returned from server \(String(describing: err))")
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                
                print("no response returned from server \(String(describing: err))")
                return
            }
            
            guard let rawJson = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("data returned is not json, or not valid")
                return
            }
            
            guard resp.statusCode != 403 else {
                
                print("login failed")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        task.resume()
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
