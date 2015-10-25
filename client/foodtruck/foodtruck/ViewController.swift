//
//  ViewController.swift
//  foodtruck
//
//  Created by Yifan Ying on 10/16/15.
//  Copyright © 2015 Yifan Ying. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController {

    var truckList:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get list of trucks
        let url = NSURL(string: "http://ngtemplates.com:3000/truck/list")
        
        let nib = UINib(nibName: "truckCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "truckCell")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            self.truckList = self.JSONParseArray(NSString(data: data!, encoding:NSUTF8StringEncoding) as! String)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        task.resume()
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
        cell.loadItem(truckList[indexPath.row]["name"] as! String)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
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
}

class truckCell : UITableViewCell {
    @IBOutlet var truckImgVuew: UIImageView!
    @IBOutlet var truckNameLabel: UILabel!
    
    func loadItem(truckName: String) {
        truckNameLabel.text = truckName
    }
}

