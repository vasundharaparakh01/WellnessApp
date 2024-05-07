//
//  ProfileGetResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 06/10/21.
//

import Foundation

struct ProfileGetResponse: Decodable {
    let status: String?
    let result: [ProfileData]?
    let user_badges: [BadgeModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case result
        case user_badges
    }
}

struct ProfileData: Decodable {
    let dateOfBirth: String?
    let mobileNo: String?
    let profileImg: String?
    let socialId: String?
    let socialType: String?
    let userEmail: String?
    let userName: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case dateOfBirth
        case mobileNo
        case profileImg
        case socialId
        case socialType
        case userEmail
        case userName
        case location
    }
}
