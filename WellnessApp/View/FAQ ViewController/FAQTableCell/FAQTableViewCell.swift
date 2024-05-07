//
//  FAQTableViewCell.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-20.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet var viewBackground: UIView_Designable!
    @IBOutlet var lblFAQTitle: UILabel!
    @IBOutlet var lblFAQAnswer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBackground.borderColor = UIColor.colorSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateFAQTableData(cellData: FAQDetails) {
        if let title = cellData.question {
            lblFAQTitle.text = title
        }
        if let ans = cellData.answer {
            lblFAQAnswer.attributedText = ans.htmlToAttributedString
        }
    }
}
