//
//  NavigationExtension.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation
import UIKit

extension UINavigationController {

    func popToCustomViewController(viewController: Swift.AnyClass) {

            for element in viewControllers as Array {
                if element.isKind(of: viewController) {
                    self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
