//
//  LXDMainViewController.swift
//  LXDSlideMenuSwift
//
//  Created by linxinda on 15/11/29.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

import UIKit

class LXDMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slideManager = LXDSlideManager.sharedManager()
        slideManager.setMainController(self)
        slideManager.setMenuController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("menuController"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
