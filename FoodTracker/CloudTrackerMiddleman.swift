//
//  CloudTrackerMiddleman.swift
//  FoodTracker
//
//  Created by Alex Lee on 2017-07-03.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

import Foundation
import UIKit

class CloudTrackerMiddleman: NSObject {
    
    //adapted from the sample post gist from https://gist.github.com/coryalder/564937412f145945bb9adcbd76725696
    public func post (postData: [String:String], completion: @escaping ([String:[String:String]])->Void) {
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("could not serialize json")
            return
        }
        
        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/signup")!)
        
        req.httpBody = postJSON
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(String(describing:err))")
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                print("no response returned from server \(String(describing:err))")
                return
            }
            
            guard let rawJson = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("data returned is not json, or not valid")
                return
            }
            
            guard resp.statusCode == 200 else {
                // handle error
                print("an error occurred")
                return
            }
            
            completion(rawJson as! [String:[String:String]])
        }
        
        task.resume()
    }
    
    public func login (postData: [String:String], completion: @escaping ([String:[String:String]])->Void) {
        
        
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
            
            completion(rawJson as! [String:[String:String]])
        }
        
        task.resume()
    }
}
