//
//  ShowSplashScreen.swift
//  tsummary
//
//  Created by OTRO on 16-03-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import UIKit

class ShowSplashScreen: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        perform(#selector(showNavController), with: nil, afterDelay: 5)
       }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func showNavController()
    {
        performSegue(withIdentifier: "showSplashScreen", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
