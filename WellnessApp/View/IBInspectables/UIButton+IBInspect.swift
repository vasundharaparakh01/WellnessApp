//
//  UIButton+IBInspect.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 03/09/21.
//

import Foundation
import UIKit

@IBDesignable
class UIBUtton_Designable: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
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

}
