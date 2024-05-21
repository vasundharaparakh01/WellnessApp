//
//  TimeTrackingResponse.swift
 
//
//  Created by BEASMACUSR02 on 2022-01-22.
//

import Foundation

struct TimeTrackingResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
