//
//  BadgeModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 05/01/22.
//

import Foundation

struct BadgeModel: Decodable {
    let badgeId: String?
    let daily_goal: Int?
    let iconImg: String?
    let title: String?
    let wins: Int?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case badgeId
        case daily_goal
        case iconImg
        case title
        case wins
        case location
    }
}
