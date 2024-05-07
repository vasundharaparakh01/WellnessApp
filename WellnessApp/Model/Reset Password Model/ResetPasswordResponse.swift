//
//  ResetPasswordResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation

struct ResetPasswordResponse: Decodable {
    let status: String?
    let message: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case error
    }
}
