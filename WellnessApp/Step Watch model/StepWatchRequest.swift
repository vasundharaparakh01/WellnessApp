//
//  StepWatchRequest.swift
//  Luvo
//
//  Created by BEASiMAC on 27/07/22.
//

import Foundation

struct stepWatchRequest : Encodable
{
    let results: [stepWatchData]?
    let user_id : String?
    
    
}
struct stepWatchData: Encodable {
    
    let completedTime: String
    let created_date: String
    let device_cat: String
    let device_type: String
    let miles: String
    let steps: String
    let targetTime: String
    let type: String
}
