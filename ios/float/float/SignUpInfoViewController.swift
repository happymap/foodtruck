//
//  SignUpInfoViewController.swift
//  float
//
//  Created by Ben Wang on 5/26/15.
//  Copyright (c) 2015 Ben Wang. All rights reserved.
//

import Foundation

class SignUpInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{
    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var tapToEdit:UILabel!
    @IBOutlet var name:UITextField!
    
    var mediaPicker: UIImagePickerController!
    
    override func viewDidLoad() {
        var buttonHeight : CGFloat = 40
        var y : CGFloat = UIScreen.mainScreen().bounds.size.height - buttonHeight
        let button: UIButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, y, self.view.frame.size.width, buttonHeight)
        button.backgroundColor = UIColor(hexString: "#00ACE0", alpha: 0.95)
        button.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 20)
        
        button.setTitle("Sign me up", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        button.setTitleColor(UIColor(hexString: "#ffffff", alpha: 1), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        profileImg.userInteractionEnabled = true
        tapToEdit.userInteractionEnabled = true
        profileImg.center.x = self.view.center.x
        tapToEdit.center.x = self.view.center.x
        name.center.x = self.view.center.x
        
        profileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageViewTapped:"))
        tapToEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageViewTapped:"))
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
//        var user: NSString = defaults.objectForKey("fbEmail") as! NSString
        
        
//        name.text = defaults.objectForKey("fbDisplayName") as! String
//        var fbProfileImgUrl : NSString = NSString(format: "http://graph.facebook.com/%@/picture?type=square&width=300&height=300", defaults.objectForKey("fbObjID") as! String)
//        var url : NSURL = NSURL(string: fbProfileImgUrl as String)! as NSURL
//        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
//            if (image != nil) {
//                self.profileImg.image = image
//            }
//        })
        
        

    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex: NSInteger ) {
        if (clickedButtonAtIndex < 2) {
            if (clickedButtonAtIndex == 0) {
                mediaPicker.sourceType = UIImagePickerControllerSourceType.Camera;
                mediaPicker.cameraDevice = UIImagePickerControllerCameraDevice.Front;
            } else if (clickedButtonAtIndex == 1) {
                mediaPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            }
        
            self.presentViewController(mediaPicker, animated: true, completion: nil)
        }
    }

    @IBAction func imageViewTapped(sender: UIGestureRecognizer) {
        mediaPicker = UIImagePickerController();
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true;
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            var actionSheet:UIActionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil
            , otherButtonTitles: "Camera", "From photo library")
            actionSheet.showInView(self.view)
        } else {
            mediaPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(mediaPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonAction(sender: UIGestureRecognizer) {
        self.performSegueWithIdentifier("signInSegue", sender: self)
    }
    
}