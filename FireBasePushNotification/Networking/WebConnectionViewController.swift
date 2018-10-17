//
//  WebConnectionViewController.swift
//  Chrip
//
//  Created by Ankur Garg on 6/7/17.
//  Copyright © 2017 xyz. All rights reserved.
//

import UIKit
import SystemConfiguration

class WebConnectionViewController: UIViewController {
 
    func downloadData(fromUrl: String,isAuthenticRequest : Bool, postObject :[String : Any]?,requestType : String , compHandler:@escaping (Data?, Error?)->Void ){

        if isConnectedToNetwork()
        {
            let url = NSURL(string: fromUrl)
            let request = NSMutableURLRequest.init(url: url! as URL)
            
            //Request Type GET/POST
            request.httpMethod = requestType
            
            //For Authentic token
            if isAuthenticRequest{
               // let strToken = UserDefaults.standard.value(forKey: "tokenstring")as! String
               let strToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJwcmluY2lwYWwiOiJINHNJQUFBQUFBQUFBSlZTUFU4VVVSUzlzKzRHQ0ltQUVSTUtiSVNPek1hUGJodUJyQ1ptQW9aMUcwd2tiMmN1NDF2ZXZEZThEOWh0ekZaYVVHQlVFcU5cL2dYK2lqVFwvQWFFRkxiZXQ5dzhJc05JUlh6ZHgzNXB4eno1bmpVNmdaRFk5VHpiZ3dZUzVjeW1Wb2NzMWxhakIybXR0KzZBenFCRzJCZUY0QTJ6U0JzeE5VSUlpZ3doTUxkNkl1MjJOMXdXUmFYKzkwTWJhTm5vWkhTcWREeG0zTk10eFhlaWU4NEk2Vnhrc0NKWFh3clFKam16REQ0bGc1YWRlVWJQWnlyakhaaE9seUZxbDR4NDltWTdwQmFUa1RaaFE2aHBKMUJDWVJUREpuM3lwUzVXZ3NUSjJaZFphTGVndHRJNEx4bkJsRDdxNXMwckxldXJcLzNOaVZ0c0F2dm9OckxBenFVM2FLSGhwNG5YRlZDME5aY1NiUFFscGxLK0RiMzRzUVwvbVBcLzA2XC9EN29GMEJvRXlXcnYrbW5NK3R3T0RIbTNcLzNpNkNEMk1LOUVlc2xyTkhMeWMxTXlmeEtvMWYrXC9mWGw1NlBURDY5dmtiSkhQTHQ1SHd2THcrVDZxeXJMbVdaV2pYUkV0UHRWXC8wemtLOWVUbjdmUUQxczh5d1hTSHlVdEpoY1NKVEd0VzlWS25PZHRZV0pqUFdwdXRWdk5EZjkyTjJVNlpkSjFIejU1bW1aa2x2Z3o4bkM3aU1CM0YwYUttanM0K2ZqejhNRWY0bnNCdFQwbUhGSUQweVZveldVZDFPK1BqK1ludlwvdzlLUFlaXC90dTFcLzN5bmJXRWZBd0FBIiwic3ViIjoiZ2FyZ2FudWoxNEBnbWFpbC5jb20iLCJyb2xlcyI6WyJST0xFX1VTRVIiXSwiZXhwIjoxNTM5MjQ5MzMwLCJpYXQiOjE1Mzg5ODkzMzB9.MxmcbvAz-JSuAuTppDjrczFvKOQ7II9MLu5u6194EKA"
                
                print(strToken)
                let headers = [
                    "authorization": strToken
                ]
                request.allHTTPHeaderFields = headers
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            if requestType == "POST"{
                print(postObject!)
                let myTmpDict = postObject as! NSDictionary
                
                let jsonData = try? JSONSerialization.data(withJSONObject: myTmpDict, options: .prettyPrinted)
               // print(jsonData ?? "Result")
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            // make the request
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                // do stuff with response, data & error here
                print("data ",data as Any)
                print("crash")
                
                //Call completion handler clouser
                compHandler(data, error)
            })
            task.resume()
        }else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.NetworkCheck()
            let vc = ViewController()
            vc.getDataWhenOffline()
            
        }
    }
    
     func isConnectedToNetwork() -> Bool
     {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
     
    }
}
