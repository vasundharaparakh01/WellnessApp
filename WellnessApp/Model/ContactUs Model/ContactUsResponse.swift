//
//  ContactUsResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-18.
//

import Foundation

struct ContactUsResponse: Decodable {
    let status: String?
    let message: String?
    let detail: ContactUsDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct ContactUsDetail: Decodable {
    let name: String?
    let email: String?
    let phone: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case message
    }
}
