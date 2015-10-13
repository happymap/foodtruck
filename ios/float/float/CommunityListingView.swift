//
//  CommunityListView.swift
//  float
//
//  Created by Ben Wang on 5/20/15.
//  Copyright (c) 2015 Ben Wang. All rights reserved.
//

import Foundation


class CommunityListingView: UIView, UIScrollViewDelegate {
    var eventImage : UIImageView!
    var eventName : UILabel!
    var eventDate : UILabel!
    var communityRibbon : UILabel!
    
    func createCommunityView(product : Listing, position : Int) {
        self.backgroundColor = UIColor.whiteColor()
        eventImage = UIImageView(frame: CGRectMake(CGFloat(position) * self.frame.width, self.frame.origin.y, self.frame.width, self.frame.height))
        eventName = UILabel(frame: CGRectMake(8, 130, 110, 21))
        eventName.backgroundColor = UIColor.blackColor()
        eventName.textColor = UIColor.whiteColor()
        eventName.text = "EDM Concert"
        communityRibbon = UILabel(frame: CGRectMake(self.frame.width - 150, 130, 150, 21))
        communityRibbon.text = " Community Event"
        communityRibbon.backgroundColor =  UIColor(hexString: "#1abc9c")
        self.addSubview(eventImage)
        self.addSubview(eventName)
        self.addSubview(communityRibbon)
        var url : NSURL = NSURL(string: "https://groovefox.files.wordpress.com/2013/11/edm.jpg?w=1200") as NSURL!
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
            if (image != nil) {
                self.eventImage.image = image
            }
        })
    }
}
