//
//  CreateAddressVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 29/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
protocol updateNewAddressDelegate
{
    func addNewAddress(updateInfo:[String:String],isFromUpdate:Bool)
}
struct SavedAddresses
{
    var name : String
    var address : String
    var contactNo : String
    init(dict:[String:Any]) {
        self.name = dict["name"] as? String ?? ""
        self.address = dict["address"] as? String ?? ""
        self.contactNo = dict["contactNo"] as? String ?? ""
    }
    
}
class CreateAddressVC: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var contactNoTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var areaTF: UITextField!
    @IBOutlet weak var buildingAddressTF: UITextField!
    @IBOutlet weak var pincodeTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    
    var editData = [String]()
    var isFromUpdate = false
    var delegate : updateNewAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Add Address", isBackBtnVisible: true, accessToOpenSlider: false, leftBarOptionToShow: .none)
        if !editData.isEmpty
        {
            nameTF.text = editData[0]
            contactNoTF.text = editData[1]
            cityTF.text = editData[2]
            areaTF.text = editData[3]
            buildingAddressTF.text = editData[4]
            pincodeTF.text = editData[5]
            stateTF.text = editData[6]
        }
    }

    @IBAction func addAddressPressed(_ sender: UIButton)
    {
        
      let address = "\(buildingAddressTF.text!),*\(areaTF.text!),*\(cityTF.text!),*\(stateTF.text!),*\(pincodeTF.text!)"
        let updateInfo = ["Name":nameTF.text! ,"address":address, "contactNo":contactNoTF.text!]
        delegate?.addNewAddress(updateInfo: updateInfo,isFromUpdate: isFromUpdate)
        self.navigationController?.popViewController(animated: true)
    }
}
