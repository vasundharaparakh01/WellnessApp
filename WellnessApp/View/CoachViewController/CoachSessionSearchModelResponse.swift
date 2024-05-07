//
//  CoachSessionSearchModelResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 17/01/23.
//

import Foundation

struct CoachSessionSearchModelResponse : Decodable
{
    let status : String?
    let sessionList : [SearchData]?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case sessionList
        
    }
}

struct SearchData: Decodable
{
    let _id: String?
    let sessionName: String?
    let sessionStarttime: String?
    let sessionEndtime: String?
    let assignOn: String?
    let ctgryId: String?
    let agoraAccessToken: String?
    let agoraAppId: String?
    let chennelName: String?
    
    enum CodingKeys: String, CodingKey
    {
        case _id
        case sessionName
        case sessionStarttime
        case sessionEndtime
        case assignOn
        case ctgryId
        case agoraAccessToken
        case agoraAppId
        case chennelName
    }
    
}
