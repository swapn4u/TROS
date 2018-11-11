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
    
    @IBOutlet weak var promocodeDiscountStatus: UILabel!
    @IBOutlet weak var promocodeHolder: UIView!
    @IBOutlet weak var promocodeAmount: UILabel!
    
    var OrderListArr = ["Parachute","Bathing Bar" , "Handwash Skin Care","Toothpaste","Eyeconic Kajal","Mouth Wash","Detol Handwash","Meswak Toothpaste","Mach 3","Shower Gel"]
    
    let razorpayTestKey =  "rzp_live_ILgsfZCZoFIKMb"//"rzp_test_eqYSar04b0Gimj"
    
    var productOrder = [ProductOrder(dict:[String:Any]())]
    var promoCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
     customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Place Order", isBackBtnVisible: true, accessToOpenSlider: true, leftBarOptionToShow: .none)
        placeOrderTableView.estimatedRowHeight = 80
        placeOrderTableView.rowHeight = UITableViewAutomaticDimension
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
    @IBAction func ApplyPromodePressed(_ sender: UIButton)
    {
        let promocodeVC = self.loadViewController(identifier:"PromocodeVC") as! PromocodeVC
        promocodeVC.getCashBackDelegate = self
        self.present(promocodeVC, animated: true)
    }
    @IBAction func ChangeAddressPressed(_ sender: UIButton)
    {
        let selectAddressVC = self.loadViewController(identifier: "SelectAddressVC") as! SelectAddressVC
        selectAddressVC.delegate = self
        self.navigationController?.pushViewController(selectAddressVC, animated: true)
    }
    @IBAction func PlaceOderPressed(_ sender: Any)
    {
        if !isInternetActive()
        {
            showAlertFor(title: "Place Order", description: NO_INTERNET_CONNECTIVITY)
        }
        else
        {
            for imageView in paymentOptionImageView
            {
                if imageView.tag == 1 && imageView.image == #imageLiteral(resourceName: "selected")
                {
                    let paymetAlert =  UIAlertController(title: "Payment Mode", message: "Do You Confirm to Pay On delivary", preferredStyle: .alert)
                    let OkAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
                        self.showLoaderWith(Msg: "Please wait while placing the order ...")
                        let dict = ["id":"","amount":"\(Double((self.estimatedPrice.text ?? "").replacingOccurrences(of:" ₹ : " , with: "")) ?? 0.0)","method":"cash","providerName":"tros"] as [String : Any]
                        PlaceOrderManager.getPaymentIdFor(dict: dict, header: ["Content-Type":"application/json","authorization":self.getUserInfo()?.token ?? ""], completed: { (result) in
                            switch result
                            {
                            case .success(let paymentInfo):
                                self.placeOrder(productId: paymentInfo.paymrntId)
                                
                            case .failure(let error):
                                self.dismissLoader()
                                switch error {
                                case .noInternetConnection :
                                    self.loadErrorViewOn(subview: self.view, forAlertType: .NoInternetConnection, errorMessage: NO_INTERNET_CONNECTIVITY, retryButtonAction: {
                                    })
                                case .noDataAvailable:
                                    self.loadErrorViewOn(subview: self.view, forAlertType: .NoDataAvailable, errorMessage: NO_DATA_AVAILABLE_MSG, retryButtonAction: {
                                    })
                                    
                                default:
                                    self.showAlertFor(title: "Product List", description: SERVICE_FAILURE_MESSAGE)
                                }
                            }
                        })
                        
                    }
                    let cancelAction = UIAlertAction(title: "No", style: .destructive)
                    
                    paymetAlert.addAction(OkAction)
                    paymetAlert.addAction(cancelAction)
                    self.present(paymetAlert, animated: true, completion: nil)
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
            //saveRecord()
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
        cell.productNameLabel.text = productOrder[indexPath.row].name.uppercased()
        cell.productBrand.text = productOrder[indexPath.row].brand.uppercased()
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
        totalItem.text = " \(productOrder.map{Int($0.totalProducts) ?? 0}.reduce(0, +))" 
        estimatedPrice.text = priceStruct?.totalCost ?? "-"
    }
}
extension PlaceOrderViewController : addressChangesProtocol
{
    func updateSelectedAdress(updateInfo: [String : Any]) {
        self.customerName.text = updateInfo["Name"] as? String ?? ""
        self.Address.text = updateInfo["address"] as? String ?? ""
        self.contactNameLabel.text = updateInfo["contactNo"] as? String ?? ""
        //saveRecord()
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
    
    func onPaymentSuccess(_ payment_id: String)
    {
        self.showLoaderWith(Msg: "Yay!..Your payment was successful...Redirecting to order place ..")
        placeOrder(productId: payment_id)
//        let alertController = UIAlertController(title: "Yay!", message: "Your payment was successful. The payment ID is \(payment_id)", preferredStyle: UIAlertControllerStyle.alert)
//        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    //for external payment
    func onExternalWalletSelected(_ wlletName: String, WithPaymentData paymentData: [AnyHashable : Any]?)
    {
        print(paymentData?.description ?? "no product discription found")
    }
    func placeOrder(productId:String)
    {
        let orderDetails = productOrder.map{element -> [String:Any] in
            let dict = ["cost":element.cost,"count":element.totalProducts,"imageUrl":element.imageURL,"productId":element.id,"productName":element.name,"quantity":element.quantity,"status":"1","unit":element.unit]
            return dict
        }
        
        let orderDict = ["payment":["method":"cash","paymentId":productId],"address":["line3":Address.text ?? "","line2":"","line1":"","loc":["19.1311563","72.8360014"],"type":"Point"],"items":orderDetails,"promoCode":promoCode] as [String : Any]
        
        PlaceOrderManager.placeOrderFor(dict: orderDict, header: ["Content-Type":"application/json","authorization":self.getUserInfo()?.token ?? ""], completed: { (result) in
            switch result
            {
            case .success(let placeOrderInfo):
                CoreDataManager.manager.saveOrderId(orderId: placeOrderInfo.orderID, complation: { (sucess) in
                    CoreDataManager.manager.deleteAllProductFromCart(completed: { (done) in
                        let actionSheetController: UIAlertController = UIAlertController(title: "Order Status", message: "Your Order placed successFully . ", preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: ProductCategoriesVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        actionSheetController.addAction(cancelAction)
                        self.present(actionSheetController, animated: true, completion: nil)
                    })
                    self.dismissLoader()
                })
               
            case .failure(let error):
                self.dismissLoader()
                switch error {
                case .noInternetConnection :
                    self.loadErrorViewOn(subview: self.view, forAlertType: .NoInternetConnection, errorMessage: NO_INTERNET_CONNECTIVITY, retryButtonAction: {
                    })
                case .noDataAvailable:
                    self.loadErrorViewOn(subview: self.view, forAlertType: .NoDataAvailable, errorMessage: NO_DATA_AVAILABLE_MSG, retryButtonAction: {
                    })
                    
                default:
                    self.showAlertFor(title: "Product List", description: SERVICE_FAILURE_MESSAGE)
                }
            }
        })
    }
    
}
extension PlaceOrderViewController : getCashBackDelegate
{
    func getCashback(discunt: Int, promocode: String) {
        if discunt>0
        {
            UIView.animate(withDuration: 0.3) {
                self.promoCode = promocode
                self.promocodeHolder.isHidden=false
                self.promocodeDiscountStatus.text = "PromoCode(\(discunt)% OFF)"
                let dicountPrice = String(format: "%.2f",(Double(self.totalCost.text!.replacingOccurrences(of: " ₹ : ", with: ""))! * Double(discunt) / 100.0))
                self.promocodeAmount.text = "-₹ : \(dicountPrice)"
                self.estimatedPrice.text = " ₹ : " + String(format: "%.2f",Double(self.estimatedPrice.text!.replacingOccurrences(of: " ₹ : ", with: ""))! - Double(dicountPrice)!)
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            UIView.animate(withDuration: 0.3)
            {
                self.promoCode = ""
                self.promocodeHolder.isHidden=true
                self.estimatedPrice.text = "\(self.productOrder.last?.totalCost ?? "-")"
            }
        }
    }
}

