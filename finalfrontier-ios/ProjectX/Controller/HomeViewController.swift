//
//  HomeViewController.swift
//  RideRequestExtension
//
//  Created by Das on 11/21/19.
//  Copyright © 2019 ArunabhDas. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FontAwesome_swift


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    var window: UIWindow?
    var mapView: MKMapView?
    var locationManager: CLLocationManager?
    let distanceSpan: Double = 500
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.primaryColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = Constants.Colors.colorPinkTwo
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: Constants.AssetNames.kAssetBackground)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        title = Constants.MenuTitles.kTitleThree


        
        setupUI()
    }
    
    func setupUI() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: (self.window?.frame.width)!, height: (self.window?.frame.height)!))
        if let mapView = self.mapView {
            self.view.addSubview(mapView)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            view.addGestureRecognizer(tap)
            mapView.addGestureRecognizer(tap)

        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: self.distanceSpan, longitudinalMeters: self.distanceSpan)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
}
