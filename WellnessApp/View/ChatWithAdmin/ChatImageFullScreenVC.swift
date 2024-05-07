//
//  ChatImageFullScreenVC.swift
//  Luvo
//
//  Created by Sahidul on 27/12/21.
//

import UIKit

class ChatImageFullScreenVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewFullScreen: UIImageView!
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        
        if imageUrl !=  nil {
            self.imageViewFullScreen.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage.init(named: "placeholder"), options: .refreshCached, context: nil)
        }
        
//        if imageUrl !=  nil {
//            let imagePath = Common.WebserviceAPI.baseURL + imageUrl!
//            self.imageViewFullScreen.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage.init(named: "placeholder"), options: .refreshCached, context: nil)
//        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageViewFullScreen
    }
    
    @IBAction func btnCloseAction(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
