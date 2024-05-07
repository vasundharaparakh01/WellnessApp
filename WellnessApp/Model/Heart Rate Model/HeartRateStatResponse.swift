//
//  HeartRateStatResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/12/21.
//

import Foundation

struct HeartRateStatResponse: Decodable {
    let status: String?
    let message: String?
    let graphRecords: [HeartRateGraph]?
    let diff: Int?
    let records: [HeartRateLatestFive]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case graphRecords
        case diff
        case records
    }
}

struct HeartRateGraph: Decodable {
//    let _id: HeartRateGraphId?
    let heart_rate: Double?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
//        case _id
        case heart_rate
        case add_date
    }
}

//struct HeartRateGraphId: Decodable {
//    let x: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case x
//    }
//}

struct HeartRateLatestFive: Decodable {
//    let _id: HeartRateLatestFiveId?
    let heart_rate: Double?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
//        case _id
        case heart_rate
        case add_date
    }
}

//struct HeartRateLatestFiveId: Decodable {
//    let x: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case x
//    }
//}
