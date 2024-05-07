//
//  ExerciseGoalResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 10/11/21.
//

import Foundation

struct ExerciseGoalResponse: Decodable {
    let status: String?
    let dailyGoal: Int?
    let message: String?
    let todaySteps: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case dailyGoal
        case message
        case todaySteps
    }
}
