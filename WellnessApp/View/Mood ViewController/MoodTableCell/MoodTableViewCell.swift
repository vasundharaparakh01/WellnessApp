//
//  MoodTableViewCell.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-31.
//

import UIKit

class MoodTableViewCell: UITableViewCell {

    @IBOutlet var viewBackground: UIView!
    @IBOutlet var imgRadio: UIImageView!
    @IBOutlet var lblMood: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBackground.layer.cornerRadius = 10.0
        viewBackground.layer.borderWidth = 1.0
        viewBackground.layer.borderColor = UIColor.gray.cgColor
        viewBackground.backgroundColor = UIColor(hexString: "#FCFCFD")
        imgRadio.tintColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
