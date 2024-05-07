//
//  ChatViewCell.swift
//  agora_n
//
//  Created by Nilanjan Ghosh on 08/01/23.
//

import UIKit

class ChatViewCell: UITableViewCell {

    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserTxt: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userTime: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initiali
      //  backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
