//
//  LoginResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

struct LoginResponse: Decodable {
    let status: String?
    let message: String?
    let userDetail: LoginUserDetails?
    let tokenValidate: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case userDetail
        case tokenValidate
    }
}

struct LoginUserDetails: Codable {
    let _id: String?
    let userId: String?
    var userName: String?
    let userEmail: String?
    let mobileNo: String?
    var profileImg: String?
    let otp: String?
    let status: String?
    let chakraRes: Int?
    let socialId: String?
    let socialType: String?
    var timeZone: String?
    var location: String?
    var type: String?
    var deleted: Bool?
    
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
        case socialId
        case socialType
        case timeZone
        case location
        case type
        case deleted
    }
}
