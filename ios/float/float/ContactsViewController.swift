//
//  MyTripViewController.swift
//  float
//
//  Created by Ben Wang on 10/23/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation
class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tripTimeSelection: UISegmentedControl!
    
    override func viewDidLoad() {
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Tapping | ECSlidingViewControllerAnchoredGesture.Panning
        let lIcon = FAKIonIcons.naviconIconWithSize(40)
        lIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let lIconImage = lIcon.imageWithSize(CGSizeMake(40, 40))
        //        self.navigationController?.navigationItem.leftBarButtonItem.image = lIconImage
        
        var lBarButtonItem: UIBarButtonItem =  UIBarButtonItem(image: lIconImage, style: .Plain, target: self, action: "unwindToMenuViewController:")
        self.navigationItem.leftBarButtonItem = lBarButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "#ffffff", alpha: 1);
        self.tripTimeSelection.tintColor = UIColor(hexString: "#00B5E5");
    }
    
    @IBAction func unwindToMenuViewController(segue: UIStoryboardSegue) {
        self.slidingViewController().anchorTopViewToRightAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell_ : TripListCell? = tableView.dequeueReusableCellWithIdentifier("TripListCell") as? TripListCell
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
}