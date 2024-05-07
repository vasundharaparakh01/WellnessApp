//
//  ChangePasswordViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var txtOldPassword: UITextField_Designable!
    @IBOutlet var txtNewPassword: UITextField_Designable!
    @IBOutlet var txtConfirmPassword: UITextField_Designable!
    @IBOutlet var btnEyeNewPass: UIButton!
    @IBOutlet var btnEyeConfirmPass: UIButton!
    @IBOutlet var btnSend: UIBUtton_Designable!
    
    var boolShowPassword = false
    var boolShowConfirmPassword = false
    
    var changePassViewModel = ChangePasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        changePassViewModel.delegate = self
        
        setupGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
    
    //MARK: -----Setup GUI----
    fileprivate func setupGUI() {
        //Need to change icon tint color if customer say
    }
    //MARK: ----Button Func----
    @IBAction func btnShowNewPassword(_ sender: Any) {
        if (boolShowPassword == false) {
            boolShowPassword = true
            txtNewPassword.isSecureTextEntry = false
            btnEyeNewPass.setImage(UIImage.init(named: ConstantImageSet.hidePassword), for: .normal)
        } else {
            boolShowPassword = false
            txtNewPassword.isSecureTextEntry = true
            btnEyeNewPass.setImage(UIImage.init(named: ConstantImageSet.showPassword), for: .normal)
        }
    }
    
    @IBAction func btnShowConfirmPassword(_ sender: Any) {
        if (boolShowConfirmPassword == false) {
            boolShowConfirmPassword = true
            txtConfirmPassword.isSecureTextEntry = false
            btnEyeConfirmPass.setImage(UIImage.init(named: ConstantImageSet.hidePassword), for: .normal)
        } else {
            boolShowConfirmPassword = false
            txtConfirmPassword.isSecureTextEntry = true
            btnEyeConfirmPass.setImage(UIImage.init(named: ConstantImageSet.showPassword), for: .normal)
        }
    }
    
    @IBAction func btnSend(_ sender: Any) {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let oldPass = txtOldPassword.text else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.oldPassEmpty)
                return
            }
            
            guard let newPass = txtNewPassword.text else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.emptyNewPassword)
                return
            }
            
            guard let confirmPass = txtConfirmPassword.text else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.emptyConfirmPassword)
                return
            }
            
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            
            let request = ChangePasswordRequest(oldPasswd: oldPass, newPasswd: newPass, confPasswd: confirmPass)
            changePassViewModel.changePassword(token: token, changePasswordRequest: request)
            
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

extension ChangePasswordViewController: ChangePasswordViewModelDelegate {
    func didReceiveChanngePasswordResponse(changePasswordResponse: ChangePasswordResponse?) {
        self.view.stopActivityIndicator()
        
        if(changePasswordResponse?.status != nil && changePasswordResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)
            if let msg = changePasswordResponse?.message?.firstCapitalized {
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: msg)
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: changePasswordResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveChangePasswordError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
        
}
