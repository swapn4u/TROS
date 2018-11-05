//
//  ViewOrderProductDetailsVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 02/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ViewOrderProductDetailsVC: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    var orderDetails = PlaceOrderStatus(dict: [String:Any]())
    override func viewDidLoad() {
        super.viewDidLoad()
    customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Your Ordered Products", isBackBtnVisible: true, accessToOpenSlider: false, leftBarOptionToShow: .none)
        // Do any additional setup after loading the view.
    }

}
extension ViewOrderProductDetailsVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetails.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusCell") as! OrderStatusCell
                let productDetails = orderDetails.items[indexPath.row]
                cell.productName.text = productDetails.productName
               // cell.brandName.text = productDetails.vendorName
                cell.totalPrice.text = "\(productDetails.cost)"
                cell.productImage.sd_setImage(with: URL(string: productDetails.imageUrl), placeholderImage: UIImage(named: PlaceholderImage))
                cell.orederQuantity.text = "\(productDetails.count)"
               // cell.orderSatus.text = productDetails.history.last?.eventMessage ?? ""
                return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}
