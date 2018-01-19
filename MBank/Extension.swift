//
//  Extension.swift
//  MBank
//
//  Created by Mac on 22/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit


extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}


enum  SerializationError: Error {
    case invalid(String, Any)
}


extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}


