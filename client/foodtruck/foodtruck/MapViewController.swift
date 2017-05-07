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
    
    func loadTrucks(_ maxLat: Double, maxLon: Double, minLat: Double, minLon: Double) {
        // get list of trucks
        let url = URL(string: Util.getEnvProperty("host") + "/truck/map?maxLat=" + String(maxLat) + "&maxLon=" + String(maxLon)
            + "&minLat=" + String(minLat) + "&minLon=" + String(minLon) + "&day=2&time=43200")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            self.truckList = Util.JSONParseArray(NSString(data: data!, encoding:String.Encoding.utf8.rawValue)! as String)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.refreshMap()
            })
        }) 
        
        task.resume()
    }
    
    func refreshMap() {
        // remove all annotations
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        // add annotations
        for truck in truckList as! [NSDictionary] {
            let name = truck.value(forKey: "name") as! String
            let coord = CLLocation(latitude: truck.value(forKey: "latitude") as! Double,
                longitude: truck.value(forKey: "longitude") as! Double).coordinate
            let annotation = Annotation(title: name, identifier: truck.value(forKey: "schedule_id") as! Int, coordinate: coord)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let leftTopPoint = CGPoint(x: mapView.bounds.origin.x, y: mapView.bounds.origin.y)
        let rightBottomPoint = CGPoint(x: mapView.bounds.origin.x + mapView.bounds.width, y: mapView.bounds.origin.y + mapView.bounds.height)
        
        let leftTopCoord = mapView.convert(leftTopPoint, toCoordinateFrom: mapView)
        let rightBottomCoord = mapView.convert(rightBottomPoint, toCoordinateFrom: mapView)
        
        // get list of trucks
        let host = Util.getEnvProperty("host")
        let strUrl = "\(host)/truck/map?maxLat=\(leftTopCoord.latitude)&minLon=\(leftTopCoord.longitude)&minLat=\(rightBottomCoord.latitude)&maxLon=\(rightBottomCoord.longitude)&day=2&time=43200"
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            self.truckList = Util.JSONParseArray(NSString(data: data!, encoding:String.Encoding.utf8.rawValue)! as String)
            
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }) 
        
        task.resume()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = (annotation as! Annotation).identifier
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: String(identifier)) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:String(identifier))
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            btn.addTarget(self, action: #selector(MapViewController.buttonClicked(_:)), for: .touchUpInside)
            btn.tag = identifier
            return annotationView
        }
    }
    
    func buttonClicked(_ sender: AnyObject?) {
        let schedule_id = sender?.tag
        
        for truck in truckList as! [NSDictionary] {
            if (truck.value(forKey: "schedule_id") as? Int == schedule_id) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let modalViewController = storyboard.instantiateViewController(withIdentifier: "TruckDetails") as! TruckDetailsModalController
                self.present(modalViewController, animated: true, completion: nil)
                modalViewController.assignDetails(truck)
            }
        }
    }

    
    @IBAction func search() {
        // get map bounds
        let northEast = mapView.convert(CGPoint(x: mapView.bounds.width, y: 0), toCoordinateFrom: mapView)
        let southWest = mapView.convert(CGPoint(x: 0, y: mapView.bounds.height), toCoordinateFrom: mapView)
        
        // fetch trucks in the visible map area
        loadTrucks(northEast.latitude, maxLon: northEast.longitude, minLat: southWest.latitude, minLon: southWest.longitude)

        // refresh the map
        refreshMap()
    }
}


