//
//  SleepRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/02/22.
//
//  let sleep_data: [SleepData]?

import Foundation

struct SleepRequest: Codable {
    let music: AudioUploadRequest?
    let sleep_data: SleepUploadRequest?
    let duration: Data?
    let start_time: Data?
    let end_time: Data?
}

//class AccelData: Codable {
//    let x: Double?
//    let y: Double?
//    let z: Double?
//    let time: String?
//
//    init(x: Double?, y: Double?, z: Double?, time: String?) {
//        self.x = x
//        self.y = y
//        self.z = z
//        self.time = time
//    }
//}

struct AudioUploadRequest: Codable {
    let audio: Data?
    let fileName: String?
    let fileType: String?
    let parameterName: String?
}

struct SleepUploadRequest: Codable {
    let sleepData: Data?
    let fileName: String?
    let fileType: String?
    let parameterName: String?
}

//Sync model for sending data later
class SleepAssetPath: Codable {
    let audioPath: URL?
    let sleepPath: URL?
    let duration: Data?
    let start_time: Data?
    let end_time: Data?
    
    init(audioPath: URL?, sleepPath: URL?, duration: Data?, start_time: Data?, end_time: Data?) {
        self.audioPath = audioPath
        self.sleepPath = sleepPath
        self.duration = duration
        self.start_time = start_time
        self.end_time = end_time
    }
}
