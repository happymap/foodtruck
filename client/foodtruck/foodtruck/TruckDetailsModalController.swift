//
//  TruckDetailsModalController.swift
//  foodtruck
//
//  Created by Yifan Ying on 4/22/17.
//  Copyright © 2017 Yifan Ying. All rights reserved.
//

import UIKit

class TruckDetailsModalController: UIViewController {
    @IBOutlet var doneBtn: UIButton!
    
    override func viewDidLoad() {
        view.opaque = false
    }
    
    @IBAction func done(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
