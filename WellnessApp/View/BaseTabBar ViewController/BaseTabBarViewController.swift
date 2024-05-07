//
//  BaseTabBarViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 01/10/21.
//

import UIKit

class BaseTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var homeVC = HomeViewController()
    //, RoundedCornerNavigationBar
    private var homeButton = UIButton()
//    private var drawerTransition:DrawerTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)

        self.delegate = self
        self.selectedIndex = 2
        
        setupMiddleButton()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshHomeButtonColor),
                                               name: Notification.Name(ConstantLocalNotification.refreshHomeButtonColor),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("base tabbar viewwillappear---------->")
        
        homeButton.backgroundColor = UIColor.colorSetup()
        
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.colorSetup()
        
//        //Disable tab bar item
//        if let tabBarItemsArray = self.tabBar.items {
////            tabBarItemsArray[3].isEnabled = false
//            tabBarItemsArray[4].isEnabled = false
//        }
    }
    
    func setupMiddleButton() {
//        homeButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 25, y: -20, width: 65, height: 65))
        homeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        
        var menuButtonFrame = homeButton.frame
        menuButtonFrame.origin.x = self.view.bounds.width / 2 - menuButtonFrame.size.width / 2
        menuButtonFrame.origin.y = -20 //self.view.frame.origin.y - menuButtonFrame.height / 2
        homeButton.frame = menuButtonFrame

        homeButton.backgroundColor = UIColor.colorSetup()
        homeButton.setImage(UIImage(named: ConstantBottomButton.home), for: .normal)
        homeButton.layer.shadowColor = UIColor.black.cgColor
        homeButton.layer.shadowOpacity = 0.1
        homeButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        homeButton.layer.cornerRadius = homeButton.frame.size.height/2
        homeButton.addTarget(self, action: #selector(homeButtonAction), for: .touchUpInside)
//        self.view.insertSubview(homeButton, aboveSubview: self.tabBar)
        self.tabBar.addSubview(homeButton)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func refreshHomeButtonColor() {
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.colorSetup()
        homeButton.backgroundColor = UIColor.colorSetup()
    }

    @objc func homeButtonAction(sender: UIButton) {
        debugPrint("TAB BAR HOME ----->")
        self.selectedIndex = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
            rootView.popToRootViewController(animated: false)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        isFromBackWater = false
        isFromBackExercise = false
        isFromTabarMeditation = true
        indexpath=nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UserDefaults.standard.set(false, forKey: "FromHomeEdit")
            let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
            rootView.popToRootViewController(animated: false)
        }
    }
}


