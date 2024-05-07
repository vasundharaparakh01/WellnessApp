//
//  SignupVCExt.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation
import UIKit

extension SignUpViewController: SignupViewModelDelegate, UITextFieldDelegate {
    //MARK: - Delegate
    func didReceiveSignupError(statusCode: String?) {
        self.view.stopActivityIndicator()
        
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func didReceiveSignupResponse(signupResponse: SignupResponse?) {
        self.view.stopActivityIndicator()
        if(signupResponse?.status != nil && signupResponse?.status?.lowercased() == ConstantStatusAPI.success && signupResponse?.userDetail != nil) {
//            dump(signupResponse?.userDetail)
            
            let userDetails = SignupUserDetails(_id: signupResponse?.userDetail?._id, userId: signupResponse?.userDetail?.userId, userName: signupResponse?.userDetail?.userName, userEmail: signupResponse?.userDetail?.userEmail, mobileNo: signupResponse?.userDetail?.mobileNo, profileImg: signupResponse?.userDetail?.profileImg, otp: signupResponse?.userDetail?.otp, status: signupResponse?.userDetail?.status, chakraRes: signupResponse?.userDetail?.chakraRes, timeZone: signupResponse?.userDetail?.timeZone, location: signupResponse?.userDetail?.location)
            
            do {
                //Check Readme doc to extract data and Decode from userDefault
                let dataEncode = try JSONEncoder().encode(userDetails)
                UserDefaults.standard.set(dataEncode, forKey: ConstantUserDefaultTag.udUserDetails)
                UserDefaults.standard.set(signupResponse?.userDetail?.userId, forKey: ConstantUserDefaultTag.udUserId)
                UserDefaults.standard.set(signupResponse?.tokenValidate, forKey: ConstantUserDefaultTag.udToken)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            //Note: Remember me was done on Chakra screen (ChakraViewController)
            
            let otpVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
            otpVC.tempOTP = signupResponse?.userDetail?.otp
            self.navigationController?.pushViewController(otpVC, animated: true)
            
            //Start all time step tracking in app delegate
            (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: signupResponse?.message ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    //MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtPhoneNo) {
            if (range.location == 0 && string == " ") {
                return false
            } else if (newString.count > 10) {
                return false
            } else {
                guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return false
                }
            }
        }
        return true
    }
    
}
