//
//  ChangePasswordRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

struct ChangePasswordRequest: Encodable {
    let oldPasswd, newPasswd, confPasswd: String?
}
