//
//  ProfileUpdateResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 06/10/21.
//

import Foundation

struct ProfileUpdateResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
