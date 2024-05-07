//
//  UIImageViewExtension.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 08/10/21.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageTintColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func rotate(duration: Int) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = CFTimeInterval(duration)
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
