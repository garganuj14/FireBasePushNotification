//
//  ShareDialogViewController.swift
//  FireBasePushNotification
//
//  Created by MYGOV4 on 12/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import EFCountingLabel


class ShareDialogViewController: UIViewController {

    @IBOutlet weak var SchemeName: UILabel!
    @IBOutlet weak var smallText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var DataValue: EFCountingLabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var lblDate: UIButton!

    var card = dashboardCard()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(card)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        self.smallText.text = card.small_text!
        
        let url = card.icon!
        self.icon.sd_setImage(with: url)
        self.DataValue.format = "%d"
        let intValue = Int((card.data_value!))
        print("Float value",intValue!)
        self.DataValue.text = card.pre_data_unit! + (" \(card.data_value!)")

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- share image
    @IBAction func shareImageButton(_ sender: UIButton) {
        
        // image to share
        //let image = UIImage(named: "Image")
        
        // set up activity view controller
        //let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: [self.card.small_text! as Any], applicationActivities: nil)
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
