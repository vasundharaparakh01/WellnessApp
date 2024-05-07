//
//  SleepDataDeleteResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 07/03/22.
//

import Foundation

struct SleepDataDeleteResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
