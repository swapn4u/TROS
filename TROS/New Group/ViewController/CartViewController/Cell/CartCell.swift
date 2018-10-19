//
//  CartCell.swift
//  TROS
//
//  Created by Swapnil Katkar on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

protocol showGrandTotalProtocol {
    func updateTotal(cell:UITableViewCell,tag:Int)
}

class CartCell: UITableViewCell {
    //outlet connection
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var comboDecLabel: UILabel!
    @IBOutlet weak var deleteProductButton: UIButton!
    
    //variable and constant
    var initialCount = 1
    var currentPrice = 0.0
    
    //delegate
    var delegate : showGrandTotalProtocol?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func NumberOfItemSelectorPressed(_ sender: UIButton)
    {
        initialCount = sender.tag == 0 ? initialCount - 1 : initialCount+1
        initialCount = initialCount == 0 ? 1 : initialCount
        totalItemLabel.text = "\(initialCount)"
       let currentPriceStr = self.amountLabel.text!.replacingOccurrences(of: " ₹ : ", with: "").trimmingCharacters(in: .whitespaces)
        self.currentPrice = Double(currentPriceStr) ?? 0.0
//        amountLabel.text = " ₹ : \(initialCount*currentPrice)"
        delegate?.updateTotal(cell: self,tag:sender.tag)
    }
    
}
