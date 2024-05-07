//
//  UserCallListResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 05/01/23.
//

import Foundation

struct UserCallListResponse: Decodable
{
    let status: String?
    let message: String?
    let sessionCallDetails: [UserVideoCallList]?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case sessionCallDetails
   }
}

struct UserVideoCallList: Decodable
{
    let sessionName: String?
    let _id: String?
    let coachname: String?
    let coachemail: String?
    let coachId: String?
   // let coachMobileno: String?
    let sessionStarttime: String?
    let sessionEndtime: String?
    let subTitle: String?
    let ctgryId: String?
    let agoraAccessToken: String?
    let agoraAppId: String?
    let agoraSId: String?
    let agoraResourceId: String?
    let channelName: String?
    let sessionThumbnailLocation: String?
    let callId: String?
    let callStartedOn: String?
    let agoraUId: String?
    let callStatus: String?
    
//        let _id: String?
//        let sessionId: String?
//    let callStartedBy: String?
//    let callStartedOn: String?
//    let callEndedOn: String?
//    let callStatus: String?
//    let date: String?
//    let agoraUId: String?
//    let liveSessionCalls: liveSessionCallsData?
//
    enum CodingKeys: String, CodingKey {
        
        case sessionName
        case _id
        case coachname
        case coachemail
        case coachId
       // case coachMobileno
        case sessionEndtime
        case sessionStarttime
        case subTitle
        case ctgryId
        case agoraAccessToken
        case agoraAppId
        case agoraSId
        case agoraResourceId
        case channelName
        case sessionThumbnailLocation
        case callId
        case callStartedOn
        case agoraUId
        case callStatus
        
//        case _id
//        case sessionId
//        case callStartedBy
//        case callStartedOn
//        case callEndedOn
//        case callStatus
//        case date
//        case agoraUId
//        case liveSessionCalls
        
    }
}

//struct liveSessionCallsData: Decodable
//{
//    let _id: String?
//    let joinedBy: String?
//    let joinedOn: String?
//    let sessionId: String?
//    let joiningTime: String?
//    let exitTime: String?
//    let joiningStatus: String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case _id
//        case joinedBy
//        case joinedOn
//        case sessionId
//        case joiningTime
//        case exitTime
//        case joiningStatus
//    }
//}
