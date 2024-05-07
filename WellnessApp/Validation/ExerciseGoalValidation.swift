//
//  ExerciseGoalValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 10/11/21.
//

import Foundation

struct ExerciseGoalValidation {
    func Validate(goalRequest: ExerciseGoalRequest) -> ValidationResult {
        if (goalRequest.daily_goal!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.dailyGoalEmpty)
        }
        if (goalRequest.daily_goal == "0") {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.dailyExerciseGoalZero)
        }
        return ValidationResult(success: true, error: nil)
    }
}
