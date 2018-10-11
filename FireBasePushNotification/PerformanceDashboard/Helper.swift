//
//  Helper.swift
//  FireBasePushNotification
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import Foundation
import UIKit

// set constant API_KEY
let API_KEY = "d1a6211f648d4e2ba9cf618682576290"


struct kWebServicesURLs {
    static let dashboard_url = "https://48months.mygov.in/wp-content/uploads/dashboard.json"
}

class Helpers: NSObject {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let DashboardUpdated = Notification.Name("DashboardUpdated")
    static let CARD_CELL_IDENTIFIER = "Dashboard_Card"
    static let NEWS_DETAIL_IDENTIFIER = "NewsDetailsViewController"
    static let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    static let navigationController = storyBoard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
    
    
    func showAlertMessage(viewController: UIViewController, title: String, msg: String) {
        let alert = UIAlertController (title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        viewController.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: MessageStringFile().okText(), style: .default, handler: { action in
        }))
    }
    
}
