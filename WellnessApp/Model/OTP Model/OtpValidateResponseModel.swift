//
//  OtpValidateResponseModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 16/09/21.
//

import Foundation

struct ValidateOtpResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
