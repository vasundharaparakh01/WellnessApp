//
//  WaterStatResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/11/21.
//

import Foundation

struct WaterStatResponse: Decodable {
    let status: String?
    let message: String?
    let graphRecords: [WaterStatGraph]?
    let diff: Int?
    let records: [WaterStatLatestFive]?
    let target: Int?
    let achived: Int?
    let reminder: Int?
    let user_badges: [BadgeModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case graphRecords
        case diff
        case records
        case target
        case achived
        case reminder
        case user_badges
    }
}

struct WaterStatGraph: Decodable {
    let _id: WaterStatGraphId?
    let totalWater: Int?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case totalWater
        case add_date
    }
}

struct WaterStatGraphId: Decodable {
    let x: Int?
    
    enum CodingKeys: String, CodingKey {
        case x
    }
}

struct WaterStatLatestFive: Decodable {
//    let _id: WaterStatLatestFiveId?
    let totalWater: Int?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
//        case _id
        case totalWater
        case add_date
    }
}

//struct WaterStatLatestFiveId: Decodable {
//    let x: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case x
//    }
//}
