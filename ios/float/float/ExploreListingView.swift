//
//  ExploreProductView.swift
//  Glam
//
//  Created by Rajkumar Sharma on 29/09/14.
//  Copyright (c) 2014 MyAppTemplates. All rights reserved.
//

import UIKit

class ExploreListingView: UIView, UIScrollViewDelegate {
    
    var eventImage : UIImageView!
    var eventName : UILabel!
    var pageControl : UIPageControl!
    var distance : UILabel!
    var userName : UILabel!
    var btnAdd : UIButton!
    var arrImg : NSArray!
    var arrButtons : NSMutableArray! = NSMutableArray()
    var actionButton : UISegmentedControl!
    var numParticipants : UILabel!
//    var contentWidth : CGFloat! =  self.frame.size.width - 50
    
    
    func createViewWithProduct(product : Listing, position : Int) {
        
        self.backgroundColor = UIColor.whiteColor()
        
//        var bgImg : UIImageView! = UIImageView(frame: CGRectMake(0, 170, self.frame.size.width, 40))
//        bgImg.image = UIImage(named: "explore-img-bottom-bg")
        
        eventImage = UIImageView(frame: CGRectMake(15, 15, 75, 75))
        eventName = UILabel(frame: CGRectMake(8, 100, 231, 21))
        distance = UILabel(frame: CGRectMake(8, 127, 81, 21))
        userName = UILabel(frame: CGRectMake(87, 127, 114, 21))
        btnAdd = UIButton(frame: CGRectMake(self.frame.size.width - 60, 129, 66, 18))
        btnAdd.setTitle("View Details", forState: UIControlState.Normal)
        numParticipants = UILabel(frame: CGRectMake(230, 50, 231, 21));
        
        actionButton = UISegmentedControl (items: ["Let's go","Hell no"])
        actionButton.frame = CGRectMake(self.frame.size.width - 135, 130, 130, 20)
        actionButton.tintColor = UIColor.blackColor()
        
        self.eventName.font = UIFont.systemFontOfSize(15)
        self.distance.font = UIFont.systemFontOfSize(14)
        self.userName.font = UIFont.systemFontOfSize(11)
       
        
        self.arrImg = product.arrImg
        self.eventName.text = product.listingTitle as String
        self.distance.text = NSString(format:"%@ %@", product.distance.stringValue, "mi") as String
        self.userName.text = product.eventPerson as String
        self.userName.textColor = UIColor.lightGrayColor()
        
        self.numParticipants.text = NSString(format: "%d invited", product.numInvited) as String
        var url : NSURL = NSURL(string:product.arrImg.objectAtIndex(0) as! String) as NSURL!
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
            if (image != nil) {
                self.eventImage.image = image
            }
        })
        self.addSubview(eventImage)
//        scrollView.delegate = self;
//        if arrImg.count > 1 {
//            self.addSubview(pageControl)
//            pageControl.numberOfPages = arrImg.count
//            pageControl.addTarget(self, action: Selector("pageControlValueChanged"), forControlEvents: UIControlEvents.TouchUpInside)
//        }
//        self.populateImages(position)
//        self.addSubview(bgImg)
        self.addSubview(eventName)
        self.addSubview(distance)
        self.addSubview(userName)
        self.addSubview(btnAdd)
        self.addSubview(actionButton)
        self.addSubview(numParticipants)
    }
    
//    func populateImages(scrollPosition: Int) {
//        NSLog("size is %f", self.frame.size.width)
//        for index in 0...(arrImg.count - 1) {
//            var btn : UIButton! = UIButton(frame: CGRectMake(CGFloat(index * Int(self.frame.size.width)), 0, self.frame.size.width, 250))
//            btn.tag = scrollPosition
//            var scrollImg: UIImage! = UIImage(named: arrImg.objectAtIndex(index) as String)
//            
//            btn.setImage(UIImage(named: arrImg.objectAtIndex(index) as String), forState: UIControlState.Normal)
//            btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
//            scrollView.addSubview(btn)
//            arrButtons.addObject(btn)
//        }
//        scrollView.contentSize = CGSizeMake(CGFloat(arrImg.count * Int(self.frame.size.width)), 0)
//        
//    }
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        self.pageControl.currentPage = Int(self.scrollView.contentOffset.x) / Int(self.frame.size.width)
//    }
//    
//    func pageControlValueChanged(sender : UIPageControl) {
//        self.scrollView.setContentOffset(CGPointMake(CGFloat((self.pageControl.currentPage ) * Int(self.frame.size.width)), 0), animated: true)
//    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
}
