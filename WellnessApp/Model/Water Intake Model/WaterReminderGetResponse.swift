//
//  WaterReminderGetResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 30/11/21.
//

import Foundation

struct WaterReminderGetResponse: Decodable {
    let status: String?
    let reminder: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case reminder
    }
}
