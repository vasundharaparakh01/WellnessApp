//
//  BlogCommentSendResponse.swift
 
//
//  Created by BEASMACUSR02 on 25/12/21.
//

import Foundation

struct BlogCommentSendResponse: Decodable {
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
