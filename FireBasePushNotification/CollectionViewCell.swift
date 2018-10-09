//
//  CollectionViewCell.swift
//  FireBasePushNotification
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import SDWebImage
class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var SchemeName: UILabel!
    @IBOutlet weak var smallText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var DataValue: UILabel!
    @IBOutlet weak var smallTextHover: UILabel!
    @IBOutlet weak var DataValueHover: UILabel!
    @IBOutlet weak var viewHover: UIView!

    
    
    func setDashboardData(card:dashboardCard){
       // self.SchemeName.text = card.scheme
        self.smallText.text = card.small_text
        self.smallTextHover.text = card.small_text

        let url = card.icon
        self.icon.sd_setImage(with: url)
        self.DataValue.text = card.data_value
        self.DataValueHover.text = card.data_value
    }
}
