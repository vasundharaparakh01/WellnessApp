////
////  ViewControllerExtension.swift
////  Luvo
////
////  Created by BEASMACUSR02 on 25/09/21.
////
//
//import Foundation
//import UIKit
//
//
//extension UIViewController {
//    
//    func setupCenterNavItems(imageNamed: String?, titleText: String?) {
//        
//        if imageNamed != nil {
//            let title = UIImageView(image: UIImage.init(named: imageNamed!))
//            title.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//            title.contentMode = .scaleAspectFit
//            
//            navigationItem.titleView = title
//        }
//        
//        if titleText != nil {
//            let title =  UILabel()
//            title.text = titleText
//            title.font = UIFont.init(name: ConstantFontName.fontNunitoExtraBold, size: 22.0)
//            title.frame = CGRect(x: 0, y: 0, width: 142, height: 30)
//            title.contentMode = .scaleAspectFit
//            
//            navigationItem.titleView = title
//            
//        } else {
//            navigationItem.titleView = nil
//        }
//    }
//    
//    func setupLeftNavItem(imageNamed: String?, selectorName: String?, pushTo: Int?) {
//        
//        if imageNamed != nil {
//            let leftButton = UIButton(type: .system)
//            leftButton.setImage(UIImage.init(named: imageNamed!), for: .normal)
//            leftButton.frame = CGRect(x: 0, y: 0, width: 36, height: 34)
//            
//            if selectorName == ConstantNavigationBarSelectorName.selectorMenu {
//                leftButton.addTarget(self, action: #selector(btnNavOpenMenu), for: .touchUpInside)
//            } else if selectorName == ConstantNavigationBarSelectorName.selectorPush {
//                if let pushTo = pushTo {
//                    leftButton.tag = pushTo
//                }                
//                leftButton.addTarget(self, action: #selector(btnNavPush), for: .touchUpInside)
//            } else {
//                leftButton.addTarget(self, action: #selector(btnNavPop), for: .touchUpInside)
//            }
//            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
//            
//        } else {
//            navigationItem.leftBarButtonItem = nil
//        }
//    }
//    
//    func setupRightNavItems(leftImageNamed: String?, rightImageNamed: String?) {
//        
//        if leftImageNamed != nil {
//            let searchButton = UIButton(type: .system)
//            searchButton.setImage(UIImage.init(named: leftImageNamed!), for: .normal)
//            searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//            searchButton.addTarget(self, action: #selector(btnNotification), for: .touchUpInside)
//            
//            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
//            
//        } else if rightImageNamed != nil {
//            let searchButton = UIButton(type: .system)
//            searchButton.setImage(UIImage.init(named: rightImageNamed!), for: .normal)
//            searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
////            searchButton.addTarget(self, action: #selector(btnNotification), for: .touchUpInside)
//            
//            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
//            
//        } else {
//            navigationItem.leftBarButtonItem = nil
//        }
////        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: composeButton), UIBarButtonItem(customView: searchButton)]
//        
//    }
//    
//    //MARK: - Button Func
//    @objc func btnNavOpenMenu() {
//        debugPrint("NAV MENU OPEN ------>")
//    }
//    
//    //Push to viewController according to button tag value
//    @objc func btnNavPush(sender:UIButton) {
//        if sender.tag == ConstantNavigationButtonTag.tagHomeVC {
//            debugPrint("NAV PUSH TabBrViewController----------->")
//            let tabbarVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
//            navigationController?.pushViewController(tabbarVC, animated: true)
//        } else {
//            debugPrint("NAV PUSH OtherVC---------->")
//        }
//    }
//    
//    @objc func btnNavPop() {
//        debugPrint("NAV POP ----------->")
//    }
//    
//    @objc func btnNotification() {
//        
//    }
//}
