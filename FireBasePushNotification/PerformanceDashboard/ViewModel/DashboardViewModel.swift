//
//  DashboardViewModel.swift
//  FireBasePushNotification
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit

class DashboardViewModel: NSObject {
    
    var cardsArray = [dashboardCard]()
    var cardsArr: [[String: Any]]! = nil
    var cardsCacheURL: URL?
    let cardsCacheQueue = OperationQueue()
    
    func updateModel(view: UIView) {
        //Start loader to wait for response
        DispatchQueue.main.async {
            shareDeleagte.showLoader(withText: "Loading...", onView: view)
        }
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.cardsCacheURL = cacheURL.appendingPathComponent("cards.json")
        }
        
        let webCnctn = WebConnectionViewController()
        if webCnctn.isConnectedToNetwork() {
            // GET DATA FROM SERVER
            //Call the web service to update the model
            DashboardModel.getDataFromServer { (dashboardModel,success) in
                if success{
                    //Process on live data
                    self.cardsArr = dashboardModel?.arCards as! [[String : Any]]
                    self.setData(onView: view)
                    // Write the data to the cache
                    if (self.cardsCacheURL != nil) {
                          self.cardsCacheQueue.addOperation() {
                            if let stream = OutputStream(url: self.cardsCacheURL!, append: false) {
                                stream.open()
                                JSONSerialization.writeJSONObject(self.cardsArr, to: stream, options: [.prettyPrinted], error: nil)
                                stream.close()
                            }
                        }
                    }
                }
                else{
                    //failure case
                    self.getDataWhenOffline(onView: view)

                }
            }
        }
        else{
            //if no network is available then call the local storage for best user experience
            self.getDataWhenOffline(onView: view)
        }
    }
    
    // returns the total number of news sources
    func numberOfRowsInSection() -> Int {
        return self.cardsArray.count
    }
    
    func setData(onView: UIView){
        
       // let shuffuledArray = shuffle(cardArray: cardsArr as! NSArray)
        let shuffuledArray =  cardsArr! as NSArray

        for i in 0...shuffuledArray.count-1{
            var cardDict = dashboardCard()
            cardDict.scheme = (shuffuledArray[i] as! NSDictionary).value(forKey: "scheme") as? String
            let  urlString = (shuffuledArray[i] as! NSDictionary).value(forKey: "icon") as! String
            let url = URL(string: urlString)
            cardDict.icon = url
            cardDict.data_value = (shuffuledArray[i] as! NSDictionary).value(forKey: "data_value") as? String
            cardDict.pre_data_unit = (shuffuledArray[i] as! NSDictionary).value(forKey: "pre_data_unit") as? String
            cardDict.data_unit = (shuffuledArray[i] as! NSDictionary).value(forKey: "data_unit") as? String
            cardDict.small_text = (shuffuledArray[i] as! NSDictionary).value(forKey: "small_text") as? String
            cardDict.date = (shuffuledArray[i] as! NSDictionary).value(forKey: "date") as? String
            cardDict.web_link = (shuffuledArray[i] as! NSDictionary).value(forKey: "web_link") as? String
            self.cardsArray.append(cardDict)
        }
        
        
        //post the notification to update the view
        NotificationCenter.default.post(name: Helpers.DashboardUpdated, object: nil)
        
        // Stop the loader in main thread
        DispatchQueue.main.async {
            //hide the loader
            shareDeleagte.hideLoader(onView: onView)
        }
    }
    
    
    func getDataWhenOffline(onView: UIView){
        if (cardsCacheURL != nil) {
            // Read the data from the cache
            cardsCacheQueue.addOperation() {
                if let stream = InputStream(url: self.cardsCacheURL!) {
                    stream.open()
                    self.cardsArr = ((try? JSONSerialization.jsonObject(with: stream, options: [])) as? [[String: Any]]?)!
                    //self.cardsArr = json.mutableCopy() as! NSMutableArray
                    self.setData(onView: onView)
                    stream.close()
                }
                else{
                    //handle/show here Alert message here
                    DispatchQueue.main.async {
                        //hide the loader
                        shareDeleagte.hideLoader(onView: onView)
                    }
                }
                
                // Update the UI
                OperationQueue.main.addOperation() {
                    self.setData(onView: onView)
                }
            }
        }
        else{
            //handle for alert message here
            DispatchQueue.main.async {
                //hide the loader
                shareDeleagte.hideLoader(onView: onView)
            }
        }
    }
    
    
    
    func shuffle(cardArray :NSArray) -> NSArray {
        print(cardArray.count)

        let shuffledArray = NSMutableArray()
        for _ in 0...cardArray.count-1{
            let random  = Int(arc4random()) % cardArray.count
            if  shuffledArray.contains(cardArray[random]){
                //do nothing
            }
            else{
                shuffledArray.add(cardArray[random])
            }
        }
        print(shuffledArray)
        print(shuffledArray.count)
        return shuffledArray as NSArray
    }
}


