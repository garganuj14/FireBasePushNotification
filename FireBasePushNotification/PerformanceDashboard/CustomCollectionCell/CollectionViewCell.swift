//
//  CollectionViewCell.swift
//  FireBasePushNotification
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import SDWebImage
import EFCountingLabel

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var SchemeName: UILabel!
    @IBOutlet weak var smallText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var DataValue: EFCountingLabel!
    @IBOutlet weak var smallTextHover: UILabel!
    @IBOutlet weak var DataValueHover: UILabel!
    @IBOutlet weak var viewHover: UIView!
    @IBOutlet weak var shareButton: UIButton!

    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
              UIView.transition(with: viewHover, duration: 0.5, options: .transitionFlipFromTop, animations: {
                  self.viewHover.isHidden = false
              })
            }
            else
            {
                UIView.transition(with: viewHover, duration: 0.5, options: .transitionFlipFromTop, animations: {
                    self.viewHover.isHidden = true
                })
            }
        }
    }
    
    
    
    
    func setDashboardData(card:dashboardCard){
        // self.SchemeName.text = card.scheme
        self.smallText.text = card.small_text
        self.smallTextHover.text = card.small_text
        
        let url = card.icon
        self.icon.sd_setImage(with: url)
        self.DataValue.format = "%d"
        let intValue = Int(card.data_value!)
        print("Float value",intValue!)
        self.DataValue.countFrom(CGFloat(0), to: CGFloat(intValue!), withDuration: 1.5)
        // self.DataValue.countFromZeroTo(CGFloat(intValue!))
        self.DataValueHover.text = card.data_value
    }
}
