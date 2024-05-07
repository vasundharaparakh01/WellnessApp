//
//  LogoutResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-18.
//

import Foundation

struct LogoutResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
