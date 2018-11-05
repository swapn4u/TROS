//
//  ErrorAlertController.swift
//  MOAMC
//
//  Created by Swapnil Katkar on 19/04/18.
//  Copyright © 2018 Motilal Oswal Securities Ltd. All rights reserved.
//

import UIKit
enum ErrorCase: String {
    case NoError = "success"
    case NoDataAvailable = "NoDataAvailable"
    case NoRecordsAvailable = "NoRecordsAvailable"
    case NoInternetConnection = "NoInternetConnection"
    case SomethingWentWrong = "SomethingWentWrong"
    case RequestTimedOut = "RequestTimedOut"
}
class ErrorAlertController: UIViewController {

    //outlet collection
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var alertImageview: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    
    //variable and constant
    var retryPressed : (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func RetryButtonPressed(_ sender: UIButton)
    {
       hideChildController(content: self)
        retryPressed()
    }
   func setValues(errorType:ErrorCase,message:String)
    {
        retryButton.isHidden = false
        errorLabel.text=message
        switch errorType {
        case .NoDataAvailable:
            alertImageview.image = #imageLiteral(resourceName: "No_Data")
           retryButton.isHidden = true
            break
        case .NoInternetConnection:
            alertImageview.image = #imageLiteral(resourceName: "no-wifi")
            break
        case .SomethingWentWrong:
            alertImageview.image = #imageLiteral(resourceName: "warning")
            break
        default :
            alertImageview.image = #imageLiteral(resourceName: "warning")
             errorLabel.text=SERVICE_FAILURE_MESSAGE
        }
        alertImageview.image = alertImageview.image?.withRenderingMode(.alwaysTemplate)
    }

}
extension UIViewController
{
    func hideChildController(content: UIViewController)
    {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate
        {
            appdelegate.errorViewLoadedOnTableView.isScrollEnabled = true
        }
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    func loadErrorViewOn(subview:UIView ,forAlertType:ErrorCase ,errorMessage:String,retryButtonAction:@escaping(()->Void))
    {
        let errorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlertController") as! ErrorAlertController
        errorVC.view.frame=subview.bounds
        errorVC.modalTransitionStyle = .coverVertical
        removeErrorView()
        if let subview = subview as? UITableView
        {
            if let appdelegate = UIApplication.shared.delegate as? AppDelegate
            {
                appdelegate.errorViewLoadedOnTableView = subview
                subview.isScrollEnabled = false
            }
        }
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate
        {
            appdelegate.currentErrorView = errorVC
            appdelegate.isNodataAvilableActive = forAlertType == ErrorCase.NoDataAvailable
        }
        addChildViewController(errorVC)
        subview.addSubview(errorVC.view)
        errorVC.setValues(errorType:forAlertType,message:errorMessage)
        errorVC.retryPressed = retryButtonAction
        errorVC.didMove(toParentViewController: self)
    }
    func removeErrorView()
    {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate
        {
               appdelegate.errorViewLoadedOnTableView.isScrollEnabled = true
                hideChildController(content: appdelegate.currentErrorView)
        }
    }
    
}

