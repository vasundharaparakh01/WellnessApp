//
//  MoodValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-31.
//

import Foundation

struct MoodValidation {
    func Validate(moodRequest: MoodRequest) -> ValidationResult {
        if (moodRequest.mood!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.moodEmpty)
        }
        return ValidationResult(success: true, error: nil)
    }
}
