//
//  ForgotPasswordValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation

struct ForgotPasswordValidation {
    func Validate(forgotPasswordRequest: ForgotPasswordResquest) -> ValidationResult {
        if (forgotPasswordRequest.userEmail!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.enterEmail)
        }
        return ValidationResult(success: true, error: nil)
    }
}
