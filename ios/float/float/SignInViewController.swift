//
//  SignInViewController.swift
//  float
//
//  Created by Ben Wang on 10/26/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation
import DigitsKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class SignInViewController: UIViewController, FBLoginViewDelegate {
    @IBOutlet var signInButton:UIButton!
    @IBOutlet var phoneImg:UIImageView!
    @IBOutlet var sloganLabel:UILabel!
    @IBOutlet var logoLabel:UILabel!
    @IBOutlet var pImg:UIImageView!
    
    @IBOutlet var fbLoginView : FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let phoneIcon = FAKIonIcons.ios7TelephoneIconWithSize(30)
        phoneIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let phoneIconImage = phoneIcon.imageWithSize(CGSizeMake(30, 30))
        self.phoneImg.image = phoneIconImage;
        self.view .bringSubviewToFront(self.phoneImg)
        self.phoneImg.frame = CGRectMake(5, 5, 30, 30)
        var logoView = UIImageView(frame: CGRectMake(0, self.view.center.y - 200, 250, 100))
        logoLabel.frame = CGRectMake(80, 80, self.logoLabel.frame.width, self.logoLabel.frame.height)
        pImg.frame = CGRectMake(0, 0, self.pImg.frame.width, self.pImg.frame.height)
        logoView.center.x = self.view.center.x
        
        
        logoView.addSubview(self.pImg)
        logoView.addSubview(self.logoLabel)
        
        //let authenticateButton = DGTAuthenticateButton(authenticationCompletion: {
            //(session: DGTSession!, error: NSError!) in
            // play with Digits session
        //})
        //authenticateButton.center = self.view.center
        //self.view.addSubview(authenticateButton)
        sloganLabel.center.x = self.view.center.x
        signInButton.center.x = self.view.center.x
        signInButton.addSubview(phoneImg)
        let digitsAppearance = DGTAppearance()
        // Change color properties to customize the look:
        digitsAppearance.backgroundColor = UIColor.blackColor()
        digitsAppearance.accentColor = UIColor.greenColor()
        self.view.addSubview(logoView)
        

            fbLoginView.frame = CGRectMake(fbLoginView.frame.origin.x, signInButton.frame.origin.y + 60, signInButton.frame.width,  signInButton.frame.height)
            self.view.addSubview(fbLoginView)
            fbLoginView.center.x = self.view.center.x
            fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
            self.fbLoginView.delegate = self

    }
    
    
    @IBAction func didTapButton(sender: AnyObject) {
        self.performSegueWithIdentifier("signUpInfo", sender: self)
        let digits = Digits.sharedInstance()
        digits.authenticateWithCompletion { (session, error) in
            if(error != nil) {
                //NSLog(session.phoneNumber)
                
            }
            // Inspect session/error objects
        }
    }
    
    
    @IBAction func signIn(sender : UIButton) {
        self.performSegueWithIdentifier("signUpInfo", sender: self)
//        self.performSegueWithIdentifier("loginInSegue", sender: sender)
    }
    
    @IBAction func signUpInfo(sender : UIButton) {
        self.performSegueWithIdentifier("signUpInfo", sender: sender)
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as! String
        println("User Email: \(userEmail)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userEmail, forKey: "fbEmail")
        defaults.setObject(user, forKey: "fbUser")
        defaults.setObject(user.objectID, forKey: "fbObjID")
        defaults.setObject(user.first_name, forKey: "fbFirstName")
        defaults.setObject(user.last_name, forKey: "fbLastName")
        defaults.setObject(user.name, forKey: "fbDisplayName")
        
        self.performSegueWithIdentifier("signUpInfo", sender: self)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
}