//
//  ViewOrdersVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 29/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ViewOrdersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var placeOrderStatus = [PlaceOrderStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "viewOrderHeaderCell", bundle: nil), forCellReuseIdentifier: "viewOrderHeaderCell")
        getOrderDetails()
        tableView.estimatedRowHeight = 246
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Your Order", isBackBtnVisible: false, accessToOpenSlider: true, leftBarOptionToShow: .none)
  }
}
extension ViewOrdersVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeOrderStatus.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewOrderHeaderCell") as! viewOrderHeaderCell
         let productDetails = placeOrderStatus[indexPath.row]
         cell.providerNmae.text = productDetails.items.last?.vendorName ?? ""
        cell.deliveryAddress.text = productDetails.address.line1 + productDetails.address.line2 + productDetails.address.line3
        cell.totalProducts.text = "\(productDetails.items.count)"
        cell.paymentMode.text = productDetails.payment.method == "cash" ? "Cash on Delivery" : "Online Paid"
        cell.orderStausLabel.text = productDetails.items.last?.history.last?.eventMessage.capitalized ?? ""
        cell.ratingOrderView.delegate = self
        cell.ratingOrderView.tag = indexPath.row
        cell.ratingOrderView.type = .halfRatings
        cell.ratingOrderView.rating = productDetails.rating
        cell.totalAmount.text = "₹ : \(productDetails.items.map{$0.cost}.reduce(0, +))"
        if productDetails.items.last!.status == 5 || productDetails.items.last!.status == 6
        {
           cell.cencelOrderButton.isHidden = true
        }
        else
        {
            cell.cencelOrderButton.isHidden = false
            cell.cencelOrderButton.tag = indexPath.row
            cell.cencelOrderButton.addTarget(self, action: #selector(cancelOrderForId(btn:)), for: .touchUpInside)
          
        }
        cell.shoeDetailsButton.tag = indexPath.row
        cell.shoeDetailsButton.addTarget(self, action: #selector(showProducts(btn:)), for: .touchUpInside)
        cell.layer.cornerRadius = 4
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension ViewOrdersVC
{
    @objc func cancelOrderForId(btn:UIButton)
    {
        let cancelOrderId =  placeOrderStatus[btn.tag].orderID 
        ViewOrederManager.canceOrderInfoFor(orderId:cancelOrderId , header: ["Content-Type":"application/json","authorization":self.getUserInfo()?.token ?? ""]) { (response) in
            switch response
            {
            case .success(let productList):
                self.placeOrderStatus[btn.tag] = productList
                self.tableView.reloadData()
                if self.placeOrderStatus.isEmpty
                {
                    self.loadErrorViewOn(subview: self.view, forAlertType: .NoDataAvailable, errorMessage: NO_PRODUCT_OREDER_MSG, retryButtonAction: {
                    })
                }
                self.dismissLoader()
                
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
        }
    }
    @objc func showProducts(btn:UIButton)
    {
        let showOrderDeatailVC = self.loadViewController(identifier: "ViewOrderProductDetailsVC") as! ViewOrderProductDetailsVC
        showOrderDeatailVC.orderDetails = self.placeOrderStatus[btn.tag]
        self.navigationController?.pushViewController(showOrderDeatailVC, animated: true)
    }
}

extension ViewOrdersVC : FloatRatingViewDelegate
{
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        print(String(format: "%.2f", ratingView.rating))
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let orderId = placeOrderStatus[ratingView.tag].orderID
        ViewOrederManager.rateOrderInfoFor(orderId: orderId,dict: ["rating":String(format: "%.2f", ratingView.rating)], header: ["Content-Type":"application/json","authorization":self.getUserInfo()?.token ?? ""]) { (result) in
            print(result)
        }
        
    }
    func getOrderDetails()
    {
        if !CommonUtlity.sharedInstance.isInternetAvailable()
        {
            self.loadErrorViewOn(subview: self.view, forAlertType: .NoInternetConnection, errorMessage: NO_INTERNET_CONNECTIVITY, retryButtonAction: {
                self.getOrderDetails()
            })
        }
        else
        {
            if let orderidArrRecords = CoreDataManager.manager.fetchOrderId()
            {
                if orderidArrRecords.isEmpty
                {
                    self.loadErrorViewOn(subview: self.view, forAlertType: .NoDataAvailable, errorMessage: NO_PRODUCT_OREDER_MSG, retryButtonAction: {
                    })
                }
                else
                {
                    for orders in orderidArrRecords
                    {
                        self.showLoaderWith(Msg: "Please wait ...")
                        ViewOrederManager.getOrderInfoFor(orderId: orders.orderId!) { response in
                            switch response
                            {
                            case .success(let productList):
                                self.placeOrderStatus.append(productList)
                                self.tableView.reloadData()
                                if self.placeOrderStatus.isEmpty
                                {
                                    self.loadErrorViewOn(subview: self.view, forAlertType: .NoDataAvailable, errorMessage: NO_PRODUCT_OREDER_MSG, retryButtonAction: {
                                    })
                                }
                                self.dismissLoader()
                                
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
                                    self.loadErrorViewOn(subview: self.view, forAlertType: .SomethingWentWrong, errorMessage: SERVICE_FAILURE_MESSAGE, retryButtonAction: {
                                        self.getOrderDetails()
                                    })
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
