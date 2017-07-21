//
//  TruckDetailsModalController.swift
//  foodtruck
//
//  Created by Yifan Ying on 4/22/17.
//  Copyright © 2017 Yifan Ying. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

open class TruckDetailsModalController: UIViewController {
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var hoursLbl: UILabel!
    @IBOutlet var truckImg: UIImageView!
    @IBOutlet var addressBtn: UIButton!
    @IBOutlet var mapView: MKMapView!
    
    open var details: NSDictionary!
    
    override open func viewDidLoad() {
        view.isOpaque = false        
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigate(_ sender: UIButton) {
        // open apple maps for directions
        let latitude = details .value(forKey: "latitude") as! Double
        let longitude = details .value(forKey: "longitude") as! Double
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Destination/Target Address or Name"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
    }
    
    open func assignDetails(_ details: NSDictionary) {
        self.details = details
        self.nameLbl.text = (self.details.value(forKey: "name") as! String)
        let startTime = Util.convertToHours(self.details.value(forKey: "start_time") as! Int)
        let endTime = Util.convertToHours(self.details.value(forKey: "end_time") as! Int)
        self.hoursLbl.text = "Hours Today: \(startTime) - \(endTime)"
        
        let truckImageUrl = self.details.value(forKey: "image") as! String
        Util.loadImage(self.truckImg, imageUrl: truckImageUrl)
        
        self.addressBtn.setTitle((self.details.value(forKey: "address") as! String), for: UIControlState())
        
        // mark the place on the map
        let coord = CLLocation(latitude: details.value(forKey: "latitude") as! Double,
            longitude: details.value(forKey: "longitude") as! Double).coordinate
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: false)
        
        let annotation = Annotation(title: "Japa Curry", identifier: details.value(forKey: "truck_id") as! Int, coordinate: coord)
        mapView.addAnnotation(annotation)
        
        mapView.showsUserLocation = true
    }
}
