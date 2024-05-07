//
//  WaterCupSizePostResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 29/11/21.
//

import Foundation

struct WaterCupSizePostResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
