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
        
        // set handler for table refresh
        self.refreshControl!.addTarget(self, action:#selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)

        // get location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        let nib = UINib(nibName: "truckCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "truckCell")
        
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
       
        cell.loadItem(truck.value(forKey: "name") as! String, logoUrl: truck.value(forKey: "logo") as! String, distance: truck.value(forKey: "distance") as! Float, cuisine: truck.value(forKey: "cuisine") as! String, address: truck.value(forKey: "address") as! String)
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
        let url = URL(string: Util.getEnvProperty("host") + "/truck/list?lat=" + String(currentLat) + "&lon=" + String(currentLong) + "&day=2&time=43200")

        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            self.truckList = Util.JSONParseArray(NSString(data: data!, encoding:String.Encoding.utf8.rawValue) as! String)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        }) 
        
        task.resume()
    }
    
    func handleRefresh(_ sender: AnyObject?) {
        self.refreshTable()
        
        if self.refreshControl!.isRefreshing {
            self.refreshControl!.endRefreshing()
        }
    }
}

class truckCell : UITableViewCell {
    
    @IBOutlet var truckImgView: UIImageView!
    @IBOutlet var truckNameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var cuisineLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    func loadItem(_ truckName: String, logoUrl: String, distance: Float, cuisine: String, address: String) {
        truckNameLabel.text = truckName
        Util.loadImage(self.truckImgView, imageUrl: logoUrl)
        distanceLabel.text = String(format: "%.2f", distance)
        addressLabel.text = Util.retrieveEssentialAddressPart(address)
        cuisineLabel.text = cuisine
    }
}

