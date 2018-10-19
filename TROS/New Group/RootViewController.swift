//
//  RootViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 03/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(true)
        
        var frontViewController = MOAMCNavigationViewController()//create instance of frontVC
        let rearViewController  = self.loadViewController(identifier: "MenuViewController") as! MenuViewController
        let mapViewController = self.loadViewController(identifier: "MapViewController") as! MapViewController
        let productVC = self.loadViewController(identifier: "ProductCategoryVC") as! ProductCategoryVC
        
        if getValueFor(key: "isLogined") == "true"
        {
            frontViewController = MOAMCNavigationViewController(rootViewController: productVC)

        } else {
            frontViewController = MOAMCNavigationViewController(rootViewController: mapViewController)
        }
//
        //create instance of swRevealVC based on front and rear VC
        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController);
        swRevealVC?.toggleAnimationType = SWRevealToggleAnimationType.easeOut;
        swRevealVC?.toggleAnimationDuration = 0.30;
        
        //set swRevealVC as rootVC of windows
        self.present(swRevealVC!, animated: true, completion: nil)

        // Do any additional setup after loading the view.
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
