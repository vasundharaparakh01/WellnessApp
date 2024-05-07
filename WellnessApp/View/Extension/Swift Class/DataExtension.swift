//
//  DataExtension.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 07/12/21.
//

import Foundation

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print("JSON RESP --------->\(JSONString)")
        }
    }
}
