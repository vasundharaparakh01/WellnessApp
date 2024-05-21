//
//  ImagePickerManager.swift
//  SeeMeLive
//
//  Created by Sahidul on 10/11/21.
//

import Foundation
import  UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage) -> ())?
    
    override init() {
        super.init()
    }
    
    func pickImageCamera(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ UIAlertAction in
            self.openCamera()
        }
//        let gallaryAction = UIAlertAction(title: "Gallary", style: .default){ UIAlertAction in
//            self.openGallery()
//        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
//        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func pickImageGallery(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
//        let cameraAction = UIAlertAction(title: "Camera", style: .default){ UIAlertAction in
//            self.openCamera()
//        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default){ UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        // Add the actions
        picker.delegate = self
//        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if (UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            self.viewController!.showAlert(title: "Warning", message: "You don't have camera")
        }
    }
    
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
      // For Swift 4.2
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          picker.dismiss(animated: true, completion: nil)
          picker.dismiss(animated: true) {
              guard let image = info[.originalImage] as? UIImage else {
                  fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
              }
              self.pickImageCallback?(image)
          }
      }
}
