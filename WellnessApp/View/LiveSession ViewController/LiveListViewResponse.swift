//
//  LiveListViewResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 09/12/22.
//

import Foundation

struct LiveListViewResponse: Decodable
{
    let status: String?
    let sessionList: [CoachData]?
    
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case sessionList
    }
    
}

struct CoachData: Decodable
{
    let _id: String?
    let coachname: String?
    let coachemail: String?
    let coachId: String?
  //  let coachMobileno: Int?
    let timeZone: String?
    let assignBy: String?
    let sessionName: String?
    let sessionStarttime: String?
    let sessionEndtime: String?
    let assignOn: String?
    let ctgryId: String?
    let agoraAccessToken: String?
    let agoraAppId: String?
    let channelName: String?
    let sessionStatus: String?
    let sessionThumbnail: String?
    let sessionThumbnailLocation: String?
    let subTitle: String?
    let coachProfileImage: String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id
        case coachname
        case coachemail
        case coachId
     //   case coachMobileno
        case timeZone
        case assignBy
        case sessionName
        case sessionStarttime
        case sessionEndtime
        case assignOn
        case ctgryId
        case agoraAccessToken
        case agoraAppId
        case channelName
        case sessionStatus
        case sessionThumbnail
        case sessionThumbnailLocation
        case subTitle
        case coachProfileImage
        
    }
    
    
}
