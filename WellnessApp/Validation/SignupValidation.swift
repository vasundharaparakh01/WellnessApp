//
//  SignupValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

struct SignupValidation {
    func Validate(signupRequest: SignupResquest) -> ValidationResult {
        if (signupRequest.name!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userNameIsEmpty)
        }
        if (signupRequest.userEmail!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userEmailIsEmpty)
        }
        if let email = signupRequest.userEmail {
            if (ValidateEmail().isValidEmail(email) == false) {
                return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userEmailInvalid)
            }
        }
        if (signupRequest.password!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userPasswordIsEmpty)
        }
        if (signupRequest.mobileNo!.isEmpty) {
            //return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userPhoneIsEmpty)
        }
        if let phone = signupRequest.mobileNo {
            if (phone.count == 1 || phone.count == 2 || phone.count == 3 || phone.count == 4 || phone.count == 5 || phone.count == 6 || phone.count == 7 || phone.count == 8 || phone.count == 9) {
                return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.phoneValidation)
            }
        }
        return ValidationResult(success: true, error: nil)
    }
}
