//
//  LiveJoinResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 10/12/22.
//

import Foundation

struct LiveJoinResponse: Decodable
{
    
    let status: String?
    let joinedsessionsdetails: LiveDetails?
    
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case joinedsessionsdetails
    }
    
    
}

struct LiveDetails: Decodable
{
    let _id: String?
    let joinedBy: String?
    let joinedOn: String?
    let sessionId: String?
    let joiningTime: String?
    let exitTime: String?
    let joiningStatus: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        
        case _id
        case joinedBy
        case joinedOn
        case sessionId
        case joiningTime
        case exitTime
        case joiningStatus
        
    }
    
    
}
