//
//  ConfirmViewController.swift
//  float
//
//  Created by Ben Wang on 10/28/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation

class ConfirmationViewController: UIViewController, PayPalPaymentDelegate, SACalendarDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet var startDateButton:UIButton!
    @IBOutlet var endDateButton:UIButton!
    @IBOutlet var singleDateButton:UIButton!
    @IBOutlet var countPicker: UIPickerView!
    @IBOutlet var bookingImage: UIImageView!
    @IBOutlet var price: UILabel!
    @IBOutlet var priceType: UILabel!
    @IBOutlet var bookingTitle: UILabel!
    @IBOutlet var listingType: UILabel!
    var bookingData:BookingModel!
    
    var config = PayPalConfiguration()
    var calendar:SACalendar = SACalendar(frame: CGRectMake(50, 200, 220, 220), scrollDirection: ScrollDirectionVertical, pagingEnabled: false)
    //    var calendarView: TSQCalendarView!
    
    var startDateButtonSelected:Bool! = false
    var endDateButtonSelected:Bool! = false
    var singleDateButtonSelected:Bool! = false
    
    
    override func viewDidLoad() {
        let listingObjType:ListingType = ListingType(rawValue: bookingData.listingType) as ListingType!
        switch listingObjType {
        case .Fishing:
            NSLog("fishing")
            startDateButton.hidden = true
            endDateButton.hidden = true
            break
        case .Tour:
            NSLog("tour")
            startDateButton.hidden = true
            endDateButton.hidden = true
            break
        case .Rental:
            NSLog("rental")
            startDateButton.hidden = true
            endDateButton.hidden = true
            countPicker.hidden = true
            break
        case .SleepOver:
            NSLog("sleepover")
            singleDateButton.hidden = true
            break
        }
        
        var url : NSURL = NSURL(string: self.bookingData.imgUrl as String) as NSURL!
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
            if (image != nil) {
                self.bookingImage.image = image
            }
        })
        
        
        self.listingType.text = listingObjType.rawValue as String
        calendar.delegate = self
        self.view.addSubview(calendar)
        calendar.hidden = true
        populateView()
        
        var bookingButtonHeight : CGFloat = 40
        var y : CGFloat = UIScreen.mainScreen().bounds.size.height - bookingButtonHeight
        
        
        let button: UIButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, y, self.view.frame.size.width, bookingButtonHeight)
        button.backgroundColor = UIColor(hexString: "#00ACE0", alpha: 0.95)
        button.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 20)
        
        button.setTitle("Pay", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        button.setTitleColor(UIColor(hexString: "#ffffff", alpha: 1), forState: UIControlState.Normal)
        button.addTarget(self, action: "payClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        
    }
    
    func populateView() {
        if (self.bookingData != nil) {
            self.price.text = self.bookingData.listingPrice.stringValue
            self.bookingTitle.text = self.bookingData.listingTitle as String
            self.bookingTitle.adjustsFontSizeToFitWidth = true
            
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return NSString(format: "%d %@", row + 1, self.bookingData.listingPriceType) as String
    }
    
    // Prints out the selected date
    func calendar(calendar: SACalendar!, didSelectDate day: Int32, month: Int32, year: Int32) {
        var selectedDateString = NSString(format: "%d/%d/%d", month, day, year)
        let formatter:NSDateFormatter = NSDateFormatter();
        formatter.dateFormat = "MM/dd/yyyy"
        NSLog(selectedDateString as String)
        if (startDateButtonSelected != nil && startDateButtonSelected == true) {
            startDateButton.setTitle(selectedDateString as String, forState: UIControlState.Normal)
            startDateButton.titleLabel?.textAlignment = NSTextAlignment.Center
        }
        
        if (endDateButtonSelected != nil && endDateButtonSelected == true) {
            endDateButton.setTitle(selectedDateString as String, forState: UIControlState.Normal)
            endDateButton.titleLabel?.textAlignment = NSTextAlignment.Center
        }
        
        if (singleDateButtonSelected != nil && singleDateButtonSelected == true) {
            singleDateButton.setTitle(selectedDateString as String, forState: UIControlState.Normal)
            singleDateButton.titleLabel?.textAlignment = NSTextAlignment.Center
        }
        
        calendar.hidden = true
        startDateButtonSelected = false
        endDateButtonSelected = false
        singleDateButtonSelected = false
    }
    
    @IBAction func startDateButtonSelected(sender : UIButton) {
        calendar.hidden = false
        startDateButtonSelected = true
    }
    
    @IBAction func endDateButtonSelected(sender : UIButton) {
        calendar.hidden = false
        endDateButtonSelected = true
    }
    
    @IBAction func singleDateButtonSelected(sender : UIButton) {
        calendar.hidden = false
        singleDateButtonSelected = true
    }
    
    @IBAction func payClicked(sender : AnyObject) {
        let amount = NSDecimalNumber(string:"10.00")
        
        println("amount \(amount)")
        
        var payment = PayPalPayment()
        payment.amount = amount
        payment.currencyCode = "EUR"
        payment.shortDescription = "Swift payment"
        
        if (!payment.processable) {
            println("You messed up!")
        } else {
            println("THis works")
            var paymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
            self.presentViewController(paymentViewController, animated: false, completion: nil)
        }
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
