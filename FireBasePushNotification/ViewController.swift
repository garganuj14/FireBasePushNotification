//
//  ViewController.swift
//  FireBasePushNotification
//
//  Created by Welcome on 13/09/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController{
    
    @IBOutlet weak var tbleNotification: UITableView!
    var users: [[String: Any]]! = nil
    var userCacheURL: URL?
    let userCacheQueue = OperationQueue()
    var arrNotifications: NSArray = []
    
    let url = "http://ec2-52-221-214-77.ap-southeast-1.compute.amazonaws.com:8080/ChirpApp/api/notification/getNotifications"
    let webCnctn = WebConnectionViewController()

    override func viewDidLoad() {
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            userCacheURL = cacheURL.appendingPathComponent("users.json")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if webCnctn.isConnectedToNetwork() {
            // GET DATA FROM SERVER
            MBProgressHUD.showAdded(to: self.view, animated: true)
            getAppNotificationApi(strURL: url as NSString)
        }
        else{
            //if no network is available then call the local storage for best user experience
            self.getDataWhenOffline()
        }
    }
    
    //Get All category WebApis
    func getAppNotificationApi(strURL: NSString) {
        
        webCnctn.downloadData(fromUrl: strURL as String, isAuthenticRequest: true, postObject: nil, requestType: "GET", compHandler:{ data, error in
            if (error != nil) {
                DispatchQueue.main.async {
                    //  Helpers().showAlertMessage(viewController: self, title: "Alert!", msg:MessageStringFile().invalidDataMsg())
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            else{
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray {
                        print(json)
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.arrNotifications = json.mutableCopy() as! NSArray
                            self.tbleNotification.reloadData()
                            
                            // Write the data to the cache
                            if (self.userCacheURL != nil) {
                                self.userCacheQueue.addOperation() {
                                    if let stream = OutputStream(url: self.userCacheURL!, append: false) {
                                        stream.open()
                                        
                                        JSONSerialization.writeJSONObject(self.arrNotifications, to: stream, options: [.prettyPrinted], error: nil)
                                        
                                        stream.close()
                                    }
                                }
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                    self.getDataWhenOffline()
                }
            }
        })
    }
    
    
    
    func getDataWhenOffline(){
        if (self.userCacheURL != nil) {
            // Read the data from the cache
            self.userCacheQueue.addOperation() {
                if let stream = InputStream(url: self.userCacheURL!) {
                    stream.open()
                    
                    self.arrNotifications = (try? JSONSerialization.jsonObject(with: stream, options: [])) as? [[String: Any]]? as! NSArray
                    // self.arrNotifications = json.mutableCopy() as! NSArray
                    DispatchQueue.main.async {
                        self.tbleNotification.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                    }
                    stream.close()
                }
                
                // Update the UI
                OperationQueue.main.addOperation() {
                    self.tbleNotification.reloadData()
                }
            }
        }
    }
    
}




extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableview datasource and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrNotifications.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict = self.arrNotifications[indexPath.row]
        let url = (dict as! NSDictionary).value(forKey: "userImage") as? String
        // retrun the details cell
        
        // if url != nil{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetail", for: indexPath)as! NotificationCell
        _ = URL(string: url ?? "")
        cell.lblNotifications.text = (dict as! NSDictionary).value(forKey: "message") as? String
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

