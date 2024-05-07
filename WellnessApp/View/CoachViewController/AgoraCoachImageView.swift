//
//  AgoraCoachImageView.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 08/01/23.
//

import UIKit

class AgoraCoachImageView: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
//    override func awakeFromNib() {
//        imgView.layer.cornerRadius = 5
//        imgView.clipsToBounds = true
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        imgView.layer.cornerRadius = imgView.frame.height/2
    }
}
