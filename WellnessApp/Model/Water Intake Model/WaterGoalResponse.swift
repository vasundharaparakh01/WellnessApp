//
//  WaterGoalResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/11/21.
//

import Foundation

struct WaterGoalResponse: Decodable {
    let status: String?
    let dailyWater: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case dailyWater
        case message
    }
}
