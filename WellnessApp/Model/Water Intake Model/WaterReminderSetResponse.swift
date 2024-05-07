//
//  WaterReminderSetResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 30/11/21.
//

import Foundation

struct WaterReminderSetResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
