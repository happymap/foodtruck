//
//  Product.swift
//  Glam
//
//  Created by Rajkumar Sharma on 29/09/14.
//  Copyright (c) 2014 MyAppTemplates. All rights reserved.
//

import UIKit

class Listing: NSObject {
    
    var arrImg : NSArray!
    var listingName : NSString!
    var listingTitle : NSString!
    var listingPrice : NSDecimalNumber!
    var listingPriceType: NSString!
    var listingDescription : NSString!
    var eventPerson : NSString!
    var listingId: NSString!
    var listingType: NSString!
    
    var distance: NSDecimalNumber!
    var time: NSDate!
    var numInvited: NSInteger!
    
    init(listingId: NSString, title : NSString, listName name:NSString, eventDistance distance:NSDecimalNumber, listPriceType type:NSString, listDesc desc:NSString, listingType lType: NSString, person eventPerson:NSString, images arrImgs:NSArray, numInvited num:NSInteger) {
        
        self.arrImg = arrImgs
        self.listingName = name
        self.listingTitle = title
        self.distance = distance
        self.listingPriceType = type
        self.listingDescription = desc
        self.eventPerson = eventPerson
        self.listingId = listingId
        self.listingType = lType
        self.numInvited = num
    }
}
