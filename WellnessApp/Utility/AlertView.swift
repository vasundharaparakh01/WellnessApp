//
//  AlertView.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 14/09/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Global Alert
    // Define Your number of buttons, styles and completion
    public func openAlertWithButtonFunc(title: String,
                                        message: String,
                                        alertStyle:UIAlertController.Style,
                                        actionTitles:[String],
                                        actionStyles:[UIAlertAction.Style],
                                        actions: [((UIAlertAction) -> Void)]){
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
            for(index, indexTitle) in actionTitles.enumerated(){
                let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
                alertController.addAction(action)
            }
            
            /*If you want work actionsheet on ipad
             then you have to use popoverPresentationController to present the actionsheet,
             otherwise app will crash on iPad */
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alertController.popoverPresentationController?.sourceView = self.view
                alertController.popoverPresentationController?.sourceRect = self.view.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
            }
            
            self.present(alertController, animated: true)
        }
    }
    
    public func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: ConstantAlertTitle.OkAlertTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
