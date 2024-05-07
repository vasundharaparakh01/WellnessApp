//
//  LiveSessionListViewCell.swift
//  Luvo
//
//  Created by BEASiMAC on 07/12/22.
//

import UIKit

class LiveSessionListViewCell: UITableViewCell {

    @IBOutlet weak var ivgVW: UIImageView!
    @IBOutlet weak var imgVwCalednder: UIImageView!
    @IBOutlet weak var imgVwClock: UIImageView!
    @IBOutlet weak var imgVwSubtitle: UIImageView!
    
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblSessionname: UILabel!
    @IBOutlet weak var lblSessionDuration: UILabel!
    @IBOutlet weak var lblsessionDate: UILabel!
    @IBOutlet weak var LblCoachName: UILabel!
    @IBOutlet weak var Imgthumbnail: UIImageView!
    @IBOutlet weak var imgViewLive: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
