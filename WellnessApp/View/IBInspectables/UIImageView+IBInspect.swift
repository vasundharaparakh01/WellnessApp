//
//  UIImageView+IBInspect.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 29/09/21.
//

import Foundation
import UIKit

@IBDesignable
class UIImageView_Designable: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
