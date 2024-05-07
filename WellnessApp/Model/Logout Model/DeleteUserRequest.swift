//
//  DeleteUserRequest.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 08/04/23.
//

import Foundation
struct DeleteUserRequest: Encodable {
    let fcm: String?
    let isDeleted: Bool?

}
