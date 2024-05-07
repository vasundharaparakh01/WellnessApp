//
//  CoachViewStatusRequest.swift
//  Luvo
//
//  Created by BEASiMAC on 14/12/22.
//

import Foundation

struct CoachViewStatusRequest: Encodable
{
    var status : String?
    var sessId : String?
    var agoraSId : String?
    var coachId : String?
    var ctgryId : String?
    var agoraResourceId : String?
    var agoraAccessToken : String?
    var channelName : String?
    
    
}
