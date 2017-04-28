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
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBtn: UIButton!
    
    let locationManager = CLLocationManager()

    var truckList:[AnyObject] = []
    var isInitialLoad = true

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
    
    func loadTrucks(maxLat: Double, maxLon: Double, minLat: Double, minLon: Double) {
        // get list of trucks
        let url = NSURL(string: Util.getEnvProperty("host") + "/truck/map?maxLat=" + String(maxLat) + "&maxLon=" + String(maxLon)
            + "&minLat=" + String(minLat) + "&minLon=" + String(minLon) + "&day=2&time=43200")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.truckList = Util.JSONParseArray(NSString(data: data!, encoding:NSUTF8StringEncoding) as! String)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.refreshMap()
            })
        }
        
        task.resume()
    
    }
    
    func refreshMap() {
        // remove all annotations
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        // add annotations
        for truck in truckList as! [NSDictionary] {
            let name = truck.valueForKey("name") as! String
            let coord = CLLocation(latitude: truck.valueForKey("latitude") as! Double,
                longitude: truck.valueForKey("longitude") as! Double).coordinate
            let annotation = Annotation(title: name, identifier: truck.valueForKey("truck_id") as! Int, coordinate: coord)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coord = ((locations as NSArray).lastObject as! CLLocation).coordinate

        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: false)
        
        if (isInitialLoad) {
            search()
        } else {
            isInitialLoad = false
        }
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = (annotation as! Annotation).identifier
        
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(String(identifier)) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:String(identifier))
            annotationView.enabled = true
            annotationView.canShowCallout = true
            
            let btn = UIButton(type: .DetailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            btn.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            return annotationView
        }
    }
    
    func buttonClicked(sender: AnyObject?) {
        sender.
    
    }

    
    @IBAction func search() {
        // get map bounds
        let northEast = mapView.convertPoint(CGPoint(x: mapView.bounds.width, y: 0), toCoordinateFromView: mapView)
        let southWest = mapView.convertPoint(CGPoint(x: 0, y: mapView.bounds.height), toCoordinateFromView: mapView)
        
        // fetch trucks in the visible map area
        loadTrucks(northEast.latitude, maxLon: northEast.longitude, minLat: southWest.latitude, minLon: southWest.longitude)

        // refresh the map
        refreshMap()
    }
}


