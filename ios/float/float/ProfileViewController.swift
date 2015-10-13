//
//  ProfileViewController.swift
//  float
//
//  Created by Ben Wang on 10/22/14.
//  Copyright (c) 2014 Ben Wang. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var name: UILabel!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var aboutMe: UILabel!
    @IBOutlet var currentLocation: UILabel!
    @IBOutlet weak var listInfoView: UITableView!
    
    var clickedUser : User!
    var listTableArray = ["Current location","Certification","Member since"]
    
    override func viewDidLoad() {
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Tapping | ECSlidingViewControllerAnchoredGesture.Panning
        let lIcon = FAKIonIcons.naviconIconWithSize(40)
        lIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let lIconImage = lIcon.imageWithSize(CGSizeMake(40, 40))
//        self.navigationController?.navigationItem.leftBarButtonItem.image = lIconImage
        
        var lBarButtonItem: UIBarButtonItem =  UIBarButtonItem(image: lIconImage, style: .Plain, target: self, action: "unwindToMenuViewController:")
        self.navigationItem.leftBarButtonItem = lBarButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "#ffffff", alpha: 1);
        self.createUser()
        var url: NSURL! = NSURL(string: clickedUser.imageUrl as String) as NSURL!
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
            if (image != nil) {
                self.profileImgView.image = image;
            }
        })
        self.name.text = clickedUser.name as String!
    }
    
    func createUser(){
        clickedUser = User(name: "Ben Wang", mYear: 2014, cert: "ASA-1", location: "San Francisco, CA", imageUrl: "https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/5075_804908270223_3971756_n.jpg?oh=f394ede2b3226e70ec6fadd8e5934e00&oe=54F4CE54&__gda__=1425114002_97d789db4d82365d62f40055fd6ebad8")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTableArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell_ : NameValueCell? = tableView.dequeueReusableCellWithIdentifier("ProfileDetailsCell") as? NameValueCell
        
        cell_!.label.text = listTableArray[indexPath.row]
        switch indexPath.row {
        case 0:
            cell_!.value.text = clickedUser.location as String
            break
        case 1:
            cell_!.value.text = clickedUser.certification as String
            break
        case 2:
            cell_!.value.text = "\(clickedUser.memberYear)"
            break
        default:
            cell_!.value.text = ""
        }
        
        cell_!.backgroundColor = UIColor.clearColor()
        cell_!.textLabel?.textAlignment = NSTextAlignment.Center
        cell_!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell_!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    @IBAction func unwindToMenuViewController(segue: UIStoryboardSegue) {
        self.slidingViewController().anchorTopViewToRightAnimated(true)
        
    }
}