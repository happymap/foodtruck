//
//  AddList.swift
//  float
//
//  Created by Ben Wang on 6/14/15.
//  Copyright (c) 2015 Ben Wang. All rights reserved.
//

import Foundation

class AddListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell_ : AddListCell? = tableView.dequeueReusableCellWithIdentifier("AddListCell") as? AddListCell
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