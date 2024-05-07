//
//  AudioListen5minResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 01/11/21.
//

import Foundation

struct AudioListen5minResponse: Decodable {
    let status: String?
    let message: String?
    let detail: ListenFiveMinCompleteDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct ListenFiveMinCompleteDetail: Decodable {
    let userId: Int?
    let musicId: String?
    let listenMin: Int?
    let add_date: String?
    let listen_date: String?
    let listen_time: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case musicId
        case listenMin
        case add_date
        case listen_date
        case listen_time
    }
}
