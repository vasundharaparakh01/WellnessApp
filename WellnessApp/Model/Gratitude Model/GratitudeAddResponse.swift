//
//  GratitudeAddResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/10/21.
//

import Foundation

struct GratitudeAddResponse: Decodable {
    let status: String?
    let message: String?
    let detail: GratitudeAddDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct GratitudeAddDetail: Decodable {
    let _id: String?
    let userId: String?
    let categoryId: String?
    let message: String?
    let date: String?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case userId
        case categoryId
        case message
        case date
        case time
    }
}
