//
//  LiveCallJoinRequest.swift
//  Luvo
//
//  Created by BEASiMAC on 27/02/23.
//

import Foundation
struct LiveCallJoinRequest:Encodable
{
    var sessionId: String?
    var callId: String?
    var callJoinedStatus: String?
    
}
