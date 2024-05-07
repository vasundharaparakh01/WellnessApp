//
//  FavAudioTableViewCell.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-20.
//

import UIKit

class FavAudioTableViewCell: UITableViewCell {
    
    @IBOutlet var imgBackgroundEQ: UIImageView_Designable!
    @IBOutlet var imgBackground: UIImageView_Designable!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var viewCompleted: UIView_Designable!
    @IBOutlet var lblCompleted: UILabel!
    @IBOutlet var viewLockScreen: UIView_Designable!
    @IBOutlet var imgLockScrren: UIImageView_Designable!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewCompleted.isHidden = true  //Completed will always be hidden - Client's call
        viewLockScreen.isHidden = true  //Overlay lock screen not needed for all 3 blocked chakra, manifestation, high performance as per client call
        
        imgBackgroundEQ.tintColor = UIColor.colorSetup()
        lblDuration.textColor = UIColor.colorSetup()
        viewCompleted.layer.borderColor = UIColor.colorSetup().cgColor
        lblCompleted.textColor = UIColor.colorSetup()
        viewLockScreen.layer.backgroundColor = UIColor.colorSetup().cgColor
        btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
        
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
               let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               
               print(crownList)
               print("chakra level ...--->>>",chakraLevel)
               print("coloris ...--->>>",chakraColour)
        if chakraColour==0{
        switch chakraLevel {
        case 1:
            imgLockScrren.image = UIImage(named: "lockred")
            break
            
        case 2:
            imgLockScrren.image = UIImage(named: "lockorange")
            break
            
        case 3:
            imgLockScrren.image = UIImage(named: "lockyellow")
            break
            
        case 4:
            imgLockScrren.image = UIImage(named: "lockgreen")
            break
        
        case 5:
            imgLockScrren.image = UIImage(named: "locksky")
            break
            
        case 6:
            imgLockScrren.image = UIImage(named: "lockviolet")
            break
            
        case 7:
            imgLockScrren.image = UIImage(named: "lockpurple")
            break
            
        default:
            imgLockScrren.image = UIImage(named: "lockred")
            break
        }
        }else if crownList == 1
        {
            switch chakraColour {
            case 1:
                imgLockScrren.image = UIImage(named: "lockred")
                break
                
            case 2:
                imgLockScrren.image = UIImage(named: "lockorange")
                break
                
            case 3:
                imgLockScrren.image = UIImage(named: "lockyellow")
                break
                
            case 4:
                imgLockScrren.image = UIImage(named: "lockgreen")
                break
            
            case 5:
                imgLockScrren.image = UIImage(named: "locksky")
                break
                
            case 6:
                imgLockScrren.image = UIImage(named: "lockviolet")
                break
                
            case 7:
                imgLockScrren.image = UIImage(named: "lockpurple")
                break
                
            default:
                imgLockScrren.image = UIImage(named: "lockred")
                break
            }
        }
        else
        {
            switch chakraLevel {
            case 1:
                imgLockScrren.image = UIImage(named: "lockred")
                break
                
            case 2:
                imgLockScrren.image = UIImage(named: "lockorange")
                break
                
            case 3:
                imgLockScrren.image = UIImage(named: "lockyellow")
                break
                
            case 4:
                imgLockScrren.image = UIImage(named: "lockgreen")
                break
            
            case 5:
                imgLockScrren.image = UIImage(named: "locksky")
                break
                
            case 6:
                imgLockScrren.image = UIImage(named: "lockviolet")
                break
                
            case 7:
                imgLockScrren.image = UIImage(named: "lockpurple")
                break
                
            default:
                imgLockScrren.image = UIImage(named: "lockred")
                break
            }
        }
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
    
    func updateFavAudioTableData(cellData: MeditationMusics) {
        if let imgAlbum = cellData.location {
            imgBackground.sd_setImage(with: URL(string: imgAlbum), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
        
//        if let imgAlbum = cellData.musicImg {
//            let finalImgPath = Common.WebserviceAPI.baseURL + imgAlbum
//            imgBackground.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//        }
        lblTitle.text = cellData.musicName
        lblDesc.text = cellData.description
        lblDuration.text = cellData.duration
    }
    
}
