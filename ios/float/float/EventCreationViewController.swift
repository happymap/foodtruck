//
//  EventCreationViewController.swift
//  float
//
//  Created by Ben Wang on 6/5/15.
//  Copyright (c) 2015 Ben Wang. All rights reserved.
//

import Foundation
import MapKit

class EventCreationViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var eventImgView:UIImageView!
    @IBOutlet var eventName:UITextView!
    @IBOutlet var eventMap:MKMapView!
    @IBOutlet var groupList:UITableView!
    @IBOutlet var locationLbl:UILabel!
    var centerPin: MKPointAnnotation!
    var location: CLLocation!
    var eventImg: UIImage!
    
    override func viewDidLoad() {
        centerPin = MKPointAnnotation()
        eventImgView.image = eventImg
        eventImgView.clipsToBounds = true
        let defaults = NSUserDefaults.standardUserDefaults()
        var displayNameText:NSString = defaults.objectForKey("fbDisplayName") as! NSString
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "createGroup")
        eventMap.delegate = self
//        var newYorkLocation = CLLocationCoordinate2DMake(40.730872, -74.003066)
        // Drop a pin
        
        
        centerPin.coordinate = UserLocation.manager.currentLocation2d!
        centerPin.title = "My Event Location"
        eventMap.addAnnotation(centerPin)
        eventMap.frame = CGRectMake(self.eventMap.frame.origin.x, self.eventMap.frame.origin.y, self.view.frame.width, self.eventMap.frame.height)
//        eventMap.setCenterCoordinate(UserLocation.manager.currentLocation2d!, animated: true)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(UserLocation.manager.currentLocation2d!,
            1000, 1000)
        eventMap.setRegion(coordinateRegion, animated: true)
        groupList.frame = CGRectMake(0, self.groupList.frame.origin.y, self.view.frame.width, self.groupList.frame.height)
        eventName.text = NSString(format: "%@'s event name", displayNameText) as String
        locationLbl.center.x = self.view.center.x
        //self.eventName.frame = CGRectMake(self.eventName.center.x, self.eventName.frame.origin.y, (self.view.frame.width - 100) / 2, self.eventName.frame.height)
        self.eventImgView.frame = CGRectMake(self.eventImgView.frame.origin.x, self.eventImgView.frame.origin.y, 100, 100)
        self.eventImgView.contentMode = UIViewContentMode.ScaleAspectFill
        
        var buttonHeight : CGFloat = 40
        var y : CGFloat = UIScreen.mainScreen().bounds.size.height - buttonHeight
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, y, self.view.frame.size.width, buttonHeight)
        button.backgroundColor = UIColor(hexString: "#00ACE0", alpha: 0.95)
        button.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 20)
        
        button.setTitle("Add groups", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        button.setTitleColor(UIColor(hexString: "#ffffff", alpha: 1), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func createEvent() {
        //http call
        self.dismiss()
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        // Calling...
        NSLog("map view changed")
        centerPinAndGetLoc()
    }
    
    func centerPinAndGetLoc() {
        if (centerPin != nil) {
            centerPin.coordinate = self.eventMap.centerCoordinate
            var pinLoc = CLLocation(latitude: centerPin.coordinate.latitude, longitude: centerPin.coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(pinLoc, completionHandler: {(placemarks, error) -> Void in
                
                if error != nil {
                    println("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }
                
                if placemarks.count > 0 {
                    let pm: CLPlacemark = placemarks[0] as! CLPlacemark
                    var n : NSString = pm.name
                    self.locationLbl.text = NSString(format: "%@", n) as String
                    
                }
                else {
                    println("Problem with the data received from geocoder")
                }
            })
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        // Not getting called
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell_ : EventGroupCell? = tableView.dequeueReusableCellWithIdentifier("EventGroupCell") as? EventGroupCell
        //        let item:String = self.menuItems()[indexPath.row] as String
        //        cell_!.backgroundColor = UIColor.clearColor()
        //        cell_!.textLabel.text = item
        //        cell_!.textLabel.textAlignment = NSTextAlignment.Center;
        //
        //        if (indexPath.row == 0) {
        //            cell_!.textLabel.textColor = UIColor(hexString: "#ffffff", alpha: 1)
        //        }
        
        return cell_!
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        //        self.performSegueWithIdentifier(item, sender: nil)
    }
    
    @IBAction func buttonAction(sender: UIGestureRecognizer) {
        self.performSegueWithIdentifier("addGroupSegue", sender: self)
    }
}
