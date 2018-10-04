//
//  NotificationService.swift
//  NotificationService
//
//  Created by Asmita Koli on 13/07/18.
//  Copyright © 2018 Asmita Koli. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if let imagePath = request.content.userInfo["mediaUrl"] as? String {
                guard let url = URL(string: imagePath) else {
                    print(imagePath)
                    contentHandler(bestAttemptContent)
                    return
                }
                guard let imageData = NSData(contentsOf: url) else {
                    contentHandler(bestAttemptContent)
                    return
                }
                guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.jpg", data: imageData, options: nil) else {
                    print("error in UNNotificationAttachment.create()")
                    contentHandler(bestAttemptContent)
                    return
                }
                bestAttemptContent.attachments = [ attachment ]
            }

            let openAction = UNNotificationAction(identifier: "OpenNotification", title: "Read Later", options: [.foreground])
            let CancelAction = UNNotificationAction(identifier: "CancelNotification", title: "Cancel", options: [.destructive])
            let DismissAction = UNNotificationAction(identifier: "DismissNotification", title: "Dismiss", options: [.destructive])
            
            
            let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction,CancelAction,DismissAction], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories(Set([deafultCategory]))

            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
extension UNNotificationAttachment {
    
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        guard let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true) else { return nil }
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL, options: [])
            let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
    
}
