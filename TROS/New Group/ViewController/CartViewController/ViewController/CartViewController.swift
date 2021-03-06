//
//  CartViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

struct ProductOrder
{
    var name : String
    var cost : String
    var actualCost : String
    var noOfItem : String
    var imageURL : String
    var brand : String
    var totalProducts : String
    var totalCost : String
    var id : String
    var unit : String
    var quantity : String
    init(dict:[String:Any]) {
        self.name = dict["name"] as? String ?? ""
        self.actualCost = dict["actualCost"] as? String ?? ""
        self.cost = dict["cost"] as? String ?? "0.0"
        self.noOfItem = dict["noOfItem"] as? String ?? "1"
        self.imageURL = dict["imageURL"] as? String ?? ""
        self.brand = dict["brand"] as? String ?? ""
        self.totalProducts = dict["totalProducts"] as? String ?? "1"
        self.totalCost = dict["totalCost"] as? String ?? ""
        self.id = dict["id"] as? String ?? ""
        self.unit = dict["unit"] as? String ?? ""
        self.quantity = dict["quantity"] as? String ?? "0"
    }
    
}
class CartViewController: UIViewController {

    //outlet collections
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var orderDetailsVIew: UIView!
    @IBOutlet weak var placeOrderDetailsBackGround: UIView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var OfferrImageView: UIImageView!
    @IBOutlet weak var checkOutnt: UIButton!
    
    //Variables and constance
    var isFromMenuSelection = false
    var cartRecords = [CartData]()
    var updatedCartRecord = [ProductOrder]()
    var originalCartRecords = [ProductOrder]()
    var isQuantityEditable = false

   //view  life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTable.estimatedRowHeight = 113
        cartTable.rowHeight = UITableViewAutomaticDimension
        if let cartRecords = CoreDataManager.manager.fetch()
        {
            self.cartRecords = cartRecords
            updatedCartRecord =  cartRecords.map { (element) -> ProductOrder in
                let dict = ["name":element.name ?? "","cost":element.cost ?? "" ,"actualCost" : element.cost!,"noOfItem":"1","imageURL":element.imageUrl ?? "","brand": element.brand ?? "","totalCost":self.grandTotalLabel.text ?? "","totalProducts": "1","id":element.id ?? "","unit":element.unit ?? "","quantity":element.quantity ?? ""]
                return ProductOrder(dict: dict)
            }
            originalCartRecords = updatedCartRecord
            cartTable.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Your Cart", isBackBtnVisible: isFromMenuSelection ? false : true, accessToOpenSlider: true, leftBarOptionToShow: .none)
        DispatchQueue.main.async {
            self.calculateGrandTotal()
        }
    }
}
//handle actions
extension CartViewController
{
    @IBAction func hideDetailsSummery(_ sender: UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 0.5, animations:
            {
                self.proceedButton.setTitle("Checkout", for: .normal)
                self.placeOrderDetailsBackGround.isHidden = true
                self.orderDetailsVIew.transform = .identity
        })
    }
    
    @IBAction func PlaceOrderPressed(_ sender: UIButton)
    {
        let orderVC = self.loadViewController(identifier: "PlaceOrderViewController") as! PlaceOrderViewController
        let totalPrice = Double(originalCartRecords.map{Double($0.cost) ?? 0.0}.reduce(0, +)) 
       let updatedCartRecords =  originalCartRecords.map { (element) -> ProductOrder in
        let dict = ["name":element.name,"cost":element.cost ,"noOfItem":element.noOfItem,"imageURL":element.imageURL,"brand": element.brand,"totalCost": " ₹ : " + String(format: "%.2f", totalPrice)  ,"totalProducts": element.totalProducts,"unit":element.unit,"id":element.id,"quantity":element.quantity]
            return ProductOrder(dict: dict)
        }
        orderVC.productOrder = updatedCartRecords
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
}
extension CartViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if originalCartRecords.isEmpty
        {
            loadErrorViewOn(subview: self.view, forAlertType: .NoDataAvailable, errorMessage: "Oops ...your cart is Empty") {}
             return 0
        }
        else
        {
          return originalCartRecords.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.productImage.sd_setImage(with: URL(string: originalCartRecords[indexPath.row].imageURL ), placeholderImage: UIImage(named: PlaceholderImage))
        cell.productName.text = originalCartRecords[indexPath.row].name.uppercased()
        cell.sellerLabel.text = "Brand : " + originalCartRecords[indexPath.row].brand.uppercased()
        cell.amountLabel.text = " ₹ : \(Double(originalCartRecords[indexPath.row].cost) ?? 0.0)"
        cell.deleteProductButton.tag = indexPath.row
        cell.totalItemLabel.text = originalCartRecords[indexPath.row].totalProducts
        cell.currentPrice = Double(updatedCartRecord[indexPath.row].cost) ?? 0.0
        cell.deleteProductButton.addTarget(self, action: #selector(deleteProduct(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if !isQuantityEditable
        {
            cell.alpha = 0
            UIView.animate(withDuration: 0.5, delay:0.2, options: [.curveEaseIn], animations: {
                cell.alpha = 1
            }, completion: nil)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isQuantityEditable = false
    }
}
extension CartViewController : showGrandTotalProtocol
{
    func updateTotal(cell:UITableViewCell,tag:Int)
    {
        isQuantityEditable = true
          var total = 0.0
            if let cell = cell as? CartCell
            {
                var updateValue = originalCartRecords[cell.tag]
                var totalOrder = Int(updateValue.totalProducts)!
                totalOrder = tag == 0 ? totalOrder == 1 ? 1 : totalOrder - 1 : totalOrder + 1
                updateValue.totalProducts = "\(totalOrder)"
                let cellvalue = updateValue.cost
                if tag == 0
                {
                    total = (Double(cellvalue) ?? 0.0) -  Double(updateValue.actualCost)! 
                    total = total == 0 ? cell.currentPrice : total
                }
                else
                {
                    total = Double(updateValue.actualCost )! *  Double(updateValue.totalProducts)!
                }
                updateValue.cost = "\(total)"
                originalCartRecords[cell.tag] = updateValue
                cell.amountLabel.text = " ₹ : \(total)"
                cartTable.reloadRows(at: [IndexPath(row: cell
                    .tag, section: 0)], with: .none)
                calculateGrandTotal()
            }
    }
    func calculateGrandTotal()
    {
        let grandTotals = originalCartRecords.map{Double($0.cost) ?? 0.0}.reduce(0, +)
        grandTotalLabel.text = " ₹ : \(grandTotals)"
    }
    @objc func deleteProduct(sender:UIButton)
    {
        showLoaderWith(Msg: "deleting Product ...")
        CoreDataManager.manager.deleteProductFromCart(id: self.cartRecords[sender.tag].id ?? "") { (isSucess) in
            self.dismissLoader()
            if isSucess
            {
                self.originalCartRecords.remove(at:sender.tag)
                self.cartTable.reloadData()
                self.calculateGrandTotal()
                self.showAlertFor(title: "Add to Cart", description: "Product deleted succesfully from cart")
            }
        }
    }
    
    
}
