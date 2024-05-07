//
//  AudioListenCompletedResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 01/11/21.
//

import Foundation

struct AudioListenCompletedResponse: Decodable {
    let status: String?
    let message: String?
    let detail: ListenCompleteDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct ListenCompleteDetail: Decodable {
    let userId: Int?
    let musicId: String?
    let listenMin: Int?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case musicId
        case listenMin
        case add_date
    }
}
