//
//  UIView + Extension.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 18/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
extension UIView
{
    func addShadow()
    {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 0.5
        layer.shadowColor = UIColor.white.cgColor
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
