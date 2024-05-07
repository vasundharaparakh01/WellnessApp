//
//  ResetPasswordValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation

struct ResetPasswordValidation {
    func Validate(resetPasswordRequest: ResetPasswordResquest) -> ValidationResult {
        if (resetPasswordRequest.resetToken!.isEmpty) {
            return ValidationResult(success: false, error: "Reset token is empty")
        }
        if (resetPasswordRequest.password!.isEmpty) {
            return ValidationResult(success: false, error: "Password is empty")
        }        
        return ValidationResult(success: true, error: nil)
    }
}
