//
//  MenuViewController.swift
//  float
//
//  Created by Ben Wang on 10/17/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ECSlidingViewControllerDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet var name: UILabel!
    @IBOutlet var profImg: UIImageView!
    var selectedPosition: Int! = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        self.name.text = defaults.objectForKey("fbDisplayName") as? String
//        var fbProfileImgUrl : NSString = NSString(format: "http://graph.facebook.com/%@/picture?type=square&width=300&height=300", defaults.objectForKey("fbObjID") as! String)
//        var url : NSURL = NSURL(string: fbProfileImgUrl as String)! as NSURL
//        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
//            if (image != nil) {
//                self.profImg.image = image
//            }
//        })

        self.profImg.layer.cornerRadius = self.profImg.frame.size.width / 2
        self.profImg.clipsToBounds = true

    }
    
    func menuItems() -> NSArray {
        var groupsLocalized: String! = NSLocalizedString("Groups", comment: "Groups")
        var beaconsLocalized: String! = NSLocalizedString("Panimals", comment: "Panimals")
        var settingsLocalized: String! = NSLocalizedString("Settings", comment: "Settings")
        var myArray: [String] = [groupsLocalized, beaconsLocalized, settingsLocalized]
        return myArray;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems().count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell_ : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MenuCell") as? UITableViewCell
        if(cell_ == nil)
        {
            cell_ = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MenuCell")
        }
        let item:String = self.menuItems()[indexPath.row] as! String
        cell_!.backgroundColor = UIColor.clearColor()
        cell_!.textLabel?.text = item
        cell_!.textLabel?.textAlignment = NSTextAlignment.Center;
        
        if (indexPath.row == 0) {
            cell_!.textLabel?.textColor = UIColor(hexString: "#ffffff", alpha: 1)
        }
        
        return cell_!
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        for index in 0...self.menuItems().count {
            var tempIndexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: indexPath.section)
            var cell: UITableViewCell? = tableView.cellForRowAtIndexPath(tempIndexPath)
            cell?.textLabel?.textColor = UIColor(hexString: "#ffffff", alpha: 0.7)
        }
        let item:String = self.menuItems()[indexPath.row] as! String
        self.performSegueWithIdentifier(item, sender: nil)
        var cell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        cell?.textLabel?.textColor = UIColor(hexString: "#ffffff", alpha: 1)
//        self.slidingViewController resetTopViewAnimated:YES;
        self.slidingViewController().resetTopViewAnimated(true);
//        self.performSegueWithIdentifier(item, sender: nil)
    }
    
    @IBAction func unwindToMenuViewController(segue: UIStoryboardSegue) {
//        if(self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered){
        NSLog("asdfasdfasfd")
       
    }

}
