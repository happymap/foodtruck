//
//  UserLocationManager.swift
//
//  Use: call SharedUserLocation.currentLocation2d from any class


import MapKit

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    // You can access the lat and long by calling:
    // currentLocation2d.latitude, etc
    
    var currentLocation2d:CLLocationCoordinate2D?
    
    
    class var manager: UserLocation {
        return SharedUserLocation
    }
    
    override init () {
        super.init()
        if self.locationManager.respondsToSelector(Selector("requestAlwaysAuthorization")) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentLocation2d = manager.location.coordinate
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error: " + error.localizedDescription)
        
    }
 
}

let SharedUserLocation = UserLocation()