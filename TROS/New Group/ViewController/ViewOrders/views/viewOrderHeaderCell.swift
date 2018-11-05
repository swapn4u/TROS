//
//  viewOrderHeaderCell.swift
//  TROS
//
//  Created by Swapnil Katkar on 31/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class viewOrderHeaderCell: UITableViewCell {

    @IBOutlet weak var orderStausLabel: UILabel!
    @IBOutlet weak var OrderHolderView: UIView!
    @IBOutlet weak var providerNmae: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var totalProducts: UILabel!
    @IBOutlet weak var paymentMode: UILabel!
    @IBOutlet weak var cencelOrderButton: UIButton!
    @IBOutlet weak var ratingOrderView: FloatRatingView!
    @IBOutlet weak var shoeDetailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
