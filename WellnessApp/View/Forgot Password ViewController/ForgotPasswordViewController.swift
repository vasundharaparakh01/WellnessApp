//
//  ForgotPasswordViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var txtEmailId: UITextField_Designable!
    
    private var forgotViewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        forgotViewModel.delegate = self
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)

            let request = ForgotPasswordResquest(userEmail: txtEmailId.text)
            forgotViewModel.forgotPassword(forgotPasswordRequest: request)
        }
    }
    
    @IBAction func btnBackToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ForgotPasswordViewController: ForgotPasswordViewModelDelegate {
    //MARK: - Delegate
    func didReceiveForgotPasswordResponse(forgotResponse: ForgotPasswordResponse?) {
        self.view.stopActivityIndicator()
        
        if(forgotResponse?.status != nil && forgotResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(forgotResponse)
            
            if let message = forgotResponse?.message?.firstCapitalized {
                self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                             message: message,  //String(forgotResponse?.token ?? 0),
                                             alertStyle: .alert,
                                             actionTitles: [ConstantAlertTitle.OkAlertTitle],
                                             actionStyles: [.default],
                                             actions: [
                                                { _ in
                                                    let resetVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "ResetPasswordViewController") as! ResetPasswordViewController
                                                    self.navigationController?.pushViewController(resetVC, animated: true)
                                                }
                                             ])
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: forgotResponse?.error ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    func didReceiveForgotPasswordError(statusCode: String?) {
        self.view.stopActivityIndicator()
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
