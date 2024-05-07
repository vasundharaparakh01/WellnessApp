//
//  WaterCupSizeResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 29/11/21.
//

import Foundation

struct WaterCupSizeResponse: Decodable {
    let status: String?
    let sizes: [WaterCupSize]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case sizes
    }
}

struct WaterCupSize: Decodable {
    let size: Int?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case size
        case status
    }
}
