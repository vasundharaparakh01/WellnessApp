//
//  SettingNotificationGetResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

struct SettingNotificationGetResponse: Decodable {
    let status: String?
    let settings: [NotificationSetting]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case settings
    }
}

struct NotificationSetting: Decodable {
    let step_notification: Int?
    let water_notification: Int?
    let voice_type: String?
    let userId: String?
    
    enum CodingKeys: String, CodingKey {
        case step_notification
        case water_notification
        case voice_type
        case userId
    }
}
