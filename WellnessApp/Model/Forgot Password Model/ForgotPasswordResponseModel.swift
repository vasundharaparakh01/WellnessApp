//
//  ForgotPasswordResponseModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation

struct ForgotPasswordResponse: Decodable {
    let status: String?
    let message: String?
    let token: Int?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case token
        case error
    }
}
