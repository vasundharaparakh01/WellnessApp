//
//  WaterGoalValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/11/21.
//

import Foundation

struct WaterGoalValidation {
    func Validate(goalRequest: WaterGoalRequest) -> ValidationResult {
        if (goalRequest.daily_water == 0) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.dailyWaterGoalEmpty)
        }
        return ValidationResult(success: true, error: nil)
    }
}
