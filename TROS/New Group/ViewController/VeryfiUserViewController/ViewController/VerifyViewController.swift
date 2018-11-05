//
//  VerifyViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import AnimatedTextInput
import UserNotifications

class VerifyViewController: UIViewController {

  
    @IBOutlet var genderImageOutletCollection: [UIImageView]!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var mobileNoLabel: UITextField!
    @IBOutlet weak var emailID: UITextField!
    
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var otpView: UIStackView!
    @IBOutlet weak var enterOTPLabel: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        otpView.alpha = 0
        requestAuthorization { (successs) in
        }
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
           customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Provide Details", isBackBtnVisible: true, accessToOpenSlider: false, leftBarOptionToShow: .none)
    }

   
    @IBAction func SubmitButtenPressed(_ sender: UIButton)
    {
        let categoryVC = self.loadViewController(identifier: "ProductCategoriesVC") as! ProductCategoriesVC
        saveRecord(value: nameLabel.text!, forKey: "name")
        saveRecord(value: mobileNoLabel.text!, forKey: "mobileNo")
        let selectedGender = genderImageOutletCollection.filter{$0.image == #imageLiteral(resourceName: "selected")}
        let genderType = ["Male","Female","Transgender"][selectedGender[0].tag]
        saveRecord(value: genderType, forKey: "gender")
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @IBAction func getOtpPressed(_ sender: UIButton)
    {
        self.showLoaderWith(Msg: "sendimg OTP ..")
        AuthoriseManager.verifyMobile(dict: ["mobile"
            : mobileNoLabel.text ?? "","dialCode" : countryCode.text ?? "+91"]) { (response) in
            switch response
            {
            case .success(let resultMsg):
                self.dismissLoader()
                UIView.animate(withDuration: 1.0, animations: {
                self.otpView.alpha = 1
                self.enterOTPLabel.becomeFirstResponder()
                }, completion: { (sucess) in
                     self.showAlertFor(title: "Generate OTP", description: resultMsg)
                })
                
            case .failure(let error):
                self.dismissLoader()
                switch error {
                case .unknownError( _,_) :
                    self.showAlertFor(title: "Product List", description: NO_DATA_AVAILABLE_MSG)
                default:
                    self.showAlertFor(title: "Product List", description: SERVICE_FAILURE_MESSAGE)
                }
            }
            
        }
    }
    @IBAction func verifyOTPPressed(_ sender: UIButton)
    {
        self.showLoaderWith(Msg: "Verifing User...")
        AuthoriseManager.verifyUser(dict: ["mobile":mobileNoLabel.text ?? "","dialCode" : countryCode.text ?? "+91"]) { (response) in
            switch response
            {
            case .success(let isExistingUser):
                self.dismissLoader()
                self.showLoaderWith(Msg: "Verifing OTP...")
               let nameArr = (self.nameLabel.text ?? "").split(separator: " ")
               let firstName =  nameArr.first ?? ""
               let lastName = nameArr.count > 1 ? nameArr.last! : ""
                var dict = [String:Any]()
                if !isExistingUser
                {
                    dict = ["isNew":true,"otp":self.enterOTPLabel.text ?? "","contact":["mobile" : self.mobileNoLabel.text ?? "","dialCode":self.countryCode.text ?? ""],"firstName":firstName , "lastName": lastName,"displayName":firstName,"versionCode":"160000001"]
                }
                else
                {
                    dict = ["isNew":false,"otp":self.enterOTPLabel.text ?? "","contact":["mobile" : self.mobileNoLabel.text ?? "","dialCode":self.countryCode.text ?? ""],"versionCode":"160000001"]
                }
               AuthoriseManager.verifyOTP(dict: dict, completed: { (response) in
                switch response
                {
                case .success(let resultMsg):
                    self.dismissLoader()
                    print(resultMsg)
                    
                case .failure(let error):
                    self.dismissLoader()
                    switch error {
                    case .unknownError( _,_) :
                        self.showAlertFor(title: "Product List", description: NO_DATA_AVAILABLE_MSG)
                    default:
                        self.showAlertFor(title: "Product List", description: SERVICE_FAILURE_MESSAGE)
                    }
                }
                
               })
                
            case .failure(let error):
                self.dismissLoader()
                switch error {
                case .unknownError( _,_) :
                    self.showAlertFor(title: "Product List", description: NO_DATA_AVAILABLE_MSG)
                default:
                    self.showAlertFor(title: "Product List", description: SERVICE_FAILURE_MESSAGE)
                }
            }
            
        }
    }
   
    @IBAction func SelectGenderPressed(_ sender: UIButton)
    {
        for imageView in genderImageOutletCollection
        {
            imageView.image = imageView.tag == sender.tag ? #imageLiteral(resourceName: "selected") : #imageLiteral(resourceName: "radio_unselected")
        }
    }

}
extension VerifyViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
}
