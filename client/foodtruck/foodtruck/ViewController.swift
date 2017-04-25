//
//  ViewController.swift
//  foodtruck
//
//  Created by Yifan Ying on 10/16/15.
//  Copyright © 2015 Yifan Ying. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    var truckList:[AnyObject] = []
    var currentLat:Double!
    var currentLong:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        let nib = UINib(nibName: "truckCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "truckCell")
        
        self.refreshTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return truckList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:truckCell = tableView.dequeueReusableCellWithIdentifier("truckCell") as! truckCell
        let truck:NSDictionary = truckList[indexPath.row] as! NSDictionary
       
        cell.loadItem(truck.valueForKey("name") as! String, logoUrl: truck.valueForKey("logo") as! String, distance: truck.valueForKey("distance") as! Float)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController = storyboard.instantiateViewControllerWithIdentifier("TruckDetails") as! TruckDetailsModalController
        self.presentViewController(modalViewController, animated: true, completion: nil)
        modalViewController.assignDetails(self.truckList[indexPath.item] as! NSDictionary)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coord = ((locations as NSArray).lastObject as! CLLocation).coordinate
        self.currentLat = coord.latitude
        self.currentLong = coord.longitude
        
        // stop update after
        self.locationManager.stopUpdatingLocation();
        self.refreshTable()
    }

    func refreshTable() {
        if currentLat == nil || currentLong == nil {
            return
        }
        
        // get list of trucks
        let url = NSURL(string: Util.getEnvProperty("host") + "/truck/list?lat=" + String(currentLat) + "&lon=" + String(currentLong) + "&day=2&time=43200")

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.truckList = Util.JSONParseArray(NSString(data: data!, encoding:NSUTF8StringEncoding) as! String)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        task.resume()
    }
}

class truckCell : UITableViewCell {
    
    @IBOutlet var truckImgView: UIImageView!
    @IBOutlet var truckNameLabel: UILabel!
    @IBOutlet var distanceLable: UILabel!
    
    func loadItem(truckName: String, logoUrl: String, distance: Float) {
        truckNameLabel.text = truckName
        Util.loadImage(self.truckImgView, imageUrl: logoUrl)
        distanceLable.text = String(format: "%.2f", distance)
    }
}

