//
//  ContactUsRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-18.
//

import Foundation

struct ContactUsRequest: Encodable {
    let name: String?
    let email: String?
    let phone: String?
    let message: String?
}
