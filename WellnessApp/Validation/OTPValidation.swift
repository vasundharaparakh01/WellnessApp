//
//  OTPValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 14/09/21.
//

import Foundation

struct OTPValidation {
    func Validate(otp1: String?, otp2: String?, otp3: String?, otp4: String?) -> ValidationResult {
        if (otp1!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.otp1stIsEmpty)
        }
        if (otp2!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.otp2ndIsEmpty)
        }
        if (otp3!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.otp3rdIsEmpty)
        }
        if (otp4!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.otp4thIsEmpty)
        }
        return ValidationResult(success: true, error: nil)
    }
}
