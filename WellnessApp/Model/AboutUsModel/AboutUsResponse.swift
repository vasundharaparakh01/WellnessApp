//
//  AboutUsResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

struct AboutUsResponse: Decodable {
    let status: String?
    let cms: AboutUsCMS?
    
    enum CodingKeys: String, CodingKey {
        case status
        case cms
    }
}

struct AboutUsCMS: Decodable {
    let cmsId: String?
    let title: String?
    let alias: String?
    let description: String?
    let cms_img: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case cmsId
        case title
        case alias
        case description
        case cms_img
        case location
    }
}
