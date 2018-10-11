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
    
    func updateModel(view: UIView) {
        //Start loader to wait for response
        DispatchQueue.main.async {
            shareDeleagte.showLoader(withText: "Loading...", onView: view)
        }
        
        //Call the web service to update the model
        DashboardModel.getDataFromServer { (dashboardModel) in
            let arr = dashboardModel.arCards
        
            for i in 0...arr.count-1{
                var cardDict = dashboardCard()
                cardDict.scheme = (arr[i] as! NSDictionary).value(forKey: "scheme") as? String
                let  urlString = (arr[i] as! NSDictionary).value(forKey: "icon") as! String
                let url = URL(string: urlString)
                cardDict.icon = url
                cardDict.data_value = (arr[i] as! NSDictionary).value(forKey: "data_value") as? String
                cardDict.pre_data_unit = (arr[i] as! NSDictionary).value(forKey: "pre_data_unit") as? String
                cardDict.small_text = (arr[i] as! NSDictionary).value(forKey: "small_text") as? String
                cardDict.date = (arr[i] as! NSDictionary).value(forKey: "date") as? String
                cardDict.web_link = (arr[i] as! NSDictionary).value(forKey: "web_link") as? String
                
                self.cardsArray.append(cardDict)
                
            }
            
           // self.cardsArray = arr!
            
            //post the notification to update the view
            NotificationCenter.default.post(name: Helpers.DashboardUpdated, object: nil)
            
            // Stop the loader in main thread
            DispatchQueue.main.async {
                shareDeleagte.hideLoader(onView: view)
            }
        }
    }
    
    // returns the total number of news sources
    func numberOfRowsInSection() -> Int {
        return self.cardsArray.count
    }
}
