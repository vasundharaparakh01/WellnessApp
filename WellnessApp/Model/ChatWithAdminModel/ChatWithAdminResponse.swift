//
//  ChatWithAdminResponse.swift
//  Luvo
//
//  Created by Sahidul on 24/12/21.
//


import Foundation

// MARK: - VideoCommentsDataModel
struct ChatWithAdminResponse: Decodable {
    let status: String?
    let messages: [Message]?
}

// MARK: - Message
struct Message: Decodable {
    let id, senderID, receiverID, image, location: String?
    let thumbImg, message, addDate: String?
    let receiver, sender: [Receiver]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case senderID = "senderId"
        case receiverID = "receiverId"
        case image
        case location
        case thumbImg = "thumb_img"
        case message
        case addDate = "add_date"
        case receiver, sender
    }
}

// MARK: - Receiver
struct Receiver: Decodable {
    let userName: String?
    let profileImg: String?
    let location: String?
}

enum CodingKeys: String, CodingKey {
    case userName, profileImg, location
}
