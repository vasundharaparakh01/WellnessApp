//
//  ChangePasswordValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

struct ChangePasswordValidation {
    func Validate(changePasswordRequest: ChangePasswordRequest) -> ValidationResult {
        if (changePasswordRequest.oldPasswd!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.oldPassEmpty)
        }
        if (changePasswordRequest.newPasswd!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.emptyNewPassword)
        }
        if (changePasswordRequest.confPasswd!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.emptyConfirmPassword)
        }
        if (changePasswordRequest.newPasswd != changePasswordRequest.confPasswd) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.passwordConfirmPasswordNotSame)
        }
        return ValidationResult(success: true, error: nil)
    }
}
