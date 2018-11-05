//
//  String + Extension.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 18/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
public extension String {
    public func toFloat() -> Float? {
        return Float.init(self)
    }
    
    public func toDouble() -> Double? {
        return Double.init(self) ?? 0.0
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf16,allowLossyConversion: true) else { return NSAttributedString() }
        do {
            let attribitedString = try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
            attribitedString.addAttributes([NSAttributedStringKey.font:UIFont(name: "Courier-Bold", size: 12) ?? .systemFont(ofSize: 14)], range: NSRange(
                location: 0,
                length: attribitedString.length))
            return attribitedString
            
        } catch
        {
            return NSAttributedString()
        }
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
