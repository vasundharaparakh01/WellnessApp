//
//  ProfileImageResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 07/10/21.
//

import Foundation

struct ProfileImageResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
