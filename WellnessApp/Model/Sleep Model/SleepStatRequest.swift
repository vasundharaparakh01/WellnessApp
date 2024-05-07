//
//  SleepStatRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 25/02/22.
//

import Foundation

struct SleepStatRequest: Encodable {
    let startDate: String?
    let endDate: String?
    let device_cat: String?
}
