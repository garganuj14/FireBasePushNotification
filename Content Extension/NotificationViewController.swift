//
//  NotificationViewController.swift
//  Content Extension
//
//  Created by Welcome on 27/09/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        if let notificationData = notification.request.content.userInfo["data"] as? [String: Any] {
            
            // Grab the attachment
            if let urlString = notificationData["attachment-url"], let fileUrl = URL(string: urlString as! String) {
                
                let imageData = NSData(contentsOf: fileUrl)
                let image = UIImage(data: imageData! as Data)!
                
                imageView.image = image
            }
        }    }

}
