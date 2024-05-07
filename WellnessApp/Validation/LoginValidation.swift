//
//  LoginValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

struct LoginValidation {
    func Validate(loginRequest: LoginRequest) -> ValidationResult {
        if (loginRequest.userId!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userEmailIsEmpty)
        }
        if let email = loginRequest.userId {
            if (ValidateEmail().isValidEmail(email) == false) {
                return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userEmailInvalid)
            }
        }
        if (loginRequest.password!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userPasswordIsEmpty)
        }
        
        return ValidationResult(success: true, error: nil)
    }
}
