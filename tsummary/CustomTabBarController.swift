//
//  CustomTabBarController.swift
//  tsummary
//
//  Created by Soporte on 14-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit

class  CustomTabBarController:UITabBarController {
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //let layout = UICollectionViewFlowLayout()
        let schedulerController = SchedulerViewController()
        let navController = UINavigationController(rootViewController: schedulerController)
        navController.tabBarItem.title = "SCHEDULER"
        
        let viewController = ViewController()
        let nav1 = UINavigationController(rootViewController: viewController)
        nav1.tabBarItem.title = "HOME"
        
        viewControllers = [navController]
    }
}
