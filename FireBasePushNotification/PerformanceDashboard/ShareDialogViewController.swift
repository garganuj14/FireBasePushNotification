//
//  ShareDialogViewController.swift
//  FireBasePushNotification
//
//  Created by MYGOV4 on 12/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import EFCountingLabel
import CoreGraphics

class ShareDialogViewController: UIViewController {

    @IBOutlet weak var SchemeName: UILabel!
    @IBOutlet weak var smallText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var DataValue: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var lblDate: UILabel!

    var card = dashboardCard()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(card)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        self.smallText.text = card.scheme!
        
        let url = card.icon!
        self.icon.sd_setImage(with: url)
        //self.DataValue.format = "%d"
        let intValue = Int64((card.data_value!))
        let dataValue = intValue?.formattedWithSeparator

        print("Float value",intValue!)
        if card.data_unit == " Kms"{
            let txt = dataValue! + (" \(card.data_unit!)")
            self.DataValue.attributedText = Helpers().addAttributedString(normalString: txt, subString: card.data_unit!)
        }
        else{
            let txt = card.pre_data_unit! + (" \(dataValue!)")
            self.DataValue.attributedText = Helpers().addAttributedString(normalString: txt, subString: card.pre_data_unit!)
        }
        self.lblDate.text = card.date
       // self.DataValue.text = card.pre_data_unit! + (" \(card.data_value!)")

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- share image
    @IBAction func shareImageButton(_ sender: UIButton) {
        
        // image to share
       
        sender.isHidden = true
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        sender.isHidden = false
        let textToShare = Helpers.textToShare
        let activityViewController = UIActivityViewController(activityItems: [textToShare,image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Close Button
    
    @IBAction func closeMe(_ sender: Any) {
        
    }
    
}
