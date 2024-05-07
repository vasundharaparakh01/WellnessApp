//
//  ResetPasswordViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet var txtResetToken: UITextField_Designable!
    @IBOutlet var txtNewPassword: UITextField_Designable!
    @IBOutlet var txtConfirmPassword: UITextField_Designable!
    @IBOutlet var btnEyeNewPass: UIButton!
    @IBOutlet var btnEyeConfirmPass: UIButton!
    
    var boolShowPassword = false
    var boolShowConfirmPassword = false
    
    var resetPasswordViewModel = ResetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetPasswordViewModel.delegate = self
    }
    
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
            guard let newPass = txtNewPassword.text else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.emptyNewPassword)
                return
            }
            
            guard let confirmPass = txtConfirmPassword.text else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.emptyConfirmPassword)
                return
            }
            
            if (newPass == confirmPass) {
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                
                let request = ResetPasswordResquest(resetToken: txtResetToken.text, password: txtConfirmPassword.text)
                resetPasswordViewModel.resetPassword(resetPasswordRequest: request)
                
            } else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.passwordConfirmPasswordNotSame)
            }
        }
    }
    
    @IBAction func btnBackToLogin(_ sender: Any) {
        //See navigation extension file
        self.navigationController?.popToCustomViewController(viewController: LoginViewController.self)
    }
    
}
