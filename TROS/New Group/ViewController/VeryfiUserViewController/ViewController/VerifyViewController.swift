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
        let categoryVC = self.loadViewController(identifier: "ProductCategoryVC") as! ProductCategoryVC
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
        AuthoriseManager.verifyMobile(mobileNo: mobileNoLabel.text ?? "") { (response) in
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
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result.characters).count < 4
        return result
    }
}
