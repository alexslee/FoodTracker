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
    
    public func postMeal(meal: Meal, completion: @escaping ([String:[String:Any]])->Void){
        //upload the meal
        let mealReq = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/users/me/meals")!)
        let postData = ["title":meal.name,
                              "calories":meal.calories,
                              "description":meal.mealDescription] as [String : Any]
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            
            print("could not serialize json")
            return
        }
        
        mealReq.httpBody = postJSON
        mealReq.httpMethod = "POST"
        let user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
        let token = user.value(forKey: "token")
        mealReq.addValue(token as! String, forHTTPHeaderField: "token")
        mealReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let mealTask = URLSession.shared.dataTask(with: mealReq as URLRequest) {
            (data,resp,err) in
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
            
            guard resp.statusCode == 200 else {
                
                print("meal post failed")
                return
            }
            completion(rawJson as! [String:[String:Any]])
            
        }
        mealTask.resume()
    }
    
    public func postMealImage(meal:Meal,completion:@escaping (NSError?)->(Void)) {
        //upload the meal image
        
        var rawURLString = "http://159.203.243.24:8000/users/me/meals/"
        rawURLString += String(meal.id)
        rawURLString += "/photo"
        
        var req = URLRequest(url: URL(string:rawURLString)!)
        
        guard let photo = meal.photo else{
            return
        }
        
        guard let photoData = UIImageJPEGRepresentation(photo, 0.9) else{
            return
        }
        
        req.httpBody = photoData
        req.httpMethod = "POST"
        
        let user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
        let token = user.value(forKey: "token")
        
        req.addValue(token as! String, forHTTPHeaderField: "token")
        req.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, resp: URLResponse?, err: Error?) in
            
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
            
            guard resp.statusCode == 200 else {
                
                print("photo post failed")
                return
            }
            
            completion(err as NSError?)
            
        }
        
        task.resume()
    }
}
