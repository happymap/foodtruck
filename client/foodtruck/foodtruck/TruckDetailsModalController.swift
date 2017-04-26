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

public class TruckDetailsModalController: UIViewController {
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var hoursLbl: UILabel!
    @IBOutlet var truckImg: UIImageView!
    @IBOutlet var addressBtn: UIButton!
    @IBOutlet var mapView: MKMapView!
    
    public var details: NSDictionary!
    
    override public func viewDidLoad() {
        view.opaque = false
    }
    
    @IBAction func done(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func assignDetails(details: NSDictionary) {
        self.details = details
        self.nameLbl.text = (self.details.valueForKey("name") as! String)
        let startTime = Util.convertToHours(self.details.valueForKey("start_time") as! Int)
        let endTime = Util.convertToHours(self.details.valueForKey("end_time") as! Int)
        self.hoursLbl.text = "Hours Today: \(startTime) - \(endTime)"
        
        let truckImageUrl = "http://japacurry.com/wordpress/wp-content/uploads/2015/05/japacurry_truck.jpg"
        Util.loadImage(self.truckImg, imageUrl: truckImageUrl)
        
        self.addressBtn.setTitle((self.details.valueForKey("display_address") as! String), forState: .Normal)
        
        // mark the place on the map
        let coord = CLLocation(latitude: details.valueForKey("latitude") as! Double,
            longitude: details.valueForKey("longitude") as! Double).coordinate
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: false)
        
        let annotation = Annotation(title: "Japa Curry", locationName: "Howard St", discipline: "discipline", coordinate: coord)
        mapView.addAnnotation(annotation)
    }
}
