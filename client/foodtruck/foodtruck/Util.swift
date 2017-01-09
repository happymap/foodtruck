//
//  Util.swift
//  foodtruck
//
//  Created by Yifan Ying on 10/25/15.
//  Copyright © 2015 Yifan Ying. All rights reserved.
//

import Foundation

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
}

