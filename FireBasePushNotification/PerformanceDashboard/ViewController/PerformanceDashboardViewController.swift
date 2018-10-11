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

    var dashboardViewModel: DashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dashboardViewModel.updateModel(view: self.view)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadList), name: Helpers.DashboardUpdated , object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
       // cell.viewHover.isHidden = true
        cell.setDashboardData(card: card)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var cell = CollectionViewCell()
//        cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helpers.CARD_CELL_IDENTIFIER, for: indexPath) as! CollectionViewCell
//        
//        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
//           // view.isHidden = hidden
//            cell.viewHover.isHidden = false
//        })
//    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        var cell = CollectionViewCell()
//        cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helpers.CARD_CELL_IDENTIFIER, for: indexPath) as! CollectionViewCell
//        
//        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
//            // view.isHidden = hidden
//            cell.viewHover.isHidden = true
//        })
//    }
    
    // Reloads the list
    @objc func reloadList(){
        DispatchQueue.main.async {
            self.dashboardCollection.reloadData()
        }
    }
    
}
