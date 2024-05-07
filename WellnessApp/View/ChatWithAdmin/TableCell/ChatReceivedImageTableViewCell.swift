//
//  ChatReceivedImageTableViewCell.swift
//  Luvo
//
//  Created by Sahidul on 25/12/21.
//

import UIKit

class ChatReceivedImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageReceive: UIImageView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lebelReadTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageUser.layer.cornerRadius = imageUser.frame.height / 2
        imageReceive.layer.cornerRadius = 13
        imageReceive.layer.borderWidth = 2
        imageReceive.layer.borderColor = UIColor.colorSetup().cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updtaeReceivedImageTableCellData(cellData: Message) {
        if let profileImg = cellData.sender?[0].location {
            self.imageUser.sd_setImage(with: URL(string: profileImg), placeholderImage: UIImage.init(named: "chat"), options: .refreshCached, context: nil)
        }
        
        if let images = cellData.location {
            self.imageReceive.sd_setImage(with: URL(string: images), placeholderImage: UIImage.init(named: "placeholder"), options: .refreshCached, context: nil)
        }
        
//        if let profileImg = cellData.sender?[0].profileImg {
//            let imagePath = Common.WebserviceAPI.baseURL + profileImg
//            self.imageUser.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage.init(named: "chat"), options: .refreshCached, context: nil)
//        }
//
//        if let images = cellData.thumbImg {
//            let imagePath = Common.WebserviceAPI.baseURL + images
//            self.imageReceive.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage.init(named: "placeholder"), options: .refreshCached, context: nil)
//        }
    }
    
}
