//
//  LoginRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

struct LoginRequest: Encodable {
    var userId, password, FCMToken: String?
}
