//
//  OrderStatusCell.swift
//  TROS
//
//  Created by Swapnil Katkar on 29/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class OrderStatusCell: UITableViewCell {

    @IBOutlet weak var cancelOrderButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var orderSatus: UILabel!
    @IBOutlet weak var orederQuantity: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
