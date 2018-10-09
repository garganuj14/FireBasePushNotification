//
//  PerformanceDashboardViewController.swift
//  FireBasePushNotification
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension PerformanceDashboardViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardViewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = CollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helpers.CARD_CELL_IDENTIFIER, for: indexPath) as! CollectionViewCell
        let card = self.dashboardViewModel.cardsArray[indexPath.row]
        cell.setDashboardData(card: card)
        return cell
    }
    
    
    // Reloads the list
    @objc func reloadList(){
        DispatchQueue.main.async {
            self.dashboardCollection.reloadData()
        }
    }
    
}
