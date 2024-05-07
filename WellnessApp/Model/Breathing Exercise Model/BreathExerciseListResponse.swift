//
//  BreathExerciseListResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/10/21.
//

import Foundation

struct BreathExerciseListResponse: Decodable {
    let exercises: [BreathExerciseList]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case exercises
        case status
    }
}

struct BreathExerciseList: Decodable {
    let add_date: String?
    let description: String?
    let exerciseId: String?
    let exercise_img: String?
    let name: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case add_date
        case description
        case exerciseId
        case exercise_img
        case name
        case location
    }
}
