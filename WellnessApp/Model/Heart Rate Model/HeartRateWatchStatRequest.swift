//
//  HeartRateWatchStatRequest.swift
//  Luvo
//
//  Created by BEASiMAC on 12/08/22.
//

import Foundation


struct HeartRateWatchStatRequest: Encodable
{
    let min: String?
    let max: String?
    let avg: String?
    let device_cat: String?
    let device_type: String?
    let add_date: String?
    
}
