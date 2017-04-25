//
//  TruckDetailsModalController.swift
//  foodtruck
//
//  Created by Yifan Ying on 4/22/17.
//  Copyright © 2017 Yifan Ying. All rights reserved.
//

import UIKit

public class TruckDetailsModalController: UIViewController {
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var hoursLbl: UILabel!
    @IBOutlet var truckImg: UIImageView!
    @IBOutlet var addressBtn: UIButton!
    
    public var details: NSDictionary!
    
    override public func viewDidLoad() {
        view.opaque = false
    }
    
    @IBAction func done(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func assignDetails(details: NSDictionary) {
        self.details = details
        self.nameLbl.text = (self.details.valueForKey("name") as! String)
        let startTime = Util.convertToHours(self.details.valueForKey("start_time") as! Int)
        let endTime = Util.convertToHours(self.details.valueForKey("end_time") as! Int)
        self.hoursLbl.text = "Hours Today: \(startTime) - \(endTime)"
        
        let truckImageUrl = "http://japacurry.com/wordpress/wp-content/uploads/2015/05/japacurry_truck.jpg"
        Util.loadImage(self.truckImg, imageUrl: truckImageUrl)
        
        self.addressBtn.setTitle((self.details.valueForKey("display_address") as! String), forState: .Normal)
    }
}
