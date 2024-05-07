//
//  ChatWithAdminTableViewCell.swift
//  Luvo
//
//  Created by Sahidul on 23/12/21.
//

import UIKit

class ChatWithAdminTableViewCell: UITableViewCell {

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
        viewBubble.layer.cornerRadius = 13
        viewBubble.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updtaeSendTableCellData(cellData: Message) {
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
