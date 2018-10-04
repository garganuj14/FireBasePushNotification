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
               let strToken = ""
                
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
