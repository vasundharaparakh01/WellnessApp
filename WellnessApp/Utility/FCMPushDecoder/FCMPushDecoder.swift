//
//  FCMPushDecoder.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-14.
//

import Foundation

struct Push: Decodable {
    let aps: APS
    
    struct APS: Decodable {
        let alert: Alert
        let badge: Int?
        
        struct Alert: Decodable {
            let title: String
            let body: String
        }
    }
    
    init(decoding userInfo: [AnyHashable : Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        self = try JSONDecoder().decode(Push.self, from: data)
    }
}
