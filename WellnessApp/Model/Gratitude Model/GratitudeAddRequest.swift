//
//  GratitudeAddRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/10/21.
//

import Foundation

struct GratitudeAddRequest: Encodable {
    let categoryId: String?
    let message: String?
}
