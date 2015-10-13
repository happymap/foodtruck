//
//  SettingsViewController.swift
//  float
//
//  Created by Ben Wang on 5/26/15.
//  Copyright (c) 2015 Ben Wang. All rights reserved.
//

import Foundation


class SettingsViewController: UIViewController, UIScrollViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Tapping | ECSlidingViewControllerAnchoredGesture.Panning
        let lIcon = FAKIonIcons.naviconIconWithSize(40)
        lIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let lIconImage = lIcon.imageWithSize(CGSizeMake(40, 40))
        
        var lBarButtonItem: UIBarButtonItem =  UIBarButtonItem(image: lIconImage, style: .Plain, target: self, action: "unwindToMenuViewController:")
        self.navigationItem.leftBarButtonItem = lBarButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "#ffffff", alpha: 1);
    }
    
    @IBAction func unwindToMenuViewController(segue: UIStoryboardSegue) {
        self.slidingViewController().anchorTopViewToRightAnimated(true)
    }
}