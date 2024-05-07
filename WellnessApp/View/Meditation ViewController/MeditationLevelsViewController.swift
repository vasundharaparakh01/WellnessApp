//
//  MeditationLevelsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 18/10/21.
//

import UIKit

fileprivate struct LevelModel {
    let image: String
    let backgroundColor: UIColor
    let active: Bool
}

class MeditationLevelCell: UITableViewCell {
    @IBOutlet var cellViewBackground: UIView_Designable!
    @IBOutlet var cellImgChakra: UIImageView!
    @IBOutlet var cellLblChakraTitle: UILabel!
    @IBOutlet var cellLblChakraDesc: UILabel!
    @IBOutlet var cellViewTotal1: UIView_Designable!
    @IBOutlet var cellViewTotal2: UIView_Designable!
    @IBOutlet var cellLblTotal1: UILabel!
    @IBOutlet var cellLblTotal2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImgChakra.layer.cornerRadius = cellImgChakra.frame.size.width / 2
        cellImgChakra.layer.masksToBounds = false
        cellImgChakra.clipsToBounds = true
    }
}

class MeditationLevelsViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var tblChakraLevel: UITableView!
    
    var meditationAudioRequestData: MeditationAudioRequest?
    var meditationViewModel = MeditationLevelViewModel()
    var arrayMeditationChakra = [MeditationLevelChakras]()
    fileprivate var arrayImage = [LevelModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        meditationViewModel.delegate = self

        setupImageData()
        getMeditationLevelData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
    
    //MARK: - Setup Custom Navbar
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: - Nav Button Func
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    func setupImageData() {
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               print(crownList)
               print("chakra level ...--->>>",chakraLevel)
               print("coloris ...--->>>",chakraColour)

        if chakraColour == 0{
        switch chakraLevel {
        case 1:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "sacralBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 2:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 3:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 4:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 5:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 6:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.purple), active: true))
            arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 7:
            arrayImage.append(LevelModel(image: "crownC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.violet), active: true))
            arrayImage.append(LevelModel(image: "thirdeyeC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.purple), active: true))
            arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
            
        default:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "sacralBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        }
        }
        else if crownList == 1 {
        switch chakraColour {
        case 1:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "sacralBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 2:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 3:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 4:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 5:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 6:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.purple), active: true))
            arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        case 7:
            arrayImage.append(LevelModel(image: "crownC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.violet), active: true))
            arrayImage.append(LevelModel(image: "thirdeyeC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.purple), active: true))
            arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
            arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
            arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
            arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
            
        default:
            arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "sacralBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
            arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
            break
        }

        }else
        {
            switch chakraLevel {
            case 1:
                arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "sacralBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
            case 2:
                arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
            case 3:
                arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
                arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
            case 4:
                arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
                arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
                arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
            case 5:
                arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
                arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
                arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
                arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
            case 6:
                arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "thirdeyeC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.purple), active: true))
                arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
                arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
                arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
                arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
            case 7:
                arrayImage.append(LevelModel(image: "crownC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.violet), active: true))
                arrayImage.append(LevelModel(image: "thirdeyeC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.purple), active: true))
                arrayImage.append(LevelModel(image: "throatC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.blue), active: true))
                arrayImage.append(LevelModel(image: "heartC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.green), active: true))
                arrayImage.append(LevelModel(image: "solarC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.yellow), active: true))
                arrayImage.append(LevelModel(image: "sacralC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.orange), active: true))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
                
            default:
                arrayImage.append(LevelModel(image: "crownBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "thirdeyeBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "throatBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "heartBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "solarBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "sacralBW", backgroundColor: UIColor(hexString: "#AFAFAF"), active: false))
                arrayImage.append(LevelModel(image: "rootC", backgroundColor: UIColor(hexString: ConstantThemeSolidColor.red), active: true))
                break
            }
        }
//        if chakraLevel == 7 {
//
//        } else if chakraLevel == 6 {
//
//        } else if chakraLevel == 5 {
//
//        } else if chakraLevel == 4 {
//
//        } else if chakraLevel == 3 {
//
//        } else if chakraLevel == 2 {
//
//        } else if chakraLevel == 1 {
//
//        }
    }
    
    func getMeditationLevelData() {
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationViewModel.getMeditationLevelDetails(token: token)
        }
    }
    
    //MARK: -----Notification Setup
    @objc func setupNotificationBadge() {
        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }
        
        if badgeCount != 0 {
            viewNotificationCount.isHidden = false
            lblNotificationLabel.text = "\(badgeCount)"
        } else {
            viewNotificationCount.isHidden = true
            lblNotificationLabel.text = "0"
        }
        print("BADGE COUNT-----\(badgeCount)")
    }
}

extension MeditationLevelsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMeditationChakra.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeditationLevelCell", for: indexPath) as! MeditationLevelCell
        
        cell.cellImgChakra.image = UIImage.init(named: arrayImage[indexPath.row].image)
        cell.cellViewBackground.backgroundColor = arrayImage[indexPath.row].backgroundColor
        cell.cellLblChakraTitle.text = arrayMeditationChakra[indexPath.row].chakraName
        cell.cellLblChakraDesc.text = arrayMeditationChakra[indexPath.row].description
        
        if let totalAudio = arrayMeditationChakra[indexPath.row].audios {
            cell.cellLblTotal1.text = "Total Audio: \(totalAudio.count)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayImage[indexPath.row].active == true {
//            guard let defaultExerciseID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultExerciseID) else { return }
//            guard let defaultExerciseName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultExerciseName) else { return }
            
            meditationAudioRequestData?.chakraId = arrayMeditationChakra[indexPath.row].chakraId
            meditationAudioRequestData?.chakraName = arrayMeditationChakra[indexPath.row].chakraName
//            meditationAudioRequestData?.exerciseId = defaultExerciseID as? String
//            meditationAudioRequestData?.exerciseName = defaultExerciseName as? String
            PushToVc(index: indexPath.row)
        }
    }
    
    func PushToVc(index: Int) {
        let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
        exerciseTimeVC.hideSkipBtn = false
        exerciseTimeVC.meditationAudioRequestData = meditationAudioRequestData
        navigationController?.pushViewController(exerciseTimeVC, animated: true)
    }
        
            //red
//            viewTopBack.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            //orange
//            viewTopBack.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            //yellow
//            viewTopBack.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            //green
//            viewTopBack.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            //blue
//            viewTopBack.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            //violet
//            viewTopBack.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            //purple
//            viewTopBack.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
}

extension MeditationLevelsViewController: MeditationLevelViewModelDelegate {
    func didReceiveMeditationLevelDataResponse(meditationLevelDataResponse: MeditationLevelResponse?) {
        self.view.stopActivityIndicator()
        
        if(meditationLevelDataResponse?.status != nil && meditationLevelDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(meditationLevelDataResponse)
            
            if let arrChakra = meditationLevelDataResponse?.chakras {
                if arrChakra.count > 0 {
                    arrayMeditationChakra = arrChakra.reversed()
                    tblChakraLevel.reloadData()
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didMeditationLevelDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
