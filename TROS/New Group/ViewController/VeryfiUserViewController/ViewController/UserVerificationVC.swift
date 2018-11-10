//
//  UserVerificationVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 31/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class UserVerificationVC: UIViewController {

    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var countryCode: UITextField!
    
    @IBOutlet weak var OTPView: UIStackView!
    @IBOutlet weak var enterOTPLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Verify User", isBackBtnVisible: true, accessToOpenSlider: false, leftBarOptionToShow: .none)
      self.OTPView.alpha = 0
    }
    @IBAction func getOTPPressed(_ sender: Any)
    {
        if !CommonUtlity.sharedInstance.isInternetAvailable()
        {
            showAlertFor(title: "Verify User", description: NO_INTERNET_CONNECTIVITY)
            return
        }
        else
        {
            self.showLoaderWith(Msg: "sending OTP ..")
            AuthoriseManager.verifyMobile(dict: ["mobile"
                : mobileNoTF.text ?? "","dialCode" : countryCode.text ?? "+91"]) { (response) in
                    switch response
                    {
                    case .success(let resultMsg):
                        self.dismissLoader()
                        UIView.animate(withDuration: 1.0, animations: {
                            self.OTPView.alpha = 1
                            self.enterOTPLabel.becomeFirstResponder()
                        }, completion: { (sucess) in
                            self.showAlertFor(title: "Generate OTP", description: resultMsg)
                        })
                        
                    case .failure(let error):
                        self.dismissLoader()
                        switch error {
                        case .unknownError( _,_) :
                            self.showAlertFor(title: "Verify User", description: NO_DATA_AVAILABLE_MSG)
                        default:
                            self.showAlertFor(title: "Verify User", description: SERVICE_FAILURE_MESSAGE)
                        }
                    }
            }
        }
    }
    
    @IBAction func VerifiNumberPressed(_ sender: UIButton)
    {
        if !CommonUtlity.sharedInstance.isInternetAvailable()
        {
            showAlertFor(title: "Verification", description: NO_INTERNET_CONNECTIVITY)
            return
        }
        else
        {
            self.showLoaderWith(Msg: "Verifing User...")
            AuthoriseManager.verifyUser(dict: ["mobile":mobileNoTF.text ?? "","dialCode" : countryCode.text ?? "+91"]) { (response) in
                switch response
                {
                case .success(let isExistingUser):
                    self.dismissLoader()
                    self.showLoaderWith(Msg: "Verifing OTP...")
                   
                    if !isExistingUser
                    {
                                let VerifylVC = self.loadViewController(identifier: "VerifyViewController") as! VerifyViewController
                                self.navigationController?.pushViewController(VerifylVC, animated: true)
                    }
                    else
                    {
                        let dict = ["isNew":false,"otp":self.enterOTPLabel.text ?? "","contact":["mobile" : self.mobileNoTF.text ?? "","dialCode":self.countryCode.text ?? ""],"versionCode":"160000001"] as [String : Any]
                 
                    AuthoriseManager.verifyOTP(dict: dict, completed: { (response) in
                        switch response
                        {
                        case .success(let resultMsg):
                            self.dismissLoader()
                             print(resultMsg)
                            if resultMsg == "verified"
                            {
                                let categoryVC = self.loadViewController(identifier: "ProductCategoriesVC") as! ProductCategoriesVC
                                let userName = (self.getUserInfo()?.user.firstName)! + " " + (self.getUserInfo()?.user.middleName)! + " " + (self.getUserInfo()?.user.lastName)!
                                self.saveRecord(value: userName, forKey: "name")
                                self.saveRecord(value: self.mobileNoTF.text!, forKey: "mobileNo")
                                self.saveRecord(value: "Male", forKey: "gender")
                                self.navigationController?.pushViewController(categoryVC, animated: true)
                            }
                            else
                            {
                                self.showAlertFor(title: "Verification", description: resultMsg)
                            }
                           
                            
                        case .failure(let error):
                            self.dismissLoader()
                            switch error {
                            case .unknownError( _,_) :
                                self.showAlertFor(title: "Verification", description: NO_DATA_AVAILABLE_MSG)
                            default:
                                self.showAlertFor(title: "Verification", description: SERVICE_FAILURE_MESSAGE)
                            }
                        }
                        
                    })
                    }
                    
                case .failure(let error):
                    self.dismissLoader()
                    switch error {
                    case .unknownError( _,_) :
                        self.showAlertFor(title: "Verification", description: NO_DATA_AVAILABLE_MSG)
                    default:
                        self.showAlertFor(title: "Verification", description: SERVICE_FAILURE_MESSAGE)
                    }
                }
            }
            
        }
    }
}
