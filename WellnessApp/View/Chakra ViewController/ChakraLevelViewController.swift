//
//  ChakraLevelViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 25/11/21.
//

import UIKit

class ChakraLevelViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet weak var btnBAck: UIButton?
    
    @IBOutlet var imgViewChakra: UIImageView!
    
    var ColorChangeViewModel = ChakraColorChangeViewModel()
    var chakraDisplayViewModel = ChakraDisplayViewModel()
    var chakraResponse: ChakraDisplayResponse?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
     //   setupCustomNavBar()
       // btnBAck?.isHidden=true
        chakraDisplayViewModel.delegate = self
        ColorChangeViewModel.delegate = self
        getChakraStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fromSideMenu = false
    }

    //MARK: - Setup Custom Navbar
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(ChakraLevelViewController.setupNotificationBadge),
//                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
//                                               object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: - Nav Button Func
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func btnNotification(_ sender: Any) {
//
//    }
    //-----------------------------
    
    //MARK: - Get Chakra Status
    func getChakraStatus() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            chakraDisplayViewModel.getChakraDisplayDetails(token: token)
        }
    }
    
    //MARK: - Setup Chakra Accordingly
    func setupChakraAccordingly() {
        if chakraResponse != nil {
            let chakraLevel = chakraResponse?.current_level
            let prevChakraLevel = chakraResponse?.prev_level
//            let chakraLevel = 7
//            let prevChakraLevel = 6
            
            switch chakraLevel {
            case 0:
                imgViewChakra.isUserInteractionEnabled = true
                self.imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra0)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 1:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra1)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 2:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra2)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 3:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra3)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 4:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra4)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 5:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra5)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 6:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra6)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 7:
                //If chakra level 7 is open then both blocked chakra level & prev chakra level will be 7
                if chakraLevel == 7 && prevChakraLevel == 7 {
                    imgViewChakra.isUserInteractionEnabled = true
                    imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakraAllOpen)
                    UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                        self.imgViewChakra.alpha = 1.0
                    })
                } else {
                    imgViewChakra.isUserInteractionEnabled = true
                    imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra7)
                    UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                        self.imgViewChakra.alpha = 1.0
                    })
                }
                break
                
            default:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra0)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            }
        }
    }
    
    //MARK: ----Button Function
    @IBAction func btnChakra7(_ sender: Any) {
        print("Chakra 7 selected------>")
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            //self.view.stopActivityIndicator() udChakraCrownListen
            return
            
            
        }
        debugPrint("token--->",token)
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        print(chakraLevel)
        
        
       if chakraLevel==7
        {
            if crownList == 1
            {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to change the App Theme color with Third Eye Chakra", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                
                self.ColorChangeViewModel.getChakraColorChangeDetails(token:token, chakravalue: 7)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
            
            }
//        }
            else
            {
                
                //Listening to all the audios in chakra meditation will enable you to change the app theme color
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Listening to all the audios in chakra meditation will enable you to change the app theme color", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")
                                
                                
                            }))

                            present(refreshAlert, animated: true, completion: nil)
            }
           
           
       }
        
        
    }
    @IBAction func btnChakra6(_ sender: Any) {
        print("Chakra 6 selected------>")
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            //self.view.stopActivityIndicator()
            return
        }
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        
        if chakraLevel==6||chakraLevel == 7
        {
            if crownList==1
            {
            
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to change the App Theme color with Third Eye Chakra", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.ColorChangeViewModel.getChakraColorChangeDetails(token:token, chakravalue: 6)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
            
            
            }
           
   //     }
            else
            {
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Listening to all the audios in chakra meditation will enable you to change the app theme color", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")
                                
                                
                            }))

                            present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func btnChakra5(_ sender: Any) {
        print("Chakra 5 selected------>")
        
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            //self.view.stopActivityIndicator()
            return
        }
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        
        if chakraLevel==5||chakraLevel == 6||chakraLevel == 7
        {
            if crownList==1
            {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to change the App Theme color with Throat Chakra", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.ColorChangeViewModel.getChakraColorChangeDetails(token:token, chakravalue: 5)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
            
            }
           
    //    }
            else
            {
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Listening to all the audios in chakra meditation will enable you to change the app theme color", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")
                                
                                
                            }))

                            present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func btnChakra4(_ sender: Any) {
        print("Chakra 4 selected------>")
        
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            //self.view.stopActivityIndicator()
            return
        }
        
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        
        if chakraLevel==4||chakraLevel == 5||chakraLevel == 6||chakraLevel == 7
        {
            if crownList==1
            {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to change the App Theme color with Heart Chakra", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.ColorChangeViewModel.getChakraColorChangeDetails(token:token, chakravalue: 4)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
            
            }
  //      }
            
            else
            {
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Listening to all the audios in chakra meditation will enable you to change the app theme color", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")
                                
                                
                            }))

                            present(refreshAlert, animated: true, completion: nil)
            }
           
        }
        
    }
    @IBAction func btnChakra3(_ sender: Any) {
        print("Chakra 3 selected------>")
        
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            //self.view.stopActivityIndicator()
            return
        }
        
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        
        if chakraLevel==3||chakraLevel == 4||chakraLevel == 5||chakraLevel == 6||chakraLevel == 7
        {
            if crownList==1
            {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to change the App Theme color with Solar Plexus Chakra", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.ColorChangeViewModel.getChakraColorChangeDetails(token:token, chakravalue: 3)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
            
            
            }
   //     }
            else
            {
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Listening to all the audios in chakra meditation will enable you to change the app theme color", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")
                                
                                
                            }))

                            present(refreshAlert, animated: true, completion: nil)
            }
           
        }
    }
    @IBAction func btnChakra2(_ sender: Any) {
        print("Chakra 2 selected------>")
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            //self.view.stopActivityIndicator()
            return
        }
        
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        
        if chakraLevel == 2||chakraLevel == 3||chakraLevel == 4||chakraLevel == 5||chakraLevel == 6||chakraLevel == 7
        {
            if crownList==1
            {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to change the App Theme color with Sacral Chakra", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.ColorChangeViewModel.getChakraColorChangeDetails(token:token, chakravalue: 2)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
            
            }
  //      }
            else
            {
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Listening to all the audios in chakra meditation will enable you to change the app theme color", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")
                                
                                
                            }))

                            present(refreshAlert, animated: true, completion: nil)
            }
           
        }
    }
    @IBAction func btnChakra1(_ sender: Any) {
        print("Chakra 1 selected------>")
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            //self.view.stopActivityIndicator()
            return
        }
        
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        
        if chakraLevel == 1||chakraLevel == 2||chakraLevel == 3||chakraLevel == 4||chakraLevel == 5||chakraLevel == 6||chakraLevel == 7
        {
            if crownList==1
            {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to change the App Theme color with Root Chakra", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.ColorChangeViewModel.getChakraColorChangeDetails(token:token, chakravalue: 1)
                
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
            
            }
     //   }
            else
            {
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Listening to all the audios in chakra meditation will enable you to change the app theme color", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")
                                
                                
                            }))

                            present(refreshAlert, animated: true, completion: nil)
            }
           
        }
        
    }
    
    
    
    
    
//    //MARK: -----Notification Setup
//    @objc func setupNotificationBadge() {
//        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }
//        
//        if badgeCount != 0 {
//            viewNotificationCount.isHidden = false
//            lblNotificationLabel.text = "\(badgeCount)"
//        } else {
//            viewNotificationCount.isHidden = true
//            lblNotificationLabel.text = "0"
//        }
//        print("BADGE COUNT-----\(badgeCount)")
//    }
}

extension ChakraLevelViewController: ChakraDisplayViewModelDelegate {
    func didReceiveChakraDisplayResponse(chakraDisplayResponse: ChakraDisplayResponse?) {
        self.view.stopActivityIndicator()
        
        if(chakraDisplayResponse?.status != nil && chakraDisplayResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(chakraDisplayResponse)
            
            chakraResponse = chakraDisplayResponse
            setupChakraAccordingly()
                        
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveChakraDisplayError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}


extension ChakraLevelViewController: ChakraColorChangeViewModelDelegate
{
    func didReceiveChakraColorChangeResponse(chakraColorChangeResponse: ChakraDisplayResponse?) {
        self.view.stopActivityIndicator()
        
        
        if(chakraColorChangeResponse?.status != nil && chakraColorChangeResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
            chakraResponse = chakraColorChangeResponse
            
            
        }
        else
        {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        
    }
    
    func didReceiveChakraColorChangeError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    
}
