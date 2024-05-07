//
//  HandRaiseTableViewCell.swift
//  Luvo
//
//  Created by BEASiMAC on 12/01/23.
//

import UIKit

class HandRaiseTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgVwHandRaise: UIImageView!
    @IBOutlet weak var LblUserNameHandRaise: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
