//
//  CoachRecordedSessionResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 07/02/23.
//

import Foundation
struct CoachRecordedSessionResponse: Decodable
{
    let status: String?
    let message: String?
    let results: [CoachRecordedsessionslist]?
    
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case results
        case message
    }
}

struct CoachRecordedsessionslist: Decodable
{
    
        let _id: String?
        let coachname: String?
        let coachemail: String?
        let coachId: String?
        let coachMobileno: String?
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
        let videoLocation: String?
        let subTitle: String?
        let coachJoinedOn: String?
        let coachExitedOn: String?
        let noOfUsersJoined: Int?
    
    enum CodingKeys: String, CodingKey {
        
                case _id
                case coachname
                case coachemail
                case coachId
                case coachMobileno
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
                case videoLocation
                case sessionThumbnailLocation
                case subTitle
                case coachJoinedOn
                case coachExitedOn
                case noOfUsersJoined
}
}
