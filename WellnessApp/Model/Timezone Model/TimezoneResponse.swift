//
//  TimezoneResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-19.
//

import Foundation

struct TimezoneResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
