//
//  UIViewExtension.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 28/09/21.
//

import Foundation
import UIKit

extension UIView {    
    //MARK: - Setup Gradient
    func setGradientBackground(hexColor: [String], rightToLeft: Bool, leftToRight: Bool, topToBottom: Bool, bottomToTop: Bool) {
//        let colorStart =  UIColor.init(hexString: startHexColor).cgColor
//        let colorMid =  UIColor.init(hexString: midHexColor).cgColor
//        let colorEnd = UIColor.init(hexString: endHexColor).cgColor
        
        var colorArray = [CGColor]()
        
        colorArray.removeAll()
        for item in hexColor {
            colorArray.append(UIColor.init(hexString: item).cgColor)
        }

        print(colorArray)
        
        var gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = colorArray//[colorStart, colorMid, colorEnd]
//        gradientLayer.locations = [0.0, 0.1]
        if rightToLeft {
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        if leftToRight {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        if topToBottom {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        if bottomToTop {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        }
        layer.insertSublayer(gradientLayer, at:0)
        
        colorArray.removeAll()
    }
    
    func roundCornersBottomLeft(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMaxXMaxYCorner]
     }
    
    func roundCornersBottomLeftRight(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
     }
    
    func shadowLayerView() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: -1, height: 2)
        layer.shadowRadius = 5
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
//        let shadowView = UIView(frame: CGRect(x: 0, y: self.bounds.maxY, width: (self.bounds.width), height: 20))
//        // Make the backgroundColor of your wish, though I have made it .clear here
//        // Since we're dealing it in the shadow layer
//        shadowView.backgroundColor = .clear
//        self.insertSubview(shadowView, at: 1)
//
//        let shadowLayer = CAShapeLayer()
//        // While creating UIBezierPath, bottomLeft & right will do the work for you in this case
//        // I've removed the extra element from here.
//        shadowLayer.path = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        shadowLayer.fillColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        // This too you can set as per your desired result
//        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 4.0)
//        shadowLayer.shadowOpacity = 0.8
//        shadowLayer.shadowRadius = 2
//        shadowView.layer.insertSublayer(shadowLayer, at: 0)
    }
}
