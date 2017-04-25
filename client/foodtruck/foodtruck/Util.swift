//
//  Util.swift
//  foodtruck
//
//  Created by Yifan Ying on 10/25/15.
//  Copyright © 2015 Yifan Ying. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static let dict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("environment", ofType: "plist")!)
    
    class func getEnvProperty(key: String) -> String {
        return dict!.objectForKey(key) as! String
    }
    
    // convert string to json object
    class func JSONParseArray(string: String) -> [AnyObject]{
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
    
    class func convertToHours(seconds: Int) -> String {
        var hourStr: String!
        var minuteStr: String!
        
        hourStr = seconds/3600 < 10 ? "0\(seconds/3600)" : "\(seconds/3600)"
        minuteStr = seconds%3600/60 < 10 ? "0\(seconds%3600/60)" : "\(seconds%3600/60)"
        return "\(hourStr):\(minuteStr)"
    }
    
    class func loadImage(imageView: UIImageView, imageUrl: String) {
        if let url: NSURL = NSURL(string: imageUrl)! {
            getDataFromUrl(url) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    class func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}

