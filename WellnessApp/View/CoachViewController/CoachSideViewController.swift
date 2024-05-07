//
//  CoachSideViewController.swift
//  Luvo
//
//  Created by BEASiMAC on 05/07/22.
//
import SDWebImage
import UIKit

protocol CoachSideMenuDelegate {
    func didSelectViewProfile()
    func didSelectSideMenu(selectedIndex:Int,name:String)
}

class CoachSideMenuDefaultCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
}

class CoachSideViewController: UIViewController {
    
    fileprivate var sideMenuArray = [SideMenuModel]()
    
    @IBOutlet weak var tblSideMenu: UITableView!
    
    @IBOutlet var viewBackground: UIView!
    
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblProfileName: UILabel!
    var lastSelectedIndexPath:IndexPath?
    var delegate:SideMenuDelegate?
   
    var profileVC = ProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("SIDE MENU WILL APPEAR----->")
        UserDefaults.standard.set(true, forKey: "Isfromcoachsideview")
        setupGradientBackground()
        setupGUI()
        SideMenuInit()
        setupProfileData()
      
    }
    
    func setupGradientBackground() {
        
        //Color setup according to chakra level
     //   let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
     //   let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        
        let chakraLevel = 7
        let chakraColour = 0
        print("coloris ...--->>>",chakraColour)
        
        if chakraColour==0 {
        switch chakraLevel {
        case 1:
            viewBackground.setGradientBackground(hexColor: ["#ed020c", "#f2434b"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
            
        case 2:
            viewBackground.setGradientBackground(hexColor: ["#f46d02", "#f89c53"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
            
        case 3:
            viewBackground.setGradientBackground(hexColor: ["#feb303", "#fecd58"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
            
        case 4:
            viewBackground.setGradientBackground(hexColor: ["#04a72f", "#40bc61"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
            
        case 5:
            viewBackground.setGradientBackground(hexColor: ["#02aeef", "#56c8f4"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
        
        case 6:
            viewBackground.setGradientBackground(hexColor: ["#5e29a7", "#865fbd"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
            
        case 7:
            viewBackground.setGradientBackground(hexColor: ["#8803a3", "#9e1698"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
            
        default:
            viewBackground.setGradientBackground(hexColor: ["#ed020c", "#f2434b"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
            break
        }
        }else{
            switch chakraColour {
            case 1:
                viewBackground.setGradientBackground(hexColor: ["#ed020c", "#f2434b"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
                
            case 2:
                viewBackground.setGradientBackground(hexColor: ["#f46d02", "#f89c53"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
                
            case 3:
                viewBackground.setGradientBackground(hexColor: ["#feb303", "#fecd58"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
                
            case 4:
                viewBackground.setGradientBackground(hexColor: ["#04a72f", "#40bc61"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
                
            case 5:
                viewBackground.setGradientBackground(hexColor: ["#02aeef", "#56c8f4"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
            
            case 6:
                viewBackground.setGradientBackground(hexColor: ["#5e29a7", "#865fbd"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
                
            case 7:
                viewBackground.setGradientBackground(hexColor: ["#8803a3", "#9e1698"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
                
            default:
                viewBackground.setGradientBackground(hexColor: ["#ed020c", "#f2434b"], rightToLeft: false, leftToRight: false, topToBottom: true, bottomToTop: false)
                break
            }
        }
    }
    
    func setupGUI() {
        //Add corner radius
        viewBackground.roundCornersBottomLeft(radius: 100)
        
        //Profile Image
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.width / 2
        imgProfilePic.layer.borderWidth = 3.0
        imgProfilePic.layer.borderColor = UIColor.white.cgColor
    }
    
    func SideMenuInit() {
        sideMenuArray.append(SideMenuModel(menuTitle: "Application Settings", menuIcon: "settings"))
      //  sideMenuArray.append(SideMenuModel(menuTitle: "Blooooog", menuIcon: "blog"))
      //  sideMenuArray.append(SideMenuModel(menuTitle: "Favorite", menuIcon: "favourite"))
        sideMenuArray.append(SideMenuModel(menuTitle: "Recorded Session", menuIcon: "chakraLevel"))
        sideMenuArray.append(SideMenuModel(menuTitle: "Share With Friends & Family", menuIcon: "share"))
      //  sideMenuArray.append(SideMenuModel(menuTitle: "FAQ", menuIcon: "faq"))
        sideMenuArray.append(SideMenuModel(menuTitle: "Terms Of Service & Privacy Policy", menuIcon: "terms"))
        sideMenuArray.append(SideMenuModel(menuTitle: "Contact Us", menuIcon: "contactUs"))
        sideMenuArray.append(SideMenuModel(menuTitle: "Chat With Admin", menuIcon: "chat"))
        sideMenuArray.append(SideMenuModel(menuTitle: "Rate This App", menuIcon: "rateNew"))
     //   sideMenuArray.append(SideMenuModel(menuTitle: "Retake The Quiz", menuIcon: "questions"))
        sideMenuArray.append(SideMenuModel(menuTitle: "Log Out", menuIcon: "logout"))
    }
    
    func setupProfileData() {
        do{
            if let userData = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserDetails) {
                let data = try JSONDecoder().decode(LoginUserDetails.self, from: userData as! Data)

                if let imgProfile = data.location {
                    
                    //Check if social OR normal login profile image, then set the image accordingly
                    let socialTypeBool = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udSocialLoginBool)
                    if socialTypeBool {
                        imgProfilePic.sd_setImage(with: URL(string: imgProfile), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                    } else {
                        imgProfilePic.sd_setImage(with: URL(string: imgProfile), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                    }
                }
                
//                if let imgProfile = data.profileImg {
//
//                    //Check if social OR normal login profile image, then set the image accordingly
//                    let socialTypeBool = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udSocialLoginBool)
//                    if socialTypeBool {
//                        imgProfilePic.sd_setImage(with: URL(string: imgProfile), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//                    } else {
//                        let imgPath = Common.WebserviceAPI.baseURL + imgProfile
//                        imgProfilePic.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//                    }
//                }

                if let username = data.userName {
                    lblProfileName.text = username
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnViewProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.didSelectViewProfile()
    }
}

extension CoachSideViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuDefaultCell", for: indexPath) as! SideMenuDefaultCell
        
        cell.lblTitle.text = sideMenuArray[indexPath.row].menuTitle
        cell.imgIcon.image = UIImage.init(named: sideMenuArray[indexPath.row].menuIcon!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.didSelectSideMenu(selectedIndex: indexPath.row, name: sideMenuArray[indexPath.row].menuTitle!)
        }
        dismiss(animated: true, completion: nil)
    }
}
