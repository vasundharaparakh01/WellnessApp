//
//  ExerciseFinishResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/11/21.
//

import Foundation

struct ExerciseFinishResponse: Decodable {
    let status: String?
    let message: String?
    let detail: ExerciseFinishDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct ExerciseFinishDetail: Decodable {
    let userId: String?
    let steps: Int?
    let type: String?
    let miles: Double?
    let date: String?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case steps
        case type
        case miles
        case date
        case time
    }
}
