//
//  CartViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

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
    var tapCount = 0
    var cardInfoCount : Int!{didSet{
        cartTable.reloadData()
        }}
    var isFromMenuSelection = false
    
    var cartRecords = [CartData](){
        didSet{cartTable.reloadData()
        }}
    var cartListArr = ["Parachute","Bathing Bar" , "Handwash Skin Care","Toothpaste","Eyeconic Kajal","Mouth Wash","Detol Handwash","Meswak Toothpaste","Mach 3","Shower Gel"]
   //view  life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         cardInfoCount = 6
        
        if let cartRecords = CoreDataManager.manager.fetch()
        {
            self.cartRecords = cartRecords
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Your Cart", isBackBtnVisible: isFromMenuSelection ? false : true, accessToOpenSlider: true, leftBarOptionToShow: .none)
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
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
}
extension CartViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartRecords.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.productImage.sd_setImage(with: URL(string: cartRecords[indexPath.row].imageUrl ?? ""), placeholderImage: UIImage(named: PlaceholderImage))
        cell.productName.text = cartRecords[indexPath.row].name ?? ""
        cell.amountLabel.text = " ₹ : \(cartRecords[indexPath.row].cost ?? "")"
        cell.deleteProductButton.tag = indexPath.row
        cell.deleteProductButton.addTarget(self, action: #selector(deleteProduct(sender:)), for: .touchUpInside)
        
//        if indexPath.row == 2
//        {
//            cell.offerImageView.image = #imageLiteral(resourceName: "layesOffer")
//            cell.comboDecLabel.text = "Layes Potto chips + Listerine Mouth Wash"
//        }
//        if indexPath.row == 4
//        {
//            cell.offerImageView.image = #imageLiteral(resourceName: "GilateOffer")
//             cell.comboDecLabel.text = "Gillate Shave Foam + Listerine Mouth Wash"
//        }
      // updateTotal(cell: cell)
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
            if let cell = cell as? CartCell
            {
                let cellvalue = cell.amountLabel.text!.replacingOccurrences(of: " ₹ : ", with: "").trimmingCharacters(in: .whitespaces)
                var total = 0.0
                if tag == 0
                {
                    total = (Double(cellvalue) ?? 0.0) /  cell.currentPrice
                    total = total == 1 ? (Double(cellvalue) ?? 0.0) : total
                }
                else
                {
                   total = cell.currentPrice *  Double(cell.initialCount)
                }
                cell.amountLabel.text = " ₹ : \(total)"
                //grandTotal += Double(cellvalue) ?? 0.0
            }
       // grandTotalLabel.text = " ₹ : \(grandTotal)"
    }
    @objc func deleteProduct(sender:UIButton)
    {
        showLoaderWith(Msg: "deleting Product ...")
        CoreDataManager.manager.deleteProductFromCart(id: self.cartRecords[sender.tag].id ?? "") { (isSucess) in
            self.dismissLoader()
            if isSucess
            {
                if let cartRecords = CoreDataManager.manager.fetch()
                {
                    self.cartRecords = cartRecords
                }
                self.showAlertFor(title: "Add to Cart", description: "Product deleted succesfully from cart")
            }
        }
    }
    
    
}
