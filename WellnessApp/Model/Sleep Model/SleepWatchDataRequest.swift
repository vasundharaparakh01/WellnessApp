//
//  SleepWatchDataRequest.swift
//  Luvo
//
//  Created by BEASiMAC on 21/07/22.
//

import Foundation

struct SleepWatchStatRequest: Encodable {
    let Date: String?
    let Sleep_At: String?
    let Wake_At: String?
    let Session_duration: Int?
    let Sleep_duration: Int?
    let Deep_percentage: String?
    let Light_percentage: String?
    let Awake_percentage: String?
    let Undetected_duration: String?
    let Undetected_percentage: String?
    let REM_percentage: String?
    let Deep_duration: Int?
    let Light_duration: Int?
    let Awake_duration: Int?
    let REM_duration: Int?
    let device_type: String?
    let device_cat: String?
    let result: [sleepWatchData]?
    
}
    
    struct sleepWatchData: Encodable {
        
        let start: String?
        let summary: String?
        let datapoint: Float?
        
    
   // let music: String?
}

