//
//  BGStepUpdateResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/11/21.
//

import Foundation

struct BGStepUpdateResponse: Decodable {
    let status: String?
    let message: String?
    let detail: BGStepDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct BGStepDetail: Decodable {
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
