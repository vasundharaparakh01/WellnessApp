//
//  ChakraDisplayResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/09/21.
//

import Foundation

struct ChakraDisplayResponse: Decodable {
    let status: String?
    let result: [ChakraDisplayResult]?
    let current_level: Int?
    let level_chakra: String?
    let prev_level: Int?
    let prev_chakra: String?
    let current_chakraId: String?
    let default_exercise: ChakraDefaultExercise?
    let chakra_color: Int?
    let crownListen: Int?
    var isLive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case status
        case result
        case current_level
        case level_chakra
        case prev_level
        case prev_chakra
        case current_chakraId
        case default_exercise
        case chakra_color
        case crownListen
        case isLive
        
    }
}

struct ChakraDisplayResult: Decodable {
    let chakraId: String?
    let chakraName: String?
    let questionId: [String]?
    let answerId: [String]?
    let answer: [String]?
    let orders: Int?
    let chakra_level: String?
    
    enum CodingKeys: String, CodingKey {
        case chakraId
        case chakraName
        case questionId
        case answerId
        case answer
        case orders
        case chakra_level
    }
}

struct ChakraDefaultExercise: Decodable {
    let exerciseId: String?
    let name: String?
    let exercise_img: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case exerciseId
        case name
        case exercise_img
        case location
    }
}
