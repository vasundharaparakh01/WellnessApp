//
//  ChakraViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/09/21.
//

import UIKit

class ChakraViewController: UIViewController, RoundedCornerNavigationBar, ChakraPopupViewControllerDelegate {

    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgViewChakra: UIImageView!
    
    let chakraPopupVC = ChakraPopupViewController()
    var chakraDiplayViewModel = ChakraDisplayViewModel()
    var chakraResponse: ChakraDisplayResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomNavBar()

        imgViewChakra.alpha = 0.0
        imgViewChakra.isUserInteractionEnabled = false
        
        chakraDiplayViewModel.delegate = self
        chakraPopupVC.delegate = self
        
        setupTapGesture()
        getChakraStatus()
    }
    
    //MARK: - Setup Custom Navbar
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: - Chakra Popup VC Delegate
    func refreshViewController() {
        setupChakraAccordingly()
    }
    
    //MARK: - Tap Gesture Setup
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(touchHappen(_:)))
        imgViewChakra.isUserInteractionEnabled = true
        imgViewChakra.addGestureRecognizer(tapGesture)
    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
//        let baseTabVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
//        self.navigationController?.pushViewController(baseTabVC, animated: true)
        
        UserDefaults.standard.set(false, forKey: "FromSettings")
        
                        let signupVC = ConstantStoryboard.videoPlay.instantiateViewController(identifier: "VideoPlay") as! VideoPlay
                        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func btnPush(_ sender: Any) {
        let baseTabVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
        self.navigationController?.pushViewController(baseTabVC, animated: true)
    }
    
}
