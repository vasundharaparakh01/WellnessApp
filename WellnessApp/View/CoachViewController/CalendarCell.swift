//
//  CalendarCell.swift
//  CalendarExampleTutorial
//
//  Created by CallumHill on 14/1/21.
//

import UIKit

class CalendarCell: UICollectionViewCell
{
	@IBOutlet weak var dayOfMonth: UILabel!
    @IBOutlet weak var dayOfweek: UILabel!
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 15.0
       // self.layer.borderWidth = 5.0
      //  self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    
    
}
