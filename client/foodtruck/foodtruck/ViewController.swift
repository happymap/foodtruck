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
    
    let util = Util()
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
        cell.loadItem(truckList[indexPath.row]["name"] as! String, logoUrl: truckList[indexPath.row]["logo"] as! String, distance: truckList[indexPath.row]["distance"] as! Float)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coord = ((locations as NSArray).lastObject as! CLLocation).coordinate
        self.currentLat = coord.latitude
        self.currentLong = coord.longitude
        
        // stop update after
        self.locationManager.stopUpdatingLocation();
        self.refreshTable()
    }

    
    // convert string to json object
    func JSONParseArray(string: String) -> [AnyObject]{
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                if let array = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [AnyObject] {
                    return array
                }
            } catch {
                print("error")
            }
        }
        return [AnyObject]()
    }
    
    func refreshTable() {
        if currentLat == nil || currentLong == nil {
            return
        }
        
        // get list of trucks
        let url = NSURL(string: util.getEnvProperty("host") + "/truck/list?latitude=" + String(currentLat) + "&longitude=" + String(currentLong))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            self.truckList = self.JSONParseArray(NSString(data: data!, encoding:NSUTF8StringEncoding) as! String)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        task.resume()
    }
}

class truckCell : UITableViewCell {
    
    let util = Util()
    
    @IBOutlet var truckImgVuew: UIImageView!
    @IBOutlet var truckNameLabel: UILabel!
    @IBOutlet var distanceLable: UILabel!
    
    func loadItem(truckName: String, logoUrl: String, distance: Float) {
        truckNameLabel.text = truckName
        
        let url: NSURL = NSURL(string: util.getEnvProperty("host") + logoUrl)!
        
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.truckImgVuew.image = UIImage(data: data)
            }
        }
        
        distanceLable.text = String(format: "%.2f", distance)
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}

