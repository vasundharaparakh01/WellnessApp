//
//  UIView+IBInspect.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 03/09/21.
//

import Foundation
import UIKit

@IBDesignable
class UIView_Designable: UIView {
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.white {
        didSet {
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            layer.shadowColor = shadowColor.cgColor
            layer.shadowRadius = 2.0
            layer.shadowOpacity = 0.35
        }
    }
    
}

