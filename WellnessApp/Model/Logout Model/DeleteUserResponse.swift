//
//  DeleteUserResponse.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 08/04/23.
//

import Foundation
struct DeleteUserResponse : Decodable
{

    let status: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
