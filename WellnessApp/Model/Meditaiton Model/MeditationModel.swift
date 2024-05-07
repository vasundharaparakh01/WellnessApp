//
//  MeditationModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 18/10/21.
//

import Foundation

struct MeditationModel {
    let image: String
    let title: String
    let isViewBackgroundColor: Bool
    let meditationId: String?
}

struct MeditationBadgeRequest: Encodable {
    let startDate: String?
    let endDate: String?
  }

struct MeditationBadgeResponse: Decodable {
    let status: String?
    let message: String?
    let user_badges: [BadgeModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case user_badges
    }
}
