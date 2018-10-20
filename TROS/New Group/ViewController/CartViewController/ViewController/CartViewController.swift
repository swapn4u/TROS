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
    var noOfItem : String
    var imageURL : String
    var brand : String
    var totalProducts : String
    var totalCost : String
    var isAdding = true
    init(dict:[String:Any]) {
        self.name = dict["name"] as? String ?? ""
        self.cost = dict["cost"] as? String ?? "0.0"
        self.noOfItem = dict["noOfItem"] as? String ?? ""
        self.imageURL = dict["imageURL"] as? String ?? ""
        self.brand = dict["brand"] as? String ?? ""
        self.totalProducts = dict["totalProducts"] as? String ?? "1"
        self.totalCost = dict["totalCost"] as? String ?? ""
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
    
    //Variables and constance
    var isFromMenuSelection = false
    var cartRecords = [CartData]()
    var updatedCartRecord = [ProductOrder]()
    var originalCartRecords = [ProductOrder]()

   //view  life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let cartRecords = CoreDataManager.manager.fetch()
        {
            self.cartRecords = cartRecords
            updatedCartRecord =  cartRecords.map { (element) -> ProductOrder in
                let dict = ["name":element.name ?? "","cost":element.cost ?? "" ,"noOfItem":"1","imageURL":element.imageUrl ?? "","brand": element.brand ?? "","totalCost":self.grandTotalLabel.text ?? "","totalProducts": "0"]
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
//        var productOrderArr = [[String:Any]]()
//        var totalCount = 0
        
       let updatedCartRecords =  originalCartRecords.map { (element) -> ProductOrder in
            let dict = ["name":element.name,"cost":element.cost ,"noOfItem":element.noOfItem,"imageURL":element.imageURL,"brand": element.brand,"totalCost":self.grandTotalLabel.text ?? "0.0","totalProducts": element.totalProducts]
            return ProductOrder(dict: dict)
        }
      // let placeOrder = productOrderArr.compactMap{ProductOrder(dict: $0)}
        orderVC.productOrder = updatedCartRecords
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
}
extension CartViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return originalCartRecords.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.productImage.sd_setImage(with: URL(string: originalCartRecords[indexPath.row].imageURL ), placeholderImage: UIImage(named: PlaceholderImage))
        cell.productName.text = originalCartRecords[indexPath.row].name
        cell.amountLabel.text = " ₹ : \(Double(originalCartRecords[indexPath.row].cost) ?? 0.0)"
        cell.deleteProductButton.tag = indexPath.row
        cell.currentPrice = Double(updatedCartRecord[indexPath.row].cost) ?? 0.0
        cell.deleteProductButton.addTarget(self, action: #selector(deleteProduct(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
}
extension CartViewController : showGrandTotalProtocol
{
    func updateTotal(cell:UITableViewCell,tag:Int)
    {
          var total = 0.0
            if let cell = cell as? CartCell
            {
                let cellvalue = originalCartRecords[cell.tag].cost
                if tag == 0
                {
                    total = (Double(cellvalue) ?? 0.0) -  cell.currentPrice
                    total = total == 0 ? cell.currentPrice : total
                }
                else
                {
                   total = cell.currentPrice *  Double(cell.initialCount)
                }
                var updateValue = originalCartRecords[cell.tag]
                updateValue.cost = "\(total)"
                updateValue.totalProducts = cell.totalItemLabel.text ?? "1"
                originalCartRecords[cell.tag] = updateValue
                cell.amountLabel.text = " ₹ : \(total)"
                cartTable.reloadData()
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
