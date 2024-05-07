//
//  WaterCupSizeValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 29/11/21.
//

import Foundation

struct WaterCupSizeValidation {
    func ValidateCupSize(waterCupSizePostRequest: WaterCupSizePostRequest) -> ValidationResult {
        if (waterCupSizePostRequest.water!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.waterCupSizeEmpty)
        }
        if (waterCupSizePostRequest.water == "0" || waterCupSizePostRequest.water == "") {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.waterCupSizeEmpty)
        }
        return ValidationResult(success: true, error: nil)
    }
}
