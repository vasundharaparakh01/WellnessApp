//
//  HeartRateResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/12/21.
//

import Foundation

struct HeartRateResponse: Decodable {
    let status: String?
    let message: String?
//    let detail: HeartRateDetails?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}

//struct HeartRateDetails: Decodable {
//    let userId: String?
//    let min: Int?
//    let max: Int?
//    let avg: Float?
//    let add_date: String?
//}
