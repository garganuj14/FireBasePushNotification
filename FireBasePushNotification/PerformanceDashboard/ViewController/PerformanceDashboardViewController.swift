//
//  PerformanceDashboardViewController.swift
//  FireBasePushNotification
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import EFCountingLabel

class PerformanceDashboardViewController: UIViewController {
    @IBOutlet weak var dashboardCollection: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    var dashboardViewModel: DashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dashboardViewModel.updateModel(view: self.view)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadList), name: Helpers.DashboardUpdated , object: nil)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            dashboardCollection.refreshControl = refreshControl
        } else {
            dashboardCollection.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        dashboardViewModel.updateModel(view: self.view)
    }
    
    
    // share image
    @IBAction func shareImageButton(_ sender: UIButton) {
        
      let card = self.dashboardViewModel.cardsArray[sender.tag]
        
        // image to share
        //let image = UIImage(named: "Image")
        
        // set up activity view controller
        //let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: [card.small_text!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


//MARK:- Extention for implementing delegates and datasource of collectionview
extension PerformanceDashboardViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardViewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = CollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helpers.CARD_CELL_IDENTIFIER, for: indexPath) as! CollectionViewCell
        let card = self.dashboardViewModel.cardsArray[indexPath.row]
        cell.shareButton.addTarget(self, action: #selector(shareImageButton(_:)), for: .touchUpInside)
       // cell.viewHover.isHidden = true
        cell.setDashboardData(card: card)
        return cell
    }
    
    
    // Reloads the list
    @objc func reloadList(){
        DispatchQueue.main.async {
            self.dashboardCollection.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
}
