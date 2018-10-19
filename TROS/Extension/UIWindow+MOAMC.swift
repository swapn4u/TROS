//
//  Window+MOAMC.swift
//  DropDown
//
//  Created by Ashish Vishwakarma on 13/03/18.
//  Copyright © 2018 Anurag Kulkarni. All rights reserved.
//

import UIKit

extension UIWindow {

    static func visibleWindow() -> UIWindow? {
        var currentWindow = UIApplication.shared.keyWindow
        
        if currentWindow == nil {
            let frontToBackWindows = Array(UIApplication.shared.windows.reversed())
            
            for window in frontToBackWindows {
                if window.windowLevel == UIWindowLevelNormal {
                    currentWindow = window
                    break
                }
            }
        }
        
        return currentWindow
    }
}
