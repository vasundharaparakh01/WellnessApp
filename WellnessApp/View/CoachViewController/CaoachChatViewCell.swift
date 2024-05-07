//
//  CaoachChatViewCell.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 18/03/23.
//

import UIKit

class CaoachChatViewCell: UITableViewCell {


    @IBOutlet weak var NewUserName: UILabel!
    @IBOutlet weak var NewUserTxt: UILabel!
    @IBOutlet weak var NewuserImage: UIImageView!
    @IBOutlet weak var NewuserTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
