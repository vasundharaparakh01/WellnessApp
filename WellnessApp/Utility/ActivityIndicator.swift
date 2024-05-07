//
//  ActivityIndicator.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 21/09/21.
//

import Foundation
import UIKit

extension UIView {
    
    public func startActivityIndicator(title: String, color: UIColor) {
        
        DispatchQueue.main.async {
            let backgroundView = UIView()
            backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            backgroundView.backgroundColor = .clear
            backgroundView.tag = 152420
            
            let strLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 160, height: 46))
            strLabel.text = title
            strLabel.font = .systemFont(ofSize: 15, weight: .medium)
            strLabel.textColor = UIColor(white: 1.0, alpha: 1.0)
            
            let effectView = UIVisualEffectView.init(frame: CGRect(x: self.frame.midX - strLabel.frame.width/2, y: self.frame.midY - strLabel.frame.height/2 , width: 160, height: 50))
            effectView.layer.cornerRadius = 15
            effectView.layer.masksToBounds = true
    //        effectView.effect = UIBlurEffect(style: .dark) //UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
            effectView.backgroundColor = .gray.withAlphaComponent(0.7)
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            activityIndicator.color = color
            
    //        self.isUserInteractionEnabled = false
            
            effectView.contentView.addSubview(activityIndicator)
            effectView.contentView.addSubview(strLabel)
            backgroundView.addSubview(effectView)
            self.addSubview(backgroundView)
        }
    }
    
    public func stopActivityIndicator() {
        DispatchQueue.main.async {
            if let backgroundView = self.viewWithTag(152420){
                backgroundView.removeFromSuperview()
            }
            self.isUserInteractionEnabled = true
        }
    }
    
//    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
//            let backgroundView = UIView()
//            backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
//            backgroundView.backgroundColor = backgroundColor
//            backgroundView.tag = 475647
//
//            var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//            activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
//            activityIndicator.center = self.center
//            activityIndicator.hidesWhenStopped = true
//            activityIndicator.style = .medium
//            activityIndicator.color = activityColor
//            activityIndicator.startAnimating()
//            self.isUserInteractionEnabled = false
//
//            backgroundView.addSubview(activityIndicator)
//
//            self.addSubview(backgroundView)
//        }
//
//        func activityStopAnimating() {
//            if let background = viewWithTag(475647){
//                background.removeFromSuperview()
//            }
//            self.isUserInteractionEnabled = true
//        }
}
