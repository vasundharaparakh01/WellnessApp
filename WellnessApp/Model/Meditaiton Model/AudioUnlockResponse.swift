//
//  AudioUnlockResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 04/12/21.
//

import Foundation

struct AudioUnlockResponse: Decodable {
    let status: String?
    let message: String?
    let detail: AudioUnlockDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct AudioUnlockDetail: Decodable {
    let userId: Int?
    let musicId: String?
    let points: Int?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case musicId
        case points
        case add_date
    }
}
