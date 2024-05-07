//
//  UserTableList.swift
//  Luvo
//
//  Created by BEASiMAC on 10/01/23.
//

import UIKit

class UserTableList: UITableViewCell {
    
    
    @IBOutlet weak var imgVwMute: UIImageView!
    @IBOutlet weak var imgVwDelete: UIImageView!
    @IBOutlet weak var imgVprofile: UIImageView!

    @IBOutlet weak var lblUername: UILabel!


    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMute: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
