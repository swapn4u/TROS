//
//  MenuViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mobileNoLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var menuListTableView: UITableView!
    let options = ["Home","Change Location","My Cart","My Orders","Log Out"]//"Notification","Share App","My Account","Login/Sign up"]
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = getValueFor(key: "name")
        mobileNoLabel.text = getValueFor(key: "mobileNo")
        addressLabel.text = getValueFor(key: "address")
        profileView.dropShadow(color: .black, opacity:1, offSet:  CGSize(width: -1, height: 1.5), radius: 3, scale: true)
    }
}
extension MenuViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = options[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.revealViewController().revealToggle(animated: true)
        if indexPath.row == 0
        {
            let categoriesVC = self.loadViewController(identifier: "ProductCategoriesVC") as! ProductCategoriesVC
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(categoriesVC, animated: true)
        }
        if indexPath.row == 1
        {
            let mapVC = self.loadViewController(identifier: "MapViewController") as! MapViewController
             mapVC.isFromMenuSelection = true
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(mapVC, animated: true)
        }
        if indexPath.row == 2
        {
            let cartVC = self.loadViewController(identifier: "CartViewController") as! CartViewController
             cartVC.isFromMenuSelection = true
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(cartVC, animated: true)
        }
        if indexPath.row == 3
        {
            let viewOrderVC = self.loadViewController(identifier: "ViewOrdersVC") as! ViewOrdersVC
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(viewOrderVC, animated: true)
        }
        if indexPath.row == 4
        {
            //CoreDataManager.manager.deleteAllOrderIds { (completed) in
                self.setRootVC("MapViewController")
                let mapViewController = self.loadViewController(identifier:"MapViewController") as! MapViewController
                (self.revealViewController().frontViewController as! UINavigationController).pushViewController(mapViewController, animated: true)
           // }
            
        }
        
    }
}
