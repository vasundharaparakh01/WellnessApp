//
//  ChatReceiveTableViewCell.swift
//  Luvo
//
//  Created by Sahidul on 25/12/21.
//

import UIKit

class ChatReceiveTableViewCell: UITableViewCell {

    @IBOutlet weak var userButtonIMage: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var lebelReadTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userButtonIMage.backgroundColor = UIColor.colorSetup()
        userButtonIMage.layer.cornerRadius = userButtonIMage.frame.height / 2
        userImage.layer.cornerRadius = userImage.frame.height / 2
        viewBubble.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updtaeReceivedTableCellData(cellData: Message) {
        self.labelMessage.text = cellData.message
        if let profileImg = cellData.sender?[0].location {
            self.userImage.sd_setImage(with: URL(string: profileImg), placeholderImage: UIImage.init(named: "chat"), options: .refreshCached, context: nil)
        }
        
//        if let profileImg = cellData.sender?[0].profileImg {
//            let imagePath = Common.WebserviceAPI.baseURL + profileImg
//            self.userImage.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage.init(named: "chat"), options: .refreshCached, context: nil)
//        }
    }
}
