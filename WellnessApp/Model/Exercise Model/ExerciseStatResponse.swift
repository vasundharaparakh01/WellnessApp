//
//  ExerciseStatResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 16/11/21.
//

import Foundation

struct ExerciseStatResponse: Decodable {
    let status: String?
    let message: String?
    let distance: [ExerciseStatDistance]?
    let diff: Int?
    let completedSteps: Int?
    let completedMiles: Double?
    let calBurns: String?
    let user_badge: [BadgeModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case distance
        case diff
        case completedSteps
        case completedMiles
        case calBurns
        case user_badge
    }
}

struct ExerciseStatDistance: Decodable {
    let _id: ExerciseStatDistanceId?
    let totalSteps: Int?
    let totalMiles: Double?
    let created_date: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case totalSteps
        case totalMiles
        case created_date
    }
}

struct ExerciseStatDistanceId: Decodable {
    let dayOfMonth: Int?
    let dayOfYear: Int?
    let year: Int?
    let month: Int?
    let hour: Int?
    let interval: Int?
    let x: Int?
    
    enum CodingKeys: String, CodingKey {
        case dayOfMonth
        case dayOfYear
        case year
        case month
        case hour
        case interval
        case x
    }
}
