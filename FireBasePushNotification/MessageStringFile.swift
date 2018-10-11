//
//  DashboardModel.swift
//  TransformingIndia
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit

class MessageStringFile: NSObject {
        
    func mobileValidation() -> String {
        return "Please enter username or mobile number."
    }
    
    func passwordValidation() -> String {
        return "Please enter password."
    }
    
    func profileImageValidation() -> String {
        return "Please select profile image."
    }

    func dataParseValidation() -> String {
        return "Data parse error"
    }
    
    func okText() -> String {
        return "OK"
    }
   
}
