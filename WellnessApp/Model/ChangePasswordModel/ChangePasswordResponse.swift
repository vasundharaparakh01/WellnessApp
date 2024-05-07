//
//  ChangePasswordResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

struct ChangePasswordResponse: Decodable {
    let status: String?
    let message: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case error
    }
}
