//
//  GratitudeValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 16/10/21.
//

import Foundation

struct GratitudeValidation {
    func Validate(gratitudeAddRequest: GratitudeAddRequest) -> ValidationResult {
        if (gratitudeAddRequest.message == nil) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.gratitudeOtherEmpty)
        }
        return ValidationResult(success: true, error: nil)
    }
}
