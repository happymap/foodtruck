//
//  GroupCreationViewController.swift
//  float
//
//  Created by Ben Wang on 6/6/15.
//  Copyright (c) 2015 Ben Wang. All rights reserved.
//

import Foundation

class GroupCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var groupImg:UIImageView!
    @IBOutlet var groupName:UITextView!
    @IBOutlet var groupType: UILabel!
    @IBOutlet var memberLabel: UILabel!
    @IBOutlet var contactListTable: UITableView!
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "createGroup")
        self.memberLabel.center.x = self.view.center.x
        self.contactListTable.center.x = self.view.center.x
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func createGroup() {
        //http call
        self.dismiss()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        //        self.performSegueWithIdentifier(item, sender: nil)
    }

}