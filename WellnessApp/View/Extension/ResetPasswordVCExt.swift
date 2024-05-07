//
//  ResetPasswordVCExt.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation
import UIKit

extension ResetPasswordViewController: ResetPasswordViewModelDelegate {
    func didReceiveResetPasswordResponse(resetResponse: ResetPasswordResponse?) {
        self.view.stopActivityIndicator()
        
        if(resetResponse?.status != nil && resetResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(resetResponse)
            
            if let message = resetResponse?.message?.firstCapitalized {
                self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                             message: message,
                                             alertStyle: .alert,
                                             actionTitles: [ConstantAlertTitle.OkAlertTitle],
                                             actionStyles: [.default],
                                             actions: [
                                                { _ in
                                                    //See navigation extension file
                                                    self.navigationController?.popToCustomViewController(viewController: LoginViewController.self)
                                                }
                                             ])
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: resetResponse?.error ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    func didReceiveResetPasswordError(statusCode: String?) {
        self.view.stopActivityIndicator()
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    
}
