//
//  FavVideoTableViewCell.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-20.
//

import UIKit

class FavVideoTableViewCell: UITableViewCell {
    
    @IBOutlet var imgBackground: UIImageView_Designable!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var viewDuration: UIView_Designable!
    @IBOutlet var lblDuration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewDuration.backgroundColor = UIColor.colorSetup()
        btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
    }
    
    //create your closure here
    var btnFavClick : (() -> ()) = {}
    
    @IBAction func buttonAction(_ sender: UIButton) {
        //Call your closure here
        btnFavClick()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateFavVideoTableData(cellData: SoothingVideosList) {
        if let imgAlbum = cellData.location {
            imgBackground.sd_setImage(with: URL(string: imgAlbum), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
//        if let imgAlbum = cellData.musicImg {
//            let finalImgPath = Common.WebserviceAPI.baseURL + imgAlbum
//            imgBackground.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//        }
        lblTitle.text = cellData.musicName
        if let desc = cellData.description {
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let atrText = NSMutableAttributedString(string:desc.htmlToString, attributes:attrs)
            lblDesc.attributedText = atrText
        }
        lblDuration.text = cellData.duration
    }
}
