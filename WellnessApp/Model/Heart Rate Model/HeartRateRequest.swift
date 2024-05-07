//
//  HeartRateRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/12/21.
//

import Foundation

struct HeartRateRequest: Encodable {
    let min: String?
    let max: String?
    let avg: String?
}
