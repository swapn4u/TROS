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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.otpView.isHidden = true
        otpView.alpha = 0
        requestAuthorization { (successs) in
        
        }
        UNUserNotificationCenter.current().delegate = self
     
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
        UIView.animate(withDuration: 1.0, animations: {
             self.otpView.alpha = 1
        }) { (completed) in
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                switch notificationSettings.authorizationStatus {
                case .notDetermined:
                    self.requestAuthorization(completionHandler: { (success) in
                        guard success else { return }
                        
                        // Schedule Local Notification
                        self.scheduleLocalNotification()
                    })
                case .authorized:
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                case .denied:
                    print("Application Not Allowed to Display Notifications")
                }
            }
        }
    }
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "TROS"
        let password = fourDigitNumber
        notificationContent.subtitle = "Your TROP Registrastion OTP is : \(password) "
        notificationContent.body = ""
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 6.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
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
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result.characters).count < 4
        return result
    }
}
