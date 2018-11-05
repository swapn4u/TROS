//
//  CategoryProductCell.swift
//  TROS
//
//  Created by Swapnil Katkar on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CategoryProductCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
