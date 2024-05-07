//
//  SignUpViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 08/09/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var txtUsername: UITextField_Designable!
    @IBOutlet var txtEmail: UITextField_Designable!
    @IBOutlet var txtPassword: UITextField_Designable!
    @IBOutlet var txtPhoneNo: UITextField_Designable!    
    @IBOutlet var btnTermsCondition: UIButton!
    @IBOutlet var btnEye: UIButton!
    
    private var signupViewModel = SignupViewModel()
    
    var boolShowPassword = false
    var boolAcceptTermsCondition = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signupViewModel.delegate = self
    }
    
    //MARK: - Button Func
    @IBAction func btnShowPassword(_ sender: Any) {
        if (boolShowPassword == false) {
            boolShowPassword = true
            txtPassword.isSecureTextEntry = false
            btnEye.setImage(UIImage.init(named: ConstantImageSet.hidePassword), for: .normal)
        } else {
            boolShowPassword = false
            txtPassword.isSecureTextEntry = true
            btnEye.setImage(UIImage.init(named: ConstantImageSet.showPassword), for: .normal)
        }
    }
    
    @IBAction func btnTermsAndConditions(_ sender: Any) {
        if (boolAcceptTermsCondition == false) {
            boolAcceptTermsCondition = true
            btnTermsCondition.setImage(UIImage.init(named: "check"), for: .normal)
        } else {
            boolAcceptTermsCondition = false
            btnTermsCondition.setImage(UIImage.init(named: "uncheck"), for: .normal)
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        if (boolAcceptTermsCondition) {
            let connectionStatus = ConnectionManager.shared.hasConnectivity()
            if (connectionStatus == false) {
                DispatchQueue.main.async {
                    self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                    return
                }
            } else {
                //------------------------------------------
                guard let FCMToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }
                
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                
                let request = SignupResquest(name: txtUsername.text, userEmail: txtEmail.text, mobileNo: txtPhoneNo.text, password: txtPassword.text, dateOfBirth: "", FCMToken: FCMToken)
                signupViewModel.signupUser(signupRequest: request)
            }
        } else {
            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.AcceptTerms)
        }
        
    }
    
    @IBAction func btnLoginNow(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
