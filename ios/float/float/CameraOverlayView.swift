//
//  CameraOverlayView.swift
//  float
//
//  Created by Ben Wang on 6/4/15.
//  Copyright (c) 2015 Ben Wang. All rights reserved.
//

import Foundation

class CameraOverlayView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    var textLbl:UILabel
    var manager:CLLocationManager!
    override init(frame : CGRect) {
            //Create Button
        self.textLbl = UILabel()
        super.init(frame: frame)
        self.createCameraButton()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        manager.startUpdatingLocation()
            manager.requestWhenInUseAuthorization()
        manager.startMonitoringSignificantLocationChanges()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCameraButton () {
        textLbl.backgroundColor = UIColor.clearColor()
//        [self.cameraButton addTarget:self
//            action:@selector(takePicture)
//        forControlEvents:UIControlEventTouchUpInside];
//        [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"camera.png"]   forState:UIControlStateNormal];
        textLbl.frame = CGRectMake(0, 0, self.bounds.width, 50);
//        textLbl.text = "Charlotte at Turn HQ"
        
        
        
        textLbl.center.x = self.center.x
        textLbl.textAlignment = .Center
        textLbl.textColor = UIColor.yellowColor()
        self.addSubview(self.textLbl)
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) { // Updated to current array syntax [AnyObject] rather than AnyObject[]
        println("locations = \(locations)")
        
        var location:CLLocation = locations.last as! CLLocation
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            println(location)
            
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                var n : NSString = pm.name
                self.textLbl.text = NSString(format: "Charlotte @ %@", n) as String
                
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error: " + error.localizedDescription)
        
    }

    
}