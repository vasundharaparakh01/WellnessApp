//
//  OtpResendResponseModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 14/09/21.
//

import Foundation

struct OtpResendResponse: Decodable {
    let status: String?
    let message: String?
    let otp: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case otp
    }
}
