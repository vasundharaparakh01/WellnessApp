//
//  SleepResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/02/22.
//

import Foundation



struct SleepResponse: Decodable {
    let status: String?
    let message: String?
    let detail: SleepDetails?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct SleepDetails: Decodable {
    let userId: String?
    let sleep: Int?
    let music_file: String?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case sleep
        case music_file
        case date
    }
}
