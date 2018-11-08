//
//  PromocodeVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 04/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
protocol getCashBackDelegate {
    func getCashback(discunt:Int)
}
class PromocodeVC: UIViewController {

    @IBOutlet weak var dicountLabel: UILabel!
    @IBOutlet weak var promoCodeTF: UITextField!
    var getCashBackDelegate : getCashBackDelegate?
    var promocode = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dicountLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
 
    @IBAction func ApplyPromocodePressed(_ sender: UIButton)
    {
        if !isInternetActive()
        {
            showAlertFor(title: "Promo Code", description: NO_INTERNET_CONNECTIVITY)
        }
        else
        {
            self.promoCodeTF.resignFirstResponder()
            if promoCodeTF.text == ""
            {
                showAlertFor(title: "Promo Code", description: "Please Enter Valid Promocode to Proceed .")
                return
            }
            PromocodeManager.getPromocodeFor(dict: ["promoCode":promoCodeTF.text!,"UserId":self.getUserInfo()?.user.id ?? ""], header: ["Content-Type":"application/json","authorization":self.getUserInfo()?.token ?? ""]) { (response) in
                switch response
                {
                case .success(let promocodeStatus):
                    self.dicountLabel.isHidden = false
                    self.promocode = promocodeStatus.discount
                    if self.promocode > 0
                    {
                        self.dicountLabel.textColor = UIColor.green
                        self.dicountLabel.text = "Congatulation !! You will get \(promocodeStatus.discount)% dicount on Current Price ."
                    }
                    else
                    {
                        self.dicountLabel.textColor = UIColor.red
                        self.dicountLabel.text = "Opps !! No promocode Applicable,try something new."
                    }
                    self.dismissLoader()
                    
                case .failure:
                    self.dicountLabel.textColor = UIColor.red
                    self.dicountLabel.text = "Opps ... \(SERVICE_FAILURE_MESSAGE)"
                    self.dicountLabel.isHidden = true
                    self.dismissLoader()
                }
            }
        }
    }
    @IBAction func dismissScreen(_ sender: UIButton)
    {
        self.dismiss(animated: true)
        if promocode > 0
        {
            getCashBackDelegate?.getCashback(discunt:promocode)
        }
    }
}
