//
//  RootViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 21/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frontViewController = self.loadViewController(identifier: "ProductCategoryVC") as! ProductCategoryVC
        let frontNav = UINavigationController(rootViewController: frontViewController)
//        let rearViewController  = self.loadViewController(identifier: "MenuViewController") as! MenuViewController//create instance of rearVC(menuVC)
//
//
//        //create instance of swRevealVC based on front and rear VC
//        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController) as! SWRevealViewController
//        swRevealVC.toggleAnimationType = SWRevealToggleAnimationType.easeOut;
//        swRevealVC.toggleAnimationDuration = 0.30;
//       self.navigationController?.pushViewController(swRevealVC, animated: true)
      //  navigationControoler.pushViewController(swRevealVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
