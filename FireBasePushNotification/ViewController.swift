//
//  ViewController.swift
//  FireBasePushNotification
//
//  Created by Welcome on 13/09/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit

/*class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // SendData_API(url: self.url, fcm_ID: self.fcmId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}*/


class ViewController: UIViewController {
        var users: [[String: Any]]! = nil
        
        var userCacheURL: URL?
        let userCacheQueue = OperationQueue()
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if (users == nil) {
                // Load the data from the server
                AppDelegate.serviceProxy.invoke("GET", path: "/users") { result, error in
                    if (error == nil) {
                        self.users = result as? [[String: Any]]
                        
                        self.tableView.reloadData()
                        
                        // Write the data to the cache
                        if (self.userCacheURL != nil) {
                            self.userCacheQueue.addOperation() {
                                if let stream = OutputStream(url: self.userCacheURL!, append: false) {
                                    stream.open()
                                    
                                    JSONSerialization.writeJSONObject(result!, to: stream, options: [.prettyPrinted], error: nil)
                                    
                                    stream.close()
                                }
                            }
                        }
                    } else if (self.userCacheURL != nil) {
                        // Read the data from the cache
                        self.userCacheQueue.addOperation() {
                            if let stream = InputStream(url: self.userCacheURL!) {
                                stream.open()
                                
                                self.users = (try? JSONSerialization.jsonObject(with: stream, options: [])) as? [[String: Any]]
                                
                                stream.close()
                            }
                            
                            // Update the UI
                            OperationQueue.main.addOperation() {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        
    }

