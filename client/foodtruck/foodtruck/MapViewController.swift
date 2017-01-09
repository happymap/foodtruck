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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    var truckList:[AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coord = ((locations as NSArray).lastObject as! CLLocation).coordinate

        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: false)
        
        let annotation = Annotation(title: "Japa Curry", locationName: "Howard St", discipline: "discipline", coordinate: coord)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let leftTopPoint = CGPointMake(mapView.bounds.origin.x, mapView.bounds.origin.y)
        let rightBottomPoint = CGPointMake(mapView.bounds.origin.x + mapView.bounds.width, mapView.bounds.origin.y + mapView.bounds.height)
        
        let leftTopCoord = mapView.convertPoint(leftTopPoint, toCoordinateFromView: mapView)
        let rightBottomCoord = mapView.convertPoint(rightBottomPoint, toCoordinateFromView: mapView)
        
        // get list of trucks
        let host = Util.getEnvProperty("host")
        let strUrl = "\(host)/truck/map?maxLat=\(leftTopCoord.latitude)&minLon=\(leftTopCoord.longitude)&minLat=\(rightBottomCoord.latitude)&maxLon=\(rightBottomCoord.longitude)&day=2&time=43200"
        let url = NSURL(string: strUrl)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            self.truckList = Util.JSONParseArray(NSString(data: data!, encoding:NSUTF8StringEncoding) as! String)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        }
        
        task.resume()
    }
}


