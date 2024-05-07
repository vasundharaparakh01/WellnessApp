//
//  SocialLoginRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 17/09/21.
//

import Foundation

struct SocialLoginRequest: Codable {
    var name, userEmail, socialId, socialType, profileImg, FCMToken: String?
}
