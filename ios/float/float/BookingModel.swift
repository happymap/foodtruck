//
//  Booking.swift
//  float
//
//  Created by Ben Wang on 10/29/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation

class BookingModel: NSObject {
    var imgUrl : NSString!
    var listingId: NSString!
    var listingTitle : NSString!
    var listingPrice : NSDecimalNumber!
    var listingPriceType: NSString!
    var listingType: NSString!
    
    var count: Int!
    var totalPrice: NSDecimalNumber!
    var startDate: NSDate!
    var endDate: NSDate!
    var bookingStatus: NSString!
    
    init(fromListing ld: ListingDetails) {
        listingType = ld.summary.listingType
        listingPrice = ld.summary.listingPrice
        listingPriceType = ld.summary.listingPriceType
        listingTitle = ld.summary.listingName
        imgUrl = ld.summary.arrImg[0] as! String
    }
    
    init(listingId: NSString, title : NSString, listPrice price:NSDecimalNumber, listPriceType type:NSString, listDesc desc:NSString, company listCompany:NSString, images imgUrl:NSString, type listingType: NSString) {
        
        self.imgUrl = imgUrl
        self.listingTitle = title
        self.listingPrice = price
        self.listingPriceType = type
        self.listingId = listingId
        self.listingType = listingType
    }
}