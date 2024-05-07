//
//  SignupResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

struct SignupResponse: Decodable {
    let status: String?
    let message: String?
    let userDetail: SignupUserDetails?
    let tokenValidate: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case userDetail
        case tokenValidate
    }
}

struct SignupUserDetails: Codable {
    let _id: String?
    let userId: String?
    let userName: String?
    let userEmail: String?
    let mobileNo: String?
    let profileImg: String?
    let otp: String?
    let status: String?
    let chakraRes: Int?
    let timeZone: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case userId
        case userName
        case userEmail
        case mobileNo
        case profileImg
        case otp
        case status
        case chakraRes
        case timeZone
        case location
    }
}
