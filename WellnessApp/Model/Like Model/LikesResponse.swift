//
//  LikesResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/12/21.
//

import Foundation

struct LikesResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
