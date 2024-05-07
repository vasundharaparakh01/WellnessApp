//
//  SignupRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

struct SignupResquest: Encodable {
    var name, userEmail, mobileNo, password, dateOfBirth, FCMToken: String?
}
