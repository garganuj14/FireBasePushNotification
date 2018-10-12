//
//  PerformanceDashboardViewController.swift
//  FireBasePushNotification
//
//  Created by Welcome on 09/10/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import EFCountingLabel
import Presentr

class PerformanceDashboardViewController: UIViewController {
    @IBOutlet weak var dashboardCollection: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    var dashboardViewModel: DashboardViewModel = DashboardViewModel()
    
    
    //Presentr decleration
    let presenter: Presentr = {
        let width = ModalSize.custom(size: 276.0)
        let height = ModalSize.custom(size: 200.0)
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .clear
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        //customPresenter.blurBackground = true
        //customPresenter.blurStyle = UIBlurEffectStyle.light
        return customPresenter
    }()
    
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
      //  cell.shareButton.addTarget(self, action: #selector(shareImageButton(_:)), for: .touchUpInside)
       // cell.viewHover.isHidden = true
        cell.setDashboardData(card: card)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let card = self.dashboardViewModel.cardsArray[indexPath.row]
        let controller = Helpers.storyBoard.instantiateViewController(withIdentifier: "ShareDialogViewController") as! ShareDialogViewController
        controller.card = card
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }
    
    
    // Reloads the list
    @objc func reloadList(){
        DispatchQueue.main.async {
            self.dashboardCollection.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
}
