//
//  TextViewValidation.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-19.
//

import Foundation
import UIKit

func ValidateTextView(textView: UITextView) -> Bool {
    guard let text = textView.text,
        !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
        // this will be reached if the text is nil (unlikely)
        // or if the text only contains white spaces
        // or no text at all
        return false
    }

    return true
}
