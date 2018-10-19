//
//  MOAMCNavigationViewController.swift
//  MOAMC
//
//  Created by Anurag Kulkarni on 24/01/18.
//  Copyright © 2018 Anurag Kulkarni. All rights reserved.
//

import UIKit

class MOAMCNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationBarAppearance() {
        self.navigationBar.barTintColor = UIColor.red
        self.navigationItem.hidesBackButton = true
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnMenuPressed() {
        print("Side menu btn pressed re......!!!")
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
