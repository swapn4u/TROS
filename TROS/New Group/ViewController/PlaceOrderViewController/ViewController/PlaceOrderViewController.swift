//
//  PlaceOrderViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 23/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Razorpay
class PlaceOrderViewController: UIViewController {
    var razorpay: Razorpay!
    @IBOutlet var paymentOptionImageView: [UIImageView]!
    
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var tableHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var placeOrderTableView: UITableView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var editAddressContainerView: UIView!
    @IBOutlet weak var addressEditVIew: UIView!
    
    
    @IBOutlet weak var delivaryCharge: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var totalItem: UILabel!
    @IBOutlet weak var editContactNoTF: UITextField!
    @IBOutlet weak var editAdressTF: UITextView!
    @IBOutlet weak var editNameTF: UITextField!
    @IBOutlet weak var estimatedPrice: UILabel!
    
    var OrderListArr = ["Parachute","Bathing Bar" , "Handwash Skin Care","Toothpaste","Eyeconic Kajal","Mouth Wash","Detol Handwash","Meswak Toothpaste","Mach 3","Shower Gel"]
    
    let razorpayTestKey =  "rzp_live_ILgsfZCZoFIKMb"//"rzp_test_eqYSar04b0Gimj"
    
    var  productOrder = [ProductOrder(dict:[String:Any]())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Place Order", isBackBtnVisible: true, accessToOpenSlider: true, leftBarOptionToShow: .none)
        
        customerName.text = getValueFor(key: "name")
        contactNameLabel.text = getValueFor(key: "mobileNo")
        Address.text = getValueFor(key: "address")
        
        razorpay = Razorpay.initWithKey(razorpayTestKey, andDelegate: self)
        razorpay.setExternalWalletSelectionDelegate(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        calculateTableHeight()
    }
    @IBAction func selcetPaymentMode(_ sender: UIButton)
    {
        for imageView in paymentOptionImageView
        {
            imageView.image = imageView.tag == sender.tag ? #imageLiteral(resourceName: "selected") : #imageLiteral(resourceName: "radio_unselected")
        }
    }
    @IBAction func ChangeAddressPressed(_ sender: UIButton)
    {
        let selectAddressVC = self.loadViewController(identifier: "SelectAddressVC") as! SelectAddressVC
        selectAddressVC.delegate = self
        self.navigationController?.pushViewController(selectAddressVC, animated: true)
    }
    @IBAction func PlaceOderPressed(_ sender: Any)
    {
        for imageView in paymentOptionImageView
        {
            if imageView.tag == 1 && imageView.image == #imageLiteral(resourceName: "selected")
            {
                showAlertFor(title: "Your order is placed", description: "it will be delivered soon ..")
            }
            else if imageView.tag == 1 && imageView.image == #imageLiteral(resourceName: "radio_unselected")
            {
                let image = #imageLiteral(resourceName: "trosIcon")
                let amount = (Double((estimatedPrice.text ?? "").replacingOccurrences(of:" ₹ : " , with: "")) ?? 0.0) * 100.0
                let options: [String:Any] = [
                    "amount" :  amount,
                    "description": "purchase products",
                    "currency" : "INR",
                    // "external" : ["wallets" : ["paytm" ]],
                    "image": image ,
                    "name": "TROS",
                    "prefill": [
                        "contact": "8007415573",
                        "email": "swapnilkatkar1992@gmail.com"
                    ],
                    "theme": [
                        "color": "#800000"
                    ]
                ]
                razorpay.open(options)
                
            }
        }
       
    }
    @IBAction func editAddressPressed(_ sender: UIButton)
    {
        
        if sender.tag == 0
        {
            self.editNameTF.text = self.customerName.text
            self.editAdressTF.text = self.Address.text
            self.editContactNoTF.text = self.contactNameLabel.text
        }
        else
        {
            self.customerName.text = self.editNameTF.text
            self.Address.text = self.editAdressTF.text
            self.contactNameLabel.text = self.editContactNoTF.text
            saveRecord()
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.editAddressContainerView.isHidden = !self.editAddressContainerView.isHidden
        }) { (succes) in
            UIView.animate(withDuration:1.0 , delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations:
                {
                    
                    if self.addressEditVIew.transform == .identity
                    {
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                        let viewHeight = (self.editAddressContainerView.frame.size.height/2) - (self.addressEditVIew.frame.size.height/2)
                        self.addressEditVIew.transform = CGAffineTransform(translationX: 0, y: viewHeight)
                    }
                    else
                    {
                        self.navigationController?.setNavigationBarHidden(false, animated: true) 
                        self.addressEditVIew.transform = .identity
                    }
            }) { (completed) in
                
            }
        }
    }
}
extension PlaceOrderViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productOrder.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceOrderCell") as! PlaceOrderCell
        cell.productImageView.sd_setImage(with: URL(string: productOrder[indexPath.row].imageURL), placeholderImage: UIImage(named: PlaceholderImage))
        cell.productNameLabel.text = productOrder[indexPath.row].name
        cell.productBrand.text = productOrder[indexPath.row].brand
        cell.productCost.text = "₹ : \(Double(productOrder[indexPath.row].cost) ?? 0.0)"
        cell.noOfOrder.text = productOrder[indexPath.row].totalProducts
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
    func calculateTableHeight() {
        tableHeightConstraints.constant = CGFloat(productOrder.count * 94)
        let priceStruct = productOrder.last
        totalCost.text = priceStruct?.totalCost ?? "-"
        totalItem.text = priceStruct?.totalProducts ?? "-"
        estimatedPrice.text = priceStruct?.totalCost ?? "-"
    }
}
extension PlaceOrderViewController : addressChangesProtocol
{
    func updateSelectedAdress(updateInfo: [String : Any]) {
        self.customerName.text = updateInfo["Name"] as? String ?? ""
        self.Address.text = updateInfo["address"] as? String ?? ""
        self.contactNameLabel.text = updateInfo["contactNo"] as? String ?? ""
        saveRecord()
    }
    func saveRecord()
    {
        saveRecord(value:customerName.text! , forKey: "name")
        saveRecord(value:contactNameLabel.text! , forKey: "mobileNo")
        saveRecord(value:Address.text! , forKey: "address")
    }
    
    
}
extension PlaceOrderViewController : RazorpayPaymentCompletionProtocol , ExternalWalletSelectionProtocol
{
    func onPaymentError(_ code: Int32, description str: String)
    {
        let alertController = UIAlertController(title: "Uh-Oh!", message: "Your payment failed due to an error : \(str) " , preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        let alertController = UIAlertController(title: "Yay!", message: "Your payment was successful. The payment ID is \(payment_id)", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    //for external payment
    func onExternalWalletSelected(_ wlletName: String, WithPaymentData paymentData: [AnyHashable : Any]?)
    {
        print(paymentData?.description ?? "no product discription found")
    }
    
}

