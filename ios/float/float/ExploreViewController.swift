//
//  ExploreViewController.swift
//  Glam
//
//  Created by Rajkumar Sharma on 29/09/14.
//  Copyright (c) 2014 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation

class ExploreViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var topScroll : UIScrollView!
    @IBOutlet var contentScroll : UIScrollView!
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var topNavView : UIView!
    @IBOutlet var rightIcon: UIButton!
    @IBOutlet var leftIcon: UIButton!
    @IBOutlet var pageTitleView: UIView!
    @IBOutlet var topDestinationPhoto: UIImageView!
    @IBOutlet var pageScrollView : UIScrollView!
    @IBOutlet var label: UILabel!
    @IBOutlet var ibSwitch: SevenSwitch!
    var mediaPicker: UIImagePickerController!
    
    var arrProduct : NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        UserLocation.manager;
        super.viewDidLoad()
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Tapping | ECSlidingViewControllerAnchoredGesture.Panning
//        self.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        self.topScroll.contentSize = CGSizeMake(CGFloat(2) * self.view.frame.width, 0)
        self.topScroll.pagingEnabled = true
        
        self.createProducts()
        self.populateScrollView()
        self.navigationController?.navigationBar.hidden = true
        topNavView.frame = CGRectMake(topNavView.frame.origin.x, topNavView.frame.origin.y, self.view.frame.size.width, topNavView.frame.size.height)
        pageTitleView.frame = CGRectMake(pageTitleView.frame.origin.x, pageTitleView.frame.origin.y, self.view.frame.size.width, pageTitleView.frame.size.height)
        
        topNavView.layer.shadowColor = UIColor.grayColor().CGColor
        topNavView.layer.shadowRadius = 0.4
        topNavView.layer.shadowOffset = CGSizeMake(0, 1)
        topNavView.layer.shadowOpacity = 1
//        FAKIonIcons *mailIcon = [FAKIonIcons ios7EmailIconWithSize:48];
        let lIcon = FAKIonIcons.naviconIconWithSize(40)
        lIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let lIconImage = lIcon.imageWithSize(CGSizeMake(40, 40))
        leftIcon.setImage(lIconImage, forState: UIControlState.Normal)
        
        let rIcon = FAKIonIcons.ios7PlusEmptyIconWithSize(40)
        rIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let rIconImage = rIcon.imageWithSize(CGSizeMake(40, 40))
        rightIcon.setImage(rIconImage, forState: UIControlState.Normal)
        contentScroll.frame = CGRectMake(self.contentScroll.frame.origin.x
            , self.contentScroll.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)
        contentScroll.backgroundColor = UIColor(hexString: "#f6f0eb")
        rightIcon.frame = CGRectMake(self.view.frame.size.width - 40, self.rightIcon.frame.origin.y, self.rightIcon.frame.size.width, self.rightIcon.frame.size.height)
//        topDestinationPhoto.frame = CGRectMake(self.topDestinationPhoto.frame.origin.x, self.topDestinationPhoto.frame.origin.y, self.view.frame.width, self.topDestinationPhoto.frame.size.height)
        topScroll.frame = CGRectMake(0, 0, self.view.frame.size.width, 170)
        // Do any additional setup after loading the view.
        
        
        let statusSwitch = SevenSwitch(frame: CGRectMake(0, 0, 60, 30))
        statusSwitch.center = CGPointMake(self.view.bounds.size.width - 35, 20)
        label = UILabel(frame: CGRectMake(5, 5, 150, 30))
        label.text = "My Panimal Status";
        
        statusSwitch.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        statusSwitch.isRounded = true
        
        var bookingButtonHeight : CGFloat = 40
        var y : CGFloat = UIScreen.mainScreen().bounds.size.height - bookingButtonHeight
        
        
        let v   = UIView(frame: CGRectMake(0, y, self.view.frame.size.width, bookingButtonHeight)) as UIView
        v.backgroundColor = UIColor.greenColor()
        v.addSubview(statusSwitch)
        v.addSubview(label)
        self.view.addSubview(v)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createProducts() {
        var product1 = Listing(listingId: "12345", title: "I am a coffeholic, going to Philz", listName: "Charlotte going to philz", eventDistance: 0.1, listPriceType: "person", listDesc: "Charlotte is going to philz at Redwood City", listingType: ListingType.Tour.rawValue, person: "Charlotte", images: ["https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xta1/v/t1.0-1/p480x480/10710953_10152311891616402_8723451579588324726_n.jpg?oh=bb078e0181cc0545036246c4c3186c83&oe=55C5271E&__gda__=1442965089_f9ba21e4ec156b487f78e4a240497467"], numInvited: 2)
        var product2 = Listing(listingId: "12345", title: "Party with me at Ruby Skye", listName: "Ben going to Ruby Skye", eventDistance: 0.3, listPriceType: "day", listDesc: "Sample", listingType: ListingType.SleepOver.rawValue,  person: "Justin", images: ["https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/c0.14.480.480/p480x480/1374195_10102503890006163_1355935310_n.jpg?oh=dda2ec31e2746d39eaf26a52680c874a&oe=560CE2DB&__gda__=1438781406_c20a7214932cc85fd241d4bbafbbd605"], numInvited: 3)
        var product3 = Listing(listingId: "23456", title: "Lunch with me at LV Mar", listName: "Speak-er", eventDistance: 0.5, listPriceType: "day", listDesc: "Sample", listingType: ListingType.Rental.rawValue, person: "Ben", images: ["https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/c0.14.480.480/p480x480/1374195_10102503890006163_1355935310_n.jpg?oh=dda2ec31e2746d39eaf26a52680c874a&oe=560CE2DB&__gda__=1438781406_c20a7214932cc85fd241d4bbafbbd605"], numInvited: 5)
        
        arrProduct.addObject(product1)
        arrProduct.addObject(product2)
        arrProduct.addObject(product3)
//        arrProduct.addObject(product5)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    func populateScrollView() {
//        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
//            .response { (request, response, data, error) in
//                println(request)
//                println(response)
//                println(error)
//        }
//        
        for index in 0...(arrProduct.count-1) {
            var currentProduct : Listing = arrProduct.objectAtIndex(index) as! Listing
            var currentView : ExploreListingView! = ExploreListingView(frame: CGRectMake(0, CGFloat(200 + index * 170), self.view.frame.size.width, 150))
            currentView.createViewWithProduct(currentProduct, position: index)
            contentScroll.addSubview(currentView)
            currentView.tag = index
            var gest:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "productSelected:")
            currentView.addGestureRecognizer(gest)
//            for button in currentView.arrButtons {
//                button.addTarget(self, action: Selector("productSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
//            }
        }
        
        
        var currentProduct : Listing = arrProduct.objectAtIndex(0) as! Listing
        var currentView : CommunityListingView! = CommunityListingView(frame: CGRectMake(0, 0, self.view.frame.size.width, 250))
        currentView.backgroundColor = UIColor.blackColor()
        currentView.createCommunityView(currentProduct, position: 0)
        topScroll.addSubview(currentView)
//            currentView.tag = index
        var gest:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "productSelected:")
        topScroll.addGestureRecognizer(gest)
        
        
        var currentView1 : CommunityListingView! = CommunityListingView(frame: CGRectMake(self.view.frame.width, 0, self.view.frame.size.width, 250))
        currentView1.createCommunityView(currentProduct, position: 0)
        topScroll.addSubview(currentView1)
        
        
        contentScroll.contentSize = CGSizeMake(0,CGFloat(arrProduct.count * 170 + 200))
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        if scrollView == self.topScroll {
//            self.pageControl.currentPage = Int(self.topScroll.contentOffset.x) / 320
//        }
    }
    
    @IBAction func pageControlValueChanged(sender : UIPageControl) {
        self.topScroll.setContentOffset(CGPointMake(CGFloat((self.pageControl.currentPage ) * 320), 0), animated: true)
    }
    
    @IBAction func productSelected(sender: UITapGestureRecognizer) {
        NSLog("position %d", sender.view!.tag);
        self.performSegueWithIdentifier("pushProductDetail", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushProductDetail" {
            let b: UITapGestureRecognizer = sender as! UITapGestureRecognizer;
            var detailsVC:ProductDetailViewController = segue.destinationViewController as! ProductDetailViewController
            var listData = arrProduct.objectAtIndex(b.view!.tag) as! Listing
            detailsVC.detailsData = ListingDetails(summary: listData);
        }
    }
    
    @IBAction func searchClicked(sender : UIButton) {
        self.slidingViewController().underLeftViewController.performSegueWithIdentifier("Search", sender: nil)
        
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.contentScroll {
            if scrollView.contentOffset.y < 91 {
                self.topNavView.alpha = scrollView.contentOffset.y/91.0
            } else {
                UIView.animateWithDuration(0.2, delay: 0, options:nil, animations: {
                    self.topNavView.alpha = 1
                    }, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func unwindToMenuViewController(sender: UIStoryboardSegue) {
//        if(self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered){
        NSLog("asdf")
        

    }
    
    
    @IBAction func imageViewTapped(sender: UIButton) {
        mediaPicker = UIImagePickerController();
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true;
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
//            var actionSheet:UIActionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil
//                , otherButtonTitles: "Camera", "From photo library")
//            actionSheet.showInView(self.view)
            mediaPicker.sourceType = UIImagePickerControllerSourceType.Camera
            var overlay: CameraOverlayView = CameraOverlayView(frame: CGRectMake(0, self.view.bounds.height - 150, self.view.bounds.width, 50))
            
            mediaPicker.cameraOverlayView = overlay
//            mediaPicker.showsCameraControls = false
            
        } else {
            mediaPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        self.presentViewController(mediaPicker, animated: true, completion: nil)
    }

    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func switchChanged(sender: SevenSwitch) {
        println("Changed value to: \(sender.on)")
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!){

        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: EventCreationViewController =  storyboard.instantiateViewControllerWithIdentifier("EventCreation") as! EventCreationViewController
        var navController: UINavigationController =  UINavigationController(rootViewController: vc)
       
        vc.eventImg = image
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        self.presentViewController(navController, animated: true, completion: {
            

        })
        
    }
    
}
