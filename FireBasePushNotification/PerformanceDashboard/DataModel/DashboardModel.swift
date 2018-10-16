//
//  DashboardModel.swift
//  TransformingIndia
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit

struct DashboardModel {
   // let status : String?
   // let totalResults : Int?
    var arCards : NSMutableArray
    var cards : [dashboardCard]?

    init(arCards : NSMutableArray) {
        self.arCards = arCards
    }
}


struct dashboardCard {
    var scheme: String?
    var small_text : String?
    var pre_data_unit: String?
    var data_unit : String?
    var icon: URL?
    var data_value: String?
    var date : String?
    var web_link : String?
    

//    "scheme" : Amount of GST collected till September, 2018,
//    "icon" : https:\/\/48months.mygov.in\/wp-content\/uploads\/2018\/08\/10000000001326906762.png,
//    "data_value" : 13186190000000,
//    "pre_data_unit" : Rs. ,
//    "data_unit" : ,
//    "small_text" : Amount of GST collected till September, 2018 ,
//    "date" : 08\/10\/2018 ,
//    "web_link" :

    
    
 /*   enum CodingKeys: String, CodingKey {
        case scheme
        case small_text
        case pre_data_unit
        case data_unit
        case icon
        case data_value
        case date
        case web_link
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        small_text = try values.decodeIfPresent(String.self, forKey: .small_text)
        let urlString = try values.decodeIfPresent(String.self, forKey: .icon)
        icon = URL(string: urlString!)
        data_value = try values.decodeIfPresent(String.self, forKey: .data_value)
        data_unit = try values.decodeIfPresent(String.self, forKey: .data_unit)
    }*/
}


extension DashboardModel {
    public static func getDataFromServer(compHandler:@escaping (DashboardModel?,Bool)->Void ){
        let webCnctn = WebConnectionViewController()
        let strURL = kWebServicesURLs.dashboard_url
        
        //Call webservice using the method of webconnection class using a get request
        webCnctn.downloadData(fromUrl: strURL, isAuthenticRequest: false, postObject: nil, requestType: "GET", compHandler:{ data, error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            else{
                do {
                    guard let data = data else {return}
                    do {

                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSArray {
                            print(json)
                            DispatchQueue.main.async {
                                let arrDashboard = json.mutableCopy() as! NSMutableArray
                                let dashboardModel = DashboardModel(arCards: arrDashboard )
                                compHandler(dashboardModel,true)
                            }
                        }
                        else{
                            //Failure case
                            compHandler(nil,false)
                        }
                        
                    } catch let err {
                        //Failure case
                        print(err.localizedDescription)
                        compHandler(nil,false)

                    }
                }
            }
        })
    }
}




