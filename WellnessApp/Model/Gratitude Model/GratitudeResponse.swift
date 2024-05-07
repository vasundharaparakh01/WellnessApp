//
//  GratitudeResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 11/10/21.
//

import Foundation

struct GratutudeGetListResponse: Decodable {
    let gratitudes: [GratitudeList]?
    let message: String?
    let status: String?
    enum CodingKeys: String, CodingKey {
        case gratitudes
        case message
        case status
    }
}

struct GratitudeList: Decodable {
    let category_name: [Category]?
    let date: String?
    let message: String?
    let userId: String?
    
    enum CodingKeys: String, CodingKey {
        case category_name
        case date
        case message
        case userId
    }
}

struct Category: Decodable {
    let categoryId: String?
    let categoryName: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryId
        case categoryName
    }
}
