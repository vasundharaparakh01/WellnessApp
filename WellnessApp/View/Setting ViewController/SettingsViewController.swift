//
//  SettingsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 27/12/21.
//
import HealthKit
import UIKit

fileprivate struct NotificationOnOff {
    static let on = "1"
    static let off = "0"
}

fileprivate struct MeditationVoiceSetting {
    static let male = "male"
    static let female = "female"
}


class SettingsViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var switchStepNoti: UISwitch!
    @IBOutlet var switchWaterNoti: UISwitch!
    @IBOutlet var switchMeditaionAudio: UISwitch!
    @IBOutlet var switchDevice: UISwitch!
    
    @IBOutlet var viewAboutUs: UIView!
    @IBOutlet var viewChangePass: UIView!
    @IBOutlet var viewInviteOther: UIView!
    @IBOutlet var viewDeleteAccount: UIView!
    var healthStore = HKHealthStore()
    var setingViewModel = SettingsViewModel()
    var HomeModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        setingViewModel.settingNotificationDelegate = self
        HomeModel.deleteUserDelegate = self
        
        setupTapGesture()
        setupGUI()
        getUserSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                print(status)
                
                if status==true
        {
        
        switchDevice.setOn(true, animated: true)
                }
        else
        {
            switchDevice.setOn(false, animated: true)
        }
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SettingsViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fromSideMenu = false
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }

    //MARK: Setup Custom Navbar------------
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: Nav Button Func-------------
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    //MARK: Setup Tap Gesture-------------------
    func setupTapGesture() {
        let aboutUsTap = UITapGestureRecognizer.init(target: self, action: #selector(SettingsViewController.tapAboutUs(_:)))
        viewAboutUs.addGestureRecognizer(aboutUsTap)
        
        let changePassTap = UITapGestureRecognizer.init(target: self, action: #selector(SettingsViewController.tapChangePass(_:)))
        viewChangePass.addGestureRecognizer(changePassTap)
        
        let inviteTap = UITapGestureRecognizer.init(target: self, action: #selector(SettingsViewController.tapInvite(_:)))
        viewInviteOther.addGestureRecognizer(inviteTap)

        let DeleteTap = UITapGestureRecognizer.init(target: self, action: #selector(SettingsViewController.DeleteInvit(_:)))
        viewDeleteAccount.addGestureRecognizer(DeleteTap)
    }
    
    private func setupGUI() {
//        switchStepNoti.tintColor = UIColor.colorSetup()
//        switchWaterNoti.tintColor = UIColor.colorSetup()
//        switchMeditaionAudio.tintColor = UIColor.colorSetup()
        
        switchStepNoti.onTintColor = UIColor.colorSetup()
        switchWaterNoti.onTintColor = UIColor.colorSetup()
        switchMeditaionAudio.onTintColor = UIColor.colorSetup()
        switchDevice.onTintColor = UIColor.colorSetup()
    }
    
    //MARK: -------Get Data------
    func getUserSettings() {
        //api call here
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
            setingViewModel.getSettingNotification(token: token)
        }
    }
    
    //MARK: Tap Gesture Func-------------------
    @objc func tapAboutUs(_ sender: UITapGestureRecognizer) {
        let aboutUsVC = ConstantStoryboard.aboutUsStoryboard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
        navigationController?.pushViewController(aboutUsVC, animated: true)
    }
    
    @objc func tapChangePass(_ sender: UITapGestureRecognizer) {
        let changePassVC = ConstantStoryboard.changePasswordStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        navigationController?.pushViewController(changePassVC, animated: true)
    }
    
    @objc func tapInvite(_ sender: UITapGestureRecognizer) {
        
        UserDefaults.standard.set(true, forKey: "FromSettings")
        let signupVC = ConstantStoryboard.videoPlay.instantiateViewController(identifier: "VideoPlay") as! VideoPlay
        self.navigationController?.pushViewController(signupVC, animated: true)
    }

    @objc func DeleteInvit(_ sender: UITapGestureRecognizer) {


        let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to delete your acount", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")


            guard let fcmToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
               // self.view.stopActivityIndicator()
                return
            }

            print(fcmToken)

            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                //self.view.stopActivityIndicator()
                return
            }


            let request = DeleteUserRequest(fcm: fcmToken, isDeleted: true)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            self.HomeModel.DeleteUserData(DeleteRequest: request, token: token)

        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")

        }))



        present(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK: Switch Func-------------------------
    @IBAction func switchStepNotification(_ sender: Any) {
        if switchStepNoti.isOn {
            setNotification(Url: Common.WebserviceAPI.setStepNotification, onOffStatus: NotificationOnOff.on)
        } else {
            setNotification(Url: Common.WebserviceAPI.setStepNotification,onOffStatus: NotificationOnOff.off)
        }
    }
    @IBAction func switchWaterNotification(_ sender: Any) {
        if switchWaterNoti.isOn {
            setNotification(Url: Common.WebserviceAPI.setWaterNotification, onOffStatus: NotificationOnOff.on)
        } else {
            setNotification(Url: Common.WebserviceAPI.setWaterNotification,onOffStatus: NotificationOnOff.off)
        }
    }
    
    @IBAction func switchMeditaionAudio(_ sender: Any) {
        if switchMeditaionAudio.isOn {
            setNotification(Url: Common.WebserviceAPI.setMaleFemale, onOffStatus: MeditationVoiceSetting.female)
        } else {
            setNotification(Url: Common.WebserviceAPI.setMaleFemale, onOffStatus: MeditationVoiceSetting.male)
        }
    }
    
    @IBAction func switchDevice(_ sender: Any) {
        if switchDevice.isOn {
            //setNotification(Url: Common.WebserviceAPI.setWaterNotification, onOffStatus: NotificationOnOff.on)
           // UserDefaults.standard.set(true, forKey: "isFromWatch")
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to measure your regular activities through Apple Watch", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                                UserDefaults.standard.set(true, forKey: "isFromWatch")
                
                let status = UserDefaults.standard.bool(forKey: "isPermissiongranted")
                        print(status)
        
                       if status==true
                
                    
                {
                (UIApplication.shared.delegate as? AppDelegate)?.trackBGSteps()
                (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
                }
                
                else{
                    
                    self.autorizeHealthKit()
                   // (UIApplication.shared.delegate as? AppDelegate)?.trackBGSteps()
                   // (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
                }
                
            
           
                
            }))

         

            present(refreshAlert, animated: true, completion: nil)
        
        
            
            
        } else {
           // setNotification(Url: Common.WebserviceAPI.setWaterNotification, onOffStatus: NotificationOnOff.on)
           // UserDefaults.standard.set(false, forKey: "isFromWatch")
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to measure your regular activities through iPhone", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                                UserDefaults.standard.set(false, forKey: "isFromWatch")
                
                (UIApplication.shared.delegate as? AppDelegate)?.trackBGSteps()
                (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
           
                
            }))

         

            present(refreshAlert, animated: true, completion: nil)
        
        }
    }
    
    
    func autorizeHealthKit()
        {
            let read = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!,HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning)!])
//            let share = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!])
            healthStore.requestAuthorization(toShare: read, read: read) { (chk, err) in
                
                if chk
                {
                    print("Permission granted")
                    
    
                }
            }
        }
    
    
    private func setNotification(Url: String, onOffStatus: String) {
        //api call here
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
            
            let urlString = Url + onOffStatus
            guard let urlStrings = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            print("NOtifiaction settings----->\(urlStrings)")
            setingViewModel.setSettingNotification(token: token, Url: urlStrings)
        }
    }
    
    //MARK: -----Notification Setup
    @objc func setupNotificationBadge() {
        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }
        
        if badgeCount != 0 {
            viewNotificationCount.isHidden = false
            lblNotificationLabel.text = "\(badgeCount)"
        } else {
            viewNotificationCount.isHidden = true
            lblNotificationLabel.text = "0"
        }
        print("BADGE COUNT-----\(badgeCount)")
    }
}

extension SettingsViewController: SettingNotificationDelegate {
    func didReceiveSettingNotificationGetDataResponse(settingGetDataResponse: SettingNotificationGetResponse?) {
        self.view.stopActivityIndicator()
        
        if(settingGetDataResponse?.status != nil && settingGetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)
            
            if let settingData = settingGetDataResponse?.settings {
                //Notification step
                if settingData[0].step_notification == 0 {
                    switchStepNoti.setOn(false, animated: true)
                } else {
                    switchStepNoti.setOn(true, animated: true)
                }
                //Notification water
                if settingData[0].water_notification == 0 {
                    switchWaterNoti.setOn(false, animated: true)
                } else {
                    switchWaterNoti.setOn(true, animated: true)
                }
                //Notification meditation audio
                if settingData[0].voice_type == MeditationVoiceSetting.male {
                    switchMeditaionAudio.setOn(false, animated: true)
                } else {
                    switchMeditaionAudio.setOn(true, animated: true)
                }
            } else {
                switchStepNoti.setOn(false, animated: true)
                switchWaterNoti.setOn(false, animated: true)
                switchMeditaionAudio.setOn(false, animated: true)
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveSettingNotificationSetDataResponse(settingSetDataResponse: SettingNotificationSetResponse?) {
        self.view.stopActivityIndicator()
        
        if(settingSetDataResponse?.status != nil && settingSetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)
            if let msg = settingSetDataResponse?.message?.firstCapitalized {
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: msg)
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: settingSetDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveSettingDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
}

extension SettingsViewController : DeleteUserDelegate
{
    func didReceiveDeleteUserResponse(DeleteResponse: DeleteUserResponse?) {
        if(DeleteResponse?.status != nil && DeleteResponse?.status?.lowercased() == ConstantStatusAPI.success) {
        self.view.stopActivityIndicator()
        print("DATA======<><><><>", DeleteResponse ?? "")
//
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: LoginViewController.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }

            let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let rootNC = UINavigationController(rootViewController: initialViewController)
            rootNC.isNavigationBarHidden = true

            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = rootNC
        }
        else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: DeleteResponse?.message ?? ConstantStatusAPI.failed)
        }

    }

    func didReceiveDeleteUserError(statusCode: String?) {

    }



}

