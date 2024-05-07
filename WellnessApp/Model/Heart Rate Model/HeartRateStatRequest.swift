//
//  HeartRateStatRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/12/21.
//

import Foundation

struct HeartRateStatRequest: Encodable {
    let startDate: String?
    let endDate: String?
    let device_cat: String?
}
