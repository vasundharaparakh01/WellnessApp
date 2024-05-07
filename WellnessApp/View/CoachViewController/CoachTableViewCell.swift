//
//  CoachTableViewCell.swift
//  Luvo
//
//  Created by BEASiMAC on 17/11/22.
//

import UIKit

class CoachTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var sessionTimeDuration: UILabel!
    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var lblCatagory: UILabel!
    @IBOutlet weak var btnStart: UIBUtton_Designable!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 15.0
              //  self.layer.borderWidth = 5.0
                self.layer.borderColor = UIColor.white.cgColor
                self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
