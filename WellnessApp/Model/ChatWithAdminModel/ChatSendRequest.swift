//
//  ChatSendRequest.swift
//  Luvo
//
//  Created by Sahidul on 24/12/21.
//

import Foundation
import UIKit

struct ChatSendRequest: Encodable {
    let message: String?
    let image: Data?
}
