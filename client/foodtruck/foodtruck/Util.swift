//
//  Util.swift
//  foodtruck
//
//  Created by Yifan Ying on 10/25/15.
//  Copyright © 2015 Yifan Ying. All rights reserved.
//

import Foundation

class Util {
    
    let dict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("environment", ofType: "plist")!)
    
    func getEnvProperty(key: String) -> String {
        return dict!.objectForKey(key) as! String
    }
}

