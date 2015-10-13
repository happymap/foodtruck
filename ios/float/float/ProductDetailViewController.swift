//
//  ProductDetailViewController.swift
//  float
//
//  Created by Ben Wang on 10/20/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation
import MapKit

class ProductDetailViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, ECSlidingViewControllerDelegate {
    @IBOutlet var price : UILabel!
    @IBOutlet var listingTitle : UILabel!
    @IBOutlet var listingDesc : UITextView!
    @IBOutlet var imageScroll : UIScrollView!
    @IBOutlet var imageScrollControl : UIPageControl!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var profileView: UIImageView!
    @IBOutlet weak var listInfoView: UITableView!
    @IBOutlet var pageScrollView : UIScrollView!
    @IBOutlet var nameInfoSect: UIView!
    var detailsData:ListingDetails!
    var imgWidth: CGFloat = 0.0
    var productImgHeight: CGFloat = 0.0
    var listTableArray = ["Listing Type","Service Type","Asset Type","Max Capacity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgWidth = self.view.frame.size.width
        productImgHeight = 255
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "#ffffff")
        self.price.text =  detailsData.summary.distance.stringValue
        self.listingTitle.text =  detailsData.summary.listingTitle as String
        var bookingButtonHeight : CGFloat = 40
        var y : CGFloat = UIScreen.mainScreen().bounds.size.height - bookingButtonHeight
        
        
        let button : UIButton  = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, y, self.view.frame.size.width, bookingButtonHeight)
        button.backgroundColor = UIColor(hexString: "#00ACE0", alpha: 0.95)
        button.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 20)
        
        button.setTitle("Let's go", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        button.setTitleColor(UIColor(hexString: "#ffffff", alpha: 1), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        let productScrollContentWidth: CGFloat = self.imgWidth * CGFloat(detailsData.summary.arrImg.count)
//        self.imageScroll.frame = CGRectMake(self.imageScroll.frame.origin.x, self.imageScroll.frame.origin.y, self.view.frame.size.width, self.imageScroll.frame.height)
//        self.view.bringSubviewToFront(self.imageScroll)
        
        self.listInfoView.frame = CGRectMake(self.listInfoView.frame.origin.x, self.listInfoView.frame.origin.y, self.view.frame.size.width, self.listInfoView.frame.height)
//        self.imageScroll.contentSize = CGSizeMake(productScrollContentWidth, productImgHeight)
        self.profileView.frame = CGRectMake(self.view.frame.width - self.profileView.frame.width - 20, self.profileView.frame.origin.y, self.profileView.frame.width, self.profileView.frame.height)
        self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.view.frame.width, self.mapView.frame.height)

        mockData()
        var pageScrollViewHeight = self.listInfoView.frame.height + self.mapView.frame.height + button.frame.height + 150
        
        self.pageScrollView.frame = CGRectMake(self.pageScrollView.frame.origin.x, self.pageScrollView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)
        
        self.pageScrollView.contentSize = CGSize(width: self.view.frame.width, height: pageScrollViewHeight)
        
    }
    
    func mockData() {
        
        detailsData.ownerImage = "http://iarouse.com/dist-simplify/v1/images/g1.jpg"
        detailsData.summary.arrImg = ["https://a0.muscache.com/ic/pictures/52843305/035e53d7_original.jpg?interpolation=lanczos-none&size=x_large&output-format=progressive-jpeg&output-quality=50", "https://a2.muscache.com/ic/pictures/52843288/e88794a1_original.jpg?interpolation=lanczos-none&size=xx_large&output-format=jpg&output-quality=50", "https://a0.muscache.com/ic/pictures/52843305/035e53d7_original.jpg?interpolation=lanczos-none&size=x_large&output-format=progressive-jpeg&output-quality=50"]
        detailsData.latitude = 37.8096506
        detailsData.longitude = -122.410249
        detailsData.serviceType = "Bareboat"
        detailsData.assetType = "Sail boat"
        detailsData.maxCapacity = 5
        detailsData.address = "Pier 39"
        detailsData.city = "San Francisco"
        detailsData.state = "CA"
        detailsData.zip = "91006"
        renderData()
    }
    
    func renderData() {
        var url: NSURL = NSURL(string: self.detailsData.ownerImage as String) as NSURL!
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
            if (image != nil) {
                self.profileView.image = image
                self.profileView.layer.borderWidth = 2
                self.profileView.layer.borderColor = UIColor.grayColor().CGColor
                self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2
                self.profileView.layer.masksToBounds = true
            }
        })
        self.mapView.centerCoordinate.longitude = detailsData.longitude
        self.mapView.centerCoordinate.latitude = detailsData.latitude
        let listingLocationPoint = CLLocationCoordinate2DMake(detailsData.latitude, detailsData.longitude)
        var region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(listingLocationPoint, 500, 500)
        self.mapView.setRegion(region, animated: false)
        var point: MKPointAnnotation = MKPointAnnotation()
        point.coordinate = listingLocationPoint
        self.mapView.addAnnotation(point)
        
//        var productImgArray =  detailsData.summary.arrImg as [NSString]!
//        for var imgPos = 0; imgPos < productImgArray.count; ++imgPos {
//            var xOrigin: CGFloat = CGFloat(imgPos) * self.imgWidth
//            var sliderImgView: UIImageView = UIImageView(frame: CGRectMake(xOrigin, CGFloat(0), self.imgWidth, self.productImgHeight))
//            self.imageScroll.addSubview(sliderImgView)
//            loadImage(productImgArray[imgPos], imgView: sliderImgView)
//        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTableArray.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell_ : NameValueCell? = tableView.dequeueReusableCellWithIdentifier("ProductDetailsCell") as? NameValueCell

        cell_!.label.text = listTableArray[indexPath.row]
        cell_!.value.frame = CGRectMake(self.view.frame.width - cell_!.value.frame.width - 20, cell_!.value.frame.origin.y, cell_!.value.frame.width, cell_!.value.frame.height)
//        ["Listing Type","Service Type","Asset Type","Max Capacity"]
        switch indexPath.row {
        case 0:
            cell_!.value.text = detailsData.summary.listingType as String
            break
        case 1:
            cell_!.value.text = detailsData.serviceType  as String
            break
        case 2:
            cell_!.value.text = detailsData.assetType  as String
            break
        case 3:
            cell_!.value.text = String(detailsData.maxCapacity)
            break
        default:
            cell_!.value.text = ""
        }
        
        cell_!.backgroundColor = UIColor.clearColor()
        cell_!.textLabel?.textAlignment = NSTextAlignment.Center
        cell_!.selectionStyle = UITableViewCellSelectionStyle.None
    
        return cell_!
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "confirmToPay" {
            var detailsVC:ConfirmationViewController = segue.destinationViewController as! ConfirmationViewController
            detailsVC.bookingData = BookingModel(fromListing: self.detailsData)
        }
    }
    
    func loadImage (productImgUrl: NSString, imgView: UIImageView) {
        var url: NSURL = NSURL(string: productImgUrl as String)!
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
            if (image != nil) {
                imgView.image = image
            }
        })
    }
    
    func buttonAction(sender: UIButton) {
        NSLog("request to book clicked");
        self.performSegueWithIdentifier("confirmToPay", sender: self)
    }
    
    func favButtonClicked(sender: UIButton) {
        NSLog("fav button clicked");
    }
}