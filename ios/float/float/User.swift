//
//  User.swift
//  float
//
//  Created by Ben Wang on 10/23/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation

class User: NSObject {
    var name: NSString!
    var memberYear: NSInteger!
    var certification: NSString!
    var location: NSString!
    var imageUrl: NSString!
    
    init(name: NSString, mYear: NSInteger, cert: NSString, location: NSString, imageUrl: NSString) {
        self.name = name
        self.memberYear = mYear
        self.certification = cert
        self.location = location
        self.imageUrl = imageUrl
    }
}