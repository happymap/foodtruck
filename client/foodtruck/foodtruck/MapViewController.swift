//
//  MapViewController.swift
//  foodtruck
//
//  Created by Yifan Ying on 11/3/16.
//  Copyright © 2016 Yifan Ying. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coord = ((locations as NSArray).lastObject as! CLLocation).coordinate

        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: false)
    }
}


