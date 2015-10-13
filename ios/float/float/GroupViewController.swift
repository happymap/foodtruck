//
//  SearchViewController.swift
//  float
//
//  Created by Ben Wang on 10/25/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation

class GroupViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Tapping | ECSlidingViewControllerAnchoredGesture.Panning
        let lIcon = FAKIonIcons.naviconIconWithSize(40)
        lIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let lIconImage = lIcon.imageWithSize(CGSizeMake(40, 40))

        var lBarButtonItem: UIBarButtonItem =  UIBarButtonItem(image: lIconImage, style: .Plain, target: self, action: "unwindToMenuViewController:")
        self.navigationItem.leftBarButtonItem = lBarButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "#ffffff", alpha: 1);
        
        
        let rIcon = FAKIonIcons.ios7PlusEmptyIconWithSize(40)
        rIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let rIconImage = rIcon.imageWithSize(CGSizeMake(40, 40))
        var rBarButtonItem: UIBarButtonItem =  UIBarButtonItem(image: rIconImage, style: .Plain, target: self, action:"switched")
        self.navigationItem.rightBarButtonItem = rBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hexString: "#ffffff", alpha: 1);
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.view.frame.width, self.tableView.frame.height)
    }
    
    @IBAction func unwindToMenuViewController(segue: UIStoryboardSegue) {
        self.slidingViewController().anchorTopViewToRightAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var _cell:GroupListCell? = tableView.dequeueReusableCellWithIdentifier("GroupListCell") as? GroupListCell
        var groupTableTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "switched")
        _cell?.addGestureRecognizer(groupTableTap)
        return _cell!
    }
    
    func tapCell() {
        self.performSegueWithIdentifier("groupEditSegue", sender: self)
    }
    
    func switched() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("GroupCreation") as! UIViewController
        var navController: UINavigationController =  UINavigationController(rootViewController: vc)
        
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        self.presentViewController(navController, animated: true, completion: {
            
            
        })
    }
    
    




}