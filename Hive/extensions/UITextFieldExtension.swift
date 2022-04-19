//
//  UITextFieldExtension.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import Foundation
import UIKit

extension UITextField {
    
    func addBottomBorder(){
    
            let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.size.width, height: 1)
            bottomLine.backgroundColor = UIColor.black.cgColor
        
            borderStyle = .none
            layer.addSublayer(bottomLine)
        }
}
