//
//  ProfileValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 06/10/21.
//

import Foundation

struct ProfileValidation {
    func Validate(profileRequest: ProfileUpdateRequest) -> ValidationResult {
        if (profileRequest.userName!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userNameIsEmpty)
        }
        if (profileRequest.mobileNo!.isEmpty) {
           // return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.userPhoneIsEmpty)
        }
        return ValidationResult(success: true, error: nil)
    }
}
