//
//  ColorExtension.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation
import UIKit

extension UIColor {
    
    class func customOrangeColor() -> UIColor {
        return UIColor(red: 208/255, green: 90/255, blue: 33/255, alpha: 1.0)
    }
    
    class func customeBorderOrangeColor() -> UIColor {
        return UIColor(red: 226/255, green: 199/255, blue: 183/255, alpha: 1.0)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
//    class func hexStringToUIColor(hex: String) -> UIColor {
//        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//        if (cString.hasPrefix("#")) {
//            cString.remove(at: cString.startIndex)
//        }
//
//        if ((cString.count) != 6) {
//            return UIColor.gray
//        }
//
//        var rgbValue:UInt64 = 0
//        Scanner(string: cString).scanHexInt64(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
    
    class func colorSetup() -> UIColor {
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 0
        print("coloris ...--->>>",chakraColour)
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               
               print(crownList)
        
        if chakraColour==0 {
            switch chakraLevel {
            case 1:
                return UIColor(hexString: ConstantThemeSolidColor.red)
                
            case 2:
                return UIColor(hexString: ConstantThemeSolidColor.orange)
                
            case 3:
                return UIColor(hexString: ConstantThemeSolidColor.yellow)
                
            case 4:
                return UIColor(hexString: ConstantThemeSolidColor.green)
                
            case 5:
                return UIColor(hexString: ConstantThemeSolidColor.blue)
            
            case 6:
                return UIColor(hexString: ConstantThemeSolidColor.purple)
                
            case 7:
                return UIColor(hexString: ConstantThemeSolidColor.violet)
                
            default:
                return UIColor(hexString: ConstantThemeSolidColor.red)
            }
        }
        else if crownList == 1{
            switch chakraColour {
            case 1:
                return UIColor(hexString: ConstantThemeSolidColor.red)

            case 2:
                return UIColor(hexString: ConstantThemeSolidColor.orange)

            case 3:
                return UIColor(hexString: ConstantThemeSolidColor.yellow)

            case 4:
                return UIColor(hexString: ConstantThemeSolidColor.green)

            case 5:
                return UIColor(hexString: ConstantThemeSolidColor.blue)

            case 6:
                return UIColor(hexString: ConstantThemeSolidColor.purple)

            case 7:
                return UIColor(hexString: ConstantThemeSolidColor.violet)

            default:
                return UIColor(hexString: ConstantThemeSolidColor.red)
            }
        }
        else{
            
            switch chakraLevel {
            case 1:
                return UIColor(hexString: ConstantThemeSolidColor.red)
                
            case 2:
                return UIColor(hexString: ConstantThemeSolidColor.orange)
                
            case 3:
                return UIColor(hexString: ConstantThemeSolidColor.yellow)
                
            case 4:
                return UIColor(hexString: ConstantThemeSolidColor.green)
                
            case 5:
                return UIColor(hexString: ConstantThemeSolidColor.blue)
            
            case 6:
                return UIColor(hexString: ConstantThemeSolidColor.purple)
                
            case 7:
                return UIColor(hexString: ConstantThemeSolidColor.violet)
                
            default:
                return UIColor(hexString: ConstantThemeSolidColor.red)
            }
        }

        
    }
}
