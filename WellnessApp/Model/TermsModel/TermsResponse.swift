//
//  TermsResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-18.
//

import Foundation

struct TermsResponse: Decodable {
    let status: String?
    let cms: TermsCMS?
    
    enum CodingKeys: String, CodingKey {
        case status
        case cms
    }
}

struct TermsCMS: Decodable {
    let cmsId: String?
    let title: String?
    let alias: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case cmsId
        case title
        case alias
        case description
    }
}
