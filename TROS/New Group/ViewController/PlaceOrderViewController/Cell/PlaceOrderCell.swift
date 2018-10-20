//
//  PlaceOrderCell.swift
//  TROS
//
//  Created by Swapnil Katkar on 23/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class PlaceOrderCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var noOfOrder: UILabel!
    @IBOutlet weak var productCost: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
