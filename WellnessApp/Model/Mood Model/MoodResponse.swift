//
//  MoodResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-31.
//

import Foundation

struct MoodResponse: Decodable {
    let status: String?
    let message: String?
    let detail: MoodDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct MoodDetail: Decodable {
    let userId: String?
    let mood: String?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case mood
        case add_date
    }
}
