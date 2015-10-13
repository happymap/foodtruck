//
//  ListingDetails.swift
//  float
//
//  Created by Ben Wang on 10/22/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation



class ListingDetails: NSObject {
    var summary: Listing!
    var latitude: Double = 0
    var longitude: Double = 0
    var address: NSString! = ""
    var city: NSString! = ""
    var state: NSString! = ""
    var zip: NSString! = ""
    var maxCapacity: NSInteger! = 0
    var assetType: NSString! = ""
    var serviceType: NSString! = ""
    var ownerImage: NSString! = ""
    var ownerName: NSString! = ""
    var ownerId: NSString! = ""
    var reviewCount: NSInteger = 0
    var rating: NSInteger = 0
    
    init(summary: Listing) {
        self.summary = summary
    }
    init(summary : Listing, latitude: Double, longitude: Double, address: NSString, city: NSString, state: NSString, zip: NSString, maxCapacity: NSInteger, assetType: NSString, serviceType: NSString, ownerImage:NSString, ownerName: NSString, ownerId: NSString, reviewCount: NSInteger, rating: NSInteger) {
        self.summary = summary
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.maxCapacity = maxCapacity
        self.assetType = assetType
        self.serviceType = serviceType
        self.ownerImage = ownerImage
        self.ownerName = ownerName
        self.ownerId = ownerId
        self.reviewCount = reviewCount
        self.rating = rating
    }
}
