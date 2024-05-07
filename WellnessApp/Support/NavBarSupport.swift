//
//  NavBarSupport.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 06/09/21.
//

import Foundation

////This class is of use for AppDelegate
//class NavBarSupport {
//
//    func shadowTopBar(_ topBar: UINavigationBar){
//        // Set the prefers title style first
//        // since this is how navigation bar bounds gets calculated
//        //
//
//        topBar.isTranslucent = true
////        topBar.tintColor = UIColor.orange
//
//        topBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        topBar.shadowImage = UIImage()
//        topBar.backgroundColor = UIColor.green
//        // Make your y position to the max of the uiNavigationBar
//        // Height should the cornerRadius height, in your case lets say 20
//        let shadowView = UIView(frame: CGRect(x: 0, y: topBar.bounds.maxY, width: (topBar.bounds.width), height: 20))
//        // Make the backgroundColor of your wish, though I have made it .clear here
//        // Since we're dealing it in the shadow layer
//        shadowView.backgroundColor = .clear
//        topBar.insertSubview(shadowView, at: 1)
//
//        let shadowLayer = CAShapeLayer()
//        // While creating UIBezierPath, bottomLeft & right will do the work for you in this case
//        // I've removed the extra element from here.
//        shadowLayer.path = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        shadowLayer.fillColor = UIColor.red.cgColor
//        shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        // This too you can set as per your desired result
//        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 4.0)
//        shadowLayer.shadowOpacity = 0.8
//        shadowLayer.shadowRadius = 2
//        shadowView.layer.insertSublayer(shadowLayer, at: 0)
//
//    }
//
//}
