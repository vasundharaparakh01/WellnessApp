//
//  SleepStatResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 25/02/22.
//

import Foundation

struct SleepStatResponse: Decodable {
    let status: String?
    let report: SleepReport?
    
    enum CodingKeys: String, CodingKey {
        case status
        case report
    }
}

struct SleepReport: Decodable {
    let userId: String?
    let Date: String?
    let Sleep_At: String?
    let Wake_At: String?
    let Session_duration: Int?
    let Sleep_duration: Int?
    let Deep_percentage: String?
    let Light_percentage: String?
    let Awake_percentage: String?
    let Undetected_duration: Int?
    let Undetected_percentage: String?
    let REM_percentage: String?
    let Deep_duration: Int?
    let Light_duration: Int?
    let Awake_duration: Int?
    let REM_duration: Int?
    let result: [SleepChartData]?
    let music_file: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case Date
        case Sleep_At
        case Wake_At
        case Session_duration
        case Sleep_duration
        case Deep_percentage
        case Light_percentage
        case Awake_percentage
        case Undetected_duration
        case Undetected_percentage
        case REM_percentage
        case Deep_duration
        case Light_duration
        case Awake_duration
        case REM_duration
        case result
        case music_file
    }
}

struct SleepChartData: Decodable {
    let start: String?
    let summary: String?
    let datapoint: Float?
    
    enum CodingKeys: String, CodingKey {
        case start
        case summary
        case datapoint
    }
}
