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
    
    var centerLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set handler for table refresh
        self.refreshControl!.addTarget(self, action:#selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)

        // get location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        let nib = UINib(nibName: "truckCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "truckCell")
        
        // add a day string to the top of nav bar
        if let navigationBar = self.navigationController?.navigationBar {
            let centerFrame = CGRect(x: navigationBar.frame.width/4, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height/4)
            
            centerLabel = UILabel(frame: centerFrame)
            centerLabel.textAlignment = .center
            centerLabel.text = Util.getDayStrOfWeek()!
            centerLabel.font = UIFont(name: "Helvetica", size: 10.0)
            centerLabel.textColor = UIColor.lightGray
            navigationBar.addSubview(centerLabel)
        }
        
        self.refreshTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return truckList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:truckCell = tableView.dequeueReusableCell(withIdentifier: "truckCell") as! truckCell
        let truck:NSDictionary = truckList[indexPath.row] as! NSDictionary
       
        let startTime = truck.value(forKey: "start_time") as! Int
        let endTime = truck.value(forKey: "end_time") as! Int
        let currentTimeInSeconds = Util.getSecondsOfDay()
        
        cell.loadItem(truck.value(forKey: "name") as! String, logoUrl: truck.value(forKey: "logo") as! String, distance: truck.value(forKey: "distance") as! Float, cuisine: truck.value(forKey: "cuisine") as! String, address: truck.value(forKey: "address") as! String, openOrClose: currentTimeInSeconds! >= startTime && currentTimeInSeconds! <= endTime)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController = storyboard.instantiateViewController(withIdentifier: "TruckDetails") as! TruckDetailsModalController
        self.present(modalViewController, animated: true, completion: nil)
        modalViewController.assignDetails(self.truckList[indexPath.item] as! NSDictionary)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coord = ((locations as NSArray).lastObject as! CLLocation).coordinate
        
        if currentLat != nil && currentLong != nil {
            self.currentLat = coord.latitude
            self.currentLong = coord.longitude
        } else {
            self.currentLat = coord.latitude
            self.currentLong = coord.longitude
            
            // refresh the table for the intial location
            self.refreshTable()
        }
    }

    func refreshTable() {
        if currentLat == nil || currentLong == nil {
            return
        }
        
        let day = Util.getDayOfWeek()
        
        // get list of trucks
        let url = URL(string: Util.getEnvProperty("host") + "/truck/list?lat=" + String(currentLat) + "&lon=" + String(currentLong) + "&day=\(day)")

        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            
            if error != nil {
                self.alert("Sorry!", message: "Server error. Please try it later.")
                return
            }
            
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            self.truckList = Util.JSONParseArray(NSString(data: data!, encoding:String.Encoding.utf8.rawValue)! as String)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
                if self.truckList.count == 0 {
                    self.alert("Sorry!", message: "No trucks are available nearby today, please come back check later.")
                }
            })
        }) 
        
        task.resume()
    }
    
    func handleRefresh(_ sender: AnyObject?) {
        // refresh search results
        self.refreshTable()
        
        // refresh date label
        centerLabel.text = Util.getDayStrOfWeek()!
        
        if self.refreshControl!.isRefreshing {
            self.refreshControl!.endRefreshing()
        }
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class truckCell : UITableViewCell {
    
    @IBOutlet var truckImgView: UIImageView!
    @IBOutlet var truckNameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var cuisineLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var openLabel: UILabel!
    
    func loadItem(_ truckName: String, logoUrl: String, distance: Float, cuisine: String, address: String, openOrClose: Bool) {
        truckNameLabel.text = truckName
        Util.loadImage(self.truckImgView, imageUrl: logoUrl)
        distanceLabel.text = String(format: "%.2f", distance)
        addressLabel.text = Util.retrieveEssentialAddressPart(address)
        cuisineLabel.text = cuisine
        openLabel.text = openOrClose ? "open" : "closed"
        openLabel.textColor = openOrClose ? UIColor.green : UIColor.red
    }
}

