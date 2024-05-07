//
//  NotificationResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-25.
//

import Foundation

struct NotificationResponse: Decodable {
    let status: String?
    let message: String?
    let notification: [NotificationDetails]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case notification
    }
}

struct NotificationDetails: Decodable {
    let read: Int?
    let userId: String?
    let title: String?
    let message: String?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
        case read
        case userId
        case title
        case message
        case add_date
    }
}
