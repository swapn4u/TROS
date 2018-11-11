//
//  ViewController+Extension.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 16/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
struct LocationManager
{
    var latitude : String
    var longitude : String
    init(dict:[String:Any]) {
        self.latitude = dict["lat"] as? String ?? ""
        self.longitude = dict["long"] as? String ?? ""
    }
}

enum leftBarOption
{
    case search ,cart ,none
}
var isSearchHide = true
var searchText = ""
var searchBar = UISearchBar()
extension UIViewController
{
   
    func customiseNavigationBarWith(isHideNavigationBar:Bool ,headingText:String, isBackBtnVisible:Bool , accessToOpenSlider isSliderAllowed:Bool,leftBarOptionToShow:leftBarOption)
    {
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.searchController = nil
        self.revealViewController().panGestureRecognizer().isEnabled = false
        
        //set title
        self.navigationController?.navigationBar.barTintColor=UIColor.red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width/2 , height:44))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = headingText
        searchText = headingText
        self.navigationItem.titleView = label
        
        //navigation bar hide/show
        if isHideNavigationBar
        {
            self.navigationController?.isNavigationBarHidden = true
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        var item1 = UIBarButtonItem()
        var item2 = UIBarButtonItem()
        if isBackBtnVisible
        {
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "back"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn1.addTarget(self, action: #selector(self.backButtonpressed), for: .touchUpInside)
            item1 = UIBarButtonItem(customView: btn1)
            
        }
        
        if isSliderAllowed
        {
            let btn2 = UIButton(type: .custom)
            btn2.setImage(UIImage(named: "sideMenu")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn2.tintColor = UIColor.white
            btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn2.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            item2 = UIBarButtonItem(customView: btn2)
        }
        
        if isBackBtnVisible
        {
            self.navigationItem.setLeftBarButtonItems([item1,item2], animated: true)
        }
        else
        {
            self.navigationItem.setLeftBarButtonItems([item2], animated: true)
        }
        
        var rightItem1 = UIBarButtonItem()
        var rightItem2 = UIBarButtonItem()
        
        let cartBtn = UIButton(type: .custom)
        cartBtn.setImage(UIImage(named: "cart"), for: .normal)
        cartBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cartBtn.addTarget(self, action:#selector(jumpToCartVC), for: UIControlEvents.touchUpInside)
        rightItem1 = UIBarButtonItem(customView: cartBtn)
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.setImage(UIImage(named: "Search")?.withRenderingMode(.alwaysTemplate), for: .normal)
        searchBtn.tintColor = UIColor.white
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if let mapViewController = self as? MapViewController
        {
            searchBtn.addTarget(mapViewController, action: #selector(mapViewController.searchButtonPressed), for: UIControlEvents.touchUpInside)
        }
        rightItem2 = UIBarButtonItem(customView: searchBtn)
        if let productCategoryVC = self as? ProductCategoriesVC
        {
            productCategoryVC.navigationItem.setRightBarButtonItems([rightItem1], animated: true)
        }
        
        if let productCategoryDetailsVC = self as? ProductCategoryDetailsVC
        {
            productCategoryDetailsVC.navigationItem.setRightBarButtonItems([rightItem1,rightItem2], animated: true)
            searchBtn.addTarget(productCategoryDetailsVC, action: #selector(productCategoryDetailsVC.openSearchBar), for: UIControlEvents.touchUpInside)
        }
        else if leftBarOptionToShow != .none
        {
         self.navigationItem.setRightBarButtonItems([leftBarOptionToShow == .cart ? rightItem1 : rightItem2], animated: true)
        }
        let topVc = self.navigationController?.topViewController
        
        if topVc == nil {
            return
        }
    }

    @objc func backButtonpressed() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func jumpToCartVC()
    {
        let CartVC = self.loadViewController(identifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(CartVC, animated: true)
    }
    func loadViewController(identifier:String) -> UIViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
     @objc func openSearchWindowOn(_ viewController:UIViewController)
     {
        if let mapVC =  self as? MapViewController
        {
            mapVC.searchButtonPressed()
        }
        else
        {
            DispatchQueue.main.async {
            if !isSearchHide
            {
                
                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationItem.title = "Select " + searchText.replacingOccurrences(of: "Choose ", with: "")
                
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
                self.navigationController?.navigationBar.titleTextAttributes = [
                    NSAttributedStringKey.foregroundColor : UIColor.white
                ]
                
                self.navigationController?.navigationBar.barTintColor = UIColor.red
                
                let searchController = UISearchController(searchResultsController: nil) // Search Controller
                self.navigationItem.hidesSearchBarWhenScrolling = false
                
                self.navigationItem.searchController = searchController
                searchBar = searchController.searchBar
                //Change Search Bar Placeholder text & color:
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search \(searchText.replacingOccurrences(of: "Choose ", with: ""))", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                
                // Change search bar text color:
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
                
                //Change cancel button title & color
                searchController.searchBar.tintColor = UIColor.white
                UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Dismiss"
                    
            }
            else
            {
                self.navigationController?.navigationBar.prefersLargeTitles = false
                self.navigationItem.searchController = nil
                
            }
            isSearchHide = !isSearchHide
            }
        }
        
    }
   func showAlertFor(title: String, description: String)
   {
    let actionSheetController: UIAlertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        //Just dismiss the action sheet
    }
    actionSheetController.addAction(cancelAction)
    self.present(actionSheetController, animated: true, completion: nil)
    }

   
    func saveRecord(value:String,forKey key : String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    func getValueFor(key:String) -> String
    {
        return UserDefaults.standard.value(forKey: key) as? String ?? ""
    }
    func showLoaderWith(Msg:String?)
    {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.show(withStatus: Msg ?? "Loading ...")
            
        }
    }
    func dismissLoader()
    {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    func getUserInfo() -> LoginUserDetails?
    {
        if let userData = UserDefaults.standard.value(forKey:"UserInfo") as? Data {
            let userinfo = try? PropertyListDecoder().decode(LoginUserDetails.self, from: userData)
            return userinfo
        }
        return LoginUserDetails(dict: [String : Any]())
    }
    func  isInternetActive()->Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    func setRootVC( _ viewController : String)
    {
        UserDefaults.standard.set(viewController, forKey: "root")
    }
 
    func getCordinates() -> LocationManager
    {
        let userDefaults = UserDefaults.standard
        let cordinates = ["lat":userDefaults.value(forKey: "lat") as? String ?? "19.136326","long" : userDefaults.value(forKey: "long") as? String ?? "72.827660"]
        return LocationManager(dict: cordinates)
    }
}

