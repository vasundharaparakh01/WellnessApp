//
//  UserDefaultExtension.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/11/21.
//

import Foundation

extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
