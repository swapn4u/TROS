//
//  SelectAddressCell.swift
//  TROS
//
//  Created by Swapnil Katkar on 29/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SelectAddressCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
