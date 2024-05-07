//
//  ResetPasswordRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation

struct ResetPasswordResquest: Encodable {
    var resetToken, password: String?
}
