//
//  ProfileViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 06/10/21.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    var profileViewModel = ProfileViewModel()
    var profileData: ProfileData?
    var badgeData: [BadgeModel]?
    
    var pointsStr: String?
    
    var boolEdit: Bool = false
    var boolAlert: Bool = false
    
    var imagePicker: UIImagePickerController!
    
    //View
    @IBOutlet var viewTopBack: UIView!
    @IBOutlet var viewPoints: UIView_Designable!
    @IBOutlet var viewChakraLevel: UIView!
    //Image View
    @IBOutlet var imgVProfile: UIImageView!
    @IBOutlet var imgVFirstName: UIImageView!
    @IBOutlet var imgVLastName: UIImageView!
    @IBOutlet var imgVEmail: UIImageView!
    @IBOutlet var imgVPhone: UIImageView!
    @IBOutlet var imgVPoints: UIImageView!
    //Button
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var btnEditProfile: UIButton!
    //Label
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblChakraLevel: UILabel!
    @IBOutlet var lblChakraName: UILabel!
    @IBOutlet var lblPoints: UILabel!
    
    //Textfield
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    //Acheivment-----
    @IBOutlet var viewAcheivment: UIView_Designable!
    @IBOutlet var imgVAcheivment: UIImageView!
    @IBOutlet var lblBadgePoints: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        profileViewModel.delegate = self
        
        setupLayer()
        setupColorImage()
        setupTextfield()
        getProfileData()
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
        
        fromSideMenu = false
        
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
    
    func setupLayer() {
        viewTopBack.roundCornersBottomLeftRight(radius: 30)
        imgVProfile.layer.cornerRadius = imgVProfile.frame.size.width / 2
        imgVProfile.layer.borderWidth = 3
        imgVProfile.layer.borderColor = UIColor.white.cgColor
        viewChakraLevel.layer.cornerRadius = 15
        btnCamera.layer.cornerRadius = btnCamera.frame.size.width / 2
        btnEditProfile.layer.cornerRadius = 6
        lblPoints.layer.cornerRadius = 12
        imgVPoints.backgroundColor = .white
        imgVPoints.layer.cornerRadius = imgVPoints.frame.size.width / 2
        
        lblPoints.layer.cornerRadius = 12
        imgVAcheivment.layer.cornerRadius = imgVAcheivment.frame.size.width / 2
        
        let tapAcheive = UITapGestureRecognizer.init(target: self, action: #selector(WaterIntakeStatsViewController.tapAcheivement(_:)))
        viewAcheivment.addGestureRecognizer(tapAcheive)
    }
    
    func setupColorImage() {
        btnEditProfile.backgroundColor = UIColor.colorSetup()
        lblPoints.backgroundColor = UIColor.colorSetup()
        lblPoints.backgroundColor = UIColor.colorSetup()
        imgVAcheivment.backgroundColor = .white
        
        imgVFirstName.tintColor = UIColor.colorSetup()
        imgVLastName.tintColor = UIColor.colorSetup()
        imgVEmail.tintColor = UIColor.colorSetup()
        imgVPhone.tintColor = UIColor.colorSetup()
        
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        print("coloris ...--->>>",chakraColour)
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
                
                print(crownList)

        
        if chakraColour==0 {
            switch chakraLevel{
        case 1:
            //red
            viewTopBack.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "red_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "red_profile_person")
//            imgVLastName.image = UIImage.init(named: "red_profile_person")
//            imgVEmail.image = UIImage.init(named: "red_profile_mail")
//            imgVPhone.image = UIImage.init(named: "red_profile_phone")
            
            break
            
        case 2:
            //orange
            viewTopBack.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "orange_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "orange_profile_person")
//            imgVLastName.image = UIImage.init(named: "orange_profile_person")
//            imgVEmail.image = UIImage.init(named: "orange_profile_mail")
//            imgVPhone.image = UIImage.init(named: "orange_profile_phone")
            
            break
            
        case 3:
            //yellow
            viewTopBack.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "yellow_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "yellow_profile_person")
//            imgVLastName.image = UIImage.init(named: "yellow_profile_person")
//            imgVEmail.image = UIImage.init(named: "yellow_profile_mail")
//            imgVPhone.image = UIImage.init(named: "yellow_profile_phone")
            
            break
            
        case 4:
            //green
            viewTopBack.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "green_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "green_profile_person")
//            imgVLastName.image = UIImage.init(named: "green_profile_person")
//            imgVEmail.image = UIImage.init(named: "green_profile_mail")
//            imgVPhone.image = UIImage.init(named: "green_profile_phone")
            
            break
            
        case 5:
            //blue
            viewTopBack.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "blue_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "blue_profile_person")
//            imgVLastName.image = UIImage.init(named: "blue_profile_person")
//            imgVEmail.image = UIImage.init(named: "blue_profile_mail")
//            imgVPhone.image = UIImage.init(named: "blue_profile_phone")
            
            break
        
        case 6:
            //violet
            viewTopBack.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "violet_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "violet_profile_person")
//            imgVLastName.image = UIImage.init(named: "violet_profile_person")
//            imgVEmail.image = UIImage.init(named: "violet_profile_mail")
//            imgVPhone.image = UIImage.init(named: "violet_profile_phone")
            
            break
            
        case 7:
            //purple
            viewTopBack.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "purple_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "purple_profile_person")
//            imgVLastName.image = UIImage.init(named: "purple_profile_person")
//            imgVEmail.image = UIImage.init(named: "purple_profile_mail")
//            imgVPhone.image = UIImage.init(named: "purple_profile_phone")
            
            break
            
        default:
            //red
            viewTopBack.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "red_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "red_profile_person")
//            imgVLastName.image = UIImage.init(named: "red_profile_person")
//            imgVEmail.image = UIImage.init(named: "red_profile_mail")
//            imgVPhone.image = UIImage.init(named: "red_profile_phone")
            
            break
        }
        } else if crownList == 1 {
            switch chakraColour{
        case 1:
            //red
            viewTopBack.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "red_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "red_profile_person")
//            imgVLastName.image = UIImage.init(named: "red_profile_person")
//            imgVEmail.image = UIImage.init(named: "red_profile_mail")
//            imgVPhone.image = UIImage.init(named: "red_profile_phone")
            
            break
            
        case 2:
            //orange
            viewTopBack.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "orange_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "orange_profile_person")
//            imgVLastName.image = UIImage.init(named: "orange_profile_person")
//            imgVEmail.image = UIImage.init(named: "orange_profile_mail")
//            imgVPhone.image = UIImage.init(named: "orange_profile_phone")
            
            break
            
        case 3:
            //yellow
            viewTopBack.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "yellow_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "yellow_profile_person")
//            imgVLastName.image = UIImage.init(named: "yellow_profile_person")
//            imgVEmail.image = UIImage.init(named: "yellow_profile_mail")
//            imgVPhone.image = UIImage.init(named: "yellow_profile_phone")
            
            break
            
        case 4:
            //green
            viewTopBack.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "green_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "green_profile_person")
//            imgVLastName.image = UIImage.init(named: "green_profile_person")
//            imgVEmail.image = UIImage.init(named: "green_profile_mail")
//            imgVPhone.image = UIImage.init(named: "green_profile_phone")
            
            break
            
        case 5:
            //blue
            viewTopBack.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "blue_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "blue_profile_person")
//            imgVLastName.image = UIImage.init(named: "blue_profile_person")
//            imgVEmail.image = UIImage.init(named: "blue_profile_mail")
//            imgVPhone.image = UIImage.init(named: "blue_profile_phone")
            
            break
        
        case 6:
            //violet
            viewTopBack.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "violet_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "violet_profile_person")
//            imgVLastName.image = UIImage.init(named: "violet_profile_person")
//            imgVEmail.image = UIImage.init(named: "violet_profile_mail")
//            imgVPhone.image = UIImage.init(named: "violet_profile_phone")
            
            break
            
        case 7:
            //purple
            viewTopBack.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "purple_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "purple_profile_person")
//            imgVLastName.image = UIImage.init(named: "purple_profile_person")
//            imgVEmail.image = UIImage.init(named: "purple_profile_mail")
//            imgVPhone.image = UIImage.init(named: "purple_profile_phone")
            
            break
            
        default:
            //red
            viewTopBack.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "red_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "red_profile_person")
//            imgVLastName.image = UIImage.init(named: "red_profile_person")
//            imgVEmail.image = UIImage.init(named: "red_profile_mail")
//            imgVPhone.image = UIImage.init(named: "red_profile_phone")
            
            break
        }
        }else
        {
            switch chakraLevel{
        case 1:
            //red
            viewTopBack.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "red_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "red_profile_person")
//            imgVLastName.image = UIImage.init(named: "red_profile_person")
//            imgVEmail.image = UIImage.init(named: "red_profile_mail")
//            imgVPhone.image = UIImage.init(named: "red_profile_phone")
            
            break
            
        case 2:
            //orange
            viewTopBack.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "orange_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "orange_profile_person")
//            imgVLastName.image = UIImage.init(named: "orange_profile_person")
//            imgVEmail.image = UIImage.init(named: "orange_profile_mail")
//            imgVPhone.image = UIImage.init(named: "orange_profile_phone")
            
            break
            
        case 3:
            //yellow
            viewTopBack.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "yellow_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "yellow_profile_person")
//            imgVLastName.image = UIImage.init(named: "yellow_profile_person")
//            imgVEmail.image = UIImage.init(named: "yellow_profile_mail")
//            imgVPhone.image = UIImage.init(named: "yellow_profile_phone")
            
            break
            
        case 4:
            //green
            viewTopBack.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "green_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "green_profile_person")
//            imgVLastName.image = UIImage.init(named: "green_profile_person")
//            imgVEmail.image = UIImage.init(named: "green_profile_mail")
//            imgVPhone.image = UIImage.init(named: "green_profile_phone")
            
            break
            
        case 5:
            //blue
            viewTopBack.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "blue_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "blue_profile_person")
//            imgVLastName.image = UIImage.init(named: "blue_profile_person")
//            imgVEmail.image = UIImage.init(named: "blue_profile_mail")
//            imgVPhone.image = UIImage.init(named: "blue_profile_phone")
            
            break
        
        case 6:
            //violet
            viewTopBack.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "violet_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "violet_profile_person")
//            imgVLastName.image = UIImage.init(named: "violet_profile_person")
//            imgVEmail.image = UIImage.init(named: "violet_profile_mail")
//            imgVPhone.image = UIImage.init(named: "violet_profile_phone")
            
            break
            
        case 7:
            //purple
            viewTopBack.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "purple_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "purple_profile_person")
//            imgVLastName.image = UIImage.init(named: "purple_profile_person")
//            imgVEmail.image = UIImage.init(named: "purple_profile_mail")
//            imgVPhone.image = UIImage.init(named: "purple_profile_phone")
            
            break
            
        default:
            //red
            viewTopBack.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
            viewChakraLevel.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewPoints.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            btnCamera.setImage(UIImage.init(named: "red_profile_camera"), for: .normal)
            
//            imgVFirstName.image = UIImage.init(named: "red_profile_person")
//            imgVLastName.image = UIImage.init(named: "red_profile_person")
//            imgVEmail.image = UIImage.init(named: "red_profile_mail")
//            imgVPhone.image = UIImage.init(named: "red_profile_phone")
            
            break
        }
        }
      
            
            
        
        }
    
    func setupTextfield() {
        txtFirstName.isUserInteractionEnabled = false
        txtLastName.isUserInteractionEnabled = false
        txtPhone.isUserInteractionEnabled = false
        
        txtFirstName.textColor = .darkGray
        txtLastName.textColor = .darkGray
        txtPhone.textColor = .darkGray
    }

    //MARK: Tap Gesture Func---------
    @objc func tapAcheivement(_ sender: UITapGestureRecognizer) {
        let badgeVC = ConstantStoryboard.badgesStoryboard.instantiateViewController(withIdentifier: "BadgeViewController") as! BadgeViewController
        if let userBadge = badgeData {
            badgeVC.arrBadgeData = userBadge
        }
        badgeVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.navigationController?.present(badgeVC, animated: true)
    }
    
    @IBAction func tapGesViewPoints(_ sender: Any) {
        let badgeVC = ConstantStoryboard.badgesStoryboard.instantiateViewController(withIdentifier: "BadgeViewController") as! BadgeViewController
        if let userBadge = badgeData {
            badgeVC.arrBadgeData = userBadge
        }
        badgeVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.navigationController?.present(badgeVC, animated: true)
        
        //Point screen design not neede at this moment
//        let pointVC = ConstantStoryboard.pointsStoryboard.instantiateViewController(withIdentifier: "PointsViewController") as! PointsViewController
//        navigationController?.pushViewController(pointVC, animated: true)
    }
    
    //MARK: - Button Func
    @IBAction func btnCamera(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        self.openAlertWithButtonFunc(title: ConstantAlertTitle.SelectSourceAlertTitle,
                                     message: "Select a source type",
                                     alertStyle: .actionSheet,
                                     actionTitles: [ConstantAlertTitle.CameraAlertTitle, ConstantAlertTitle.PhotosAlertTitle],
                                     actionStyles: [.default, .default],
                                     actions: [
                                        { _ in
                                            self.funcOpenCamera()
                                        },
                                        { _ in
                                            self.funcOpenPhotos()
                                        }
                                     ])
    }
    
    func funcOpenCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.CameraUnavailable)
        }
    }
    
    func funcOpenPhotos() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func btnEditProfile(_ sender: Any) {
        if boolEdit == false {
            boolEdit = true
            
            btnEditProfile.setTitle("Save Profile", for: .normal)
            
            txtFirstName.isUserInteractionEnabled = true
            txtLastName.isUserInteractionEnabled = true
            txtPhone.isUserInteractionEnabled = true
            
            txtFirstName.textColor = .black
            txtLastName.textColor = .black
            txtPhone.textColor = .black
            
        } else {
            
            ////Note: All changes to text colour & isUserInteractionEnabled done on API response success and validateSameProfileData else part
            
            if validateSameProfileData() == false {
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
                    
                    if let firstName = txtFirstName.text {
                        if let lastName = txtLastName.text {
                            if let phoneNo = txtPhone.text {
                                if firstName.count > 0 && firstName != "" {
                                    if lastName.count > 0 && lastName != "" {
                                        if phoneNo.count == 1 || phoneNo.count == 2 || phoneNo.count == 3 || phoneNo.count == 4 || phoneNo.count == 5 || phoneNo.count == 6 || phoneNo.count == 7 || phoneNo.count == 8 || phoneNo.count == 9{
                                            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.phoneValidation)
                                        } else {
                                            var username: String
                                            username = "\(firstName) \(lastName)"
                                            
                                            let request = ProfileUpdateRequest(userName: username, mobileNo: txtPhone.text)
                                            
                                            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                                            profileViewModel.postProfileUpdateData(profileRequest: request, token: token)
                                        }
                                    } else {
                                        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.lastNameEmpty)
                                    }
                                } else {
                                    self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.firstNameEmpty)
                                }
                            } else {
                                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.phoneValidation)
                            }
                        } else {
                            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.lastNameEmpty)
                        }
                    } else {
                        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.firstNameEmpty)
                    }
                }
            } else {
                // no changes to save
//                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.ProfileNoChanges)
                if boolAlert == false {
                    boolEdit = false
                    
                    btnEditProfile.setTitle("Edit Profile", for: .normal)
                    
                    txtFirstName.isUserInteractionEnabled = false
                    txtLastName.isUserInteractionEnabled = false
                    txtPhone.isUserInteractionEnabled = false
                    
                    txtFirstName.textColor = .darkGray
                    txtLastName.textColor = .darkGray
                    txtPhone.textColor = .darkGray
                }
            }
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
//MARK: - ImagePicker Controller Delegate
extension ProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            imgVProfile.image = image
            //API call to upload image
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
//                let pngRepresent = UIImage.pngData(image)
//                let jpegRepresent = UIImage.jpegData(image)
//                let pngRepresent = image.pngData()
                let jpegRepresent = image.jpegData(compressionQuality: 0.5)
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                profileViewModel.uploadProfileImage(image: jpegRepresent!, token: token)
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }
}

//MARK: - Setup User Data
extension ProfileViewController {
    func setupUserData() {
        //Check if social OR normal login profile image, then set the image accordingly
        let socialTypeBool = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udSocialLoginBool)
        if socialTypeBool {
            if let profileImg = profileData?.location {
                imgVProfile.sd_setImage(with: URL(string: profileImg), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
        } else {
            if let profileImg = profileData?.location {
                imgVProfile.sd_setImage(with: URL(string: profileImg), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
            
//            if let profileImg = profileData?.profileImg {
//                let imagePath = Common.WebserviceAPI.baseURL + profileImg
//                imgVProfile.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
        }
        
        if let chakraName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraName) {
            lblChakraName.text = chakraName as? String
        }
        
        if let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) {
            lblChakraLevel.text = "Level \(chakraLevel)"
            lblChakraLevel.textColor = UIColor.colorSetup()
        }
        
        if let username = profileData?.userName {
            var components = username.components(separatedBy: " ")
            if components.count > 0 {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                debugPrint(firstName)
                debugPrint(lastName)
                txtFirstName.text = firstName
                txtLastName.text = lastName
            }
//            let nameSeparate = username.components(separatedBy: " ")
//            if nameSeparate.count > 1 {
//                txtFirstName.text = nameSeparate[0]
//                txtLastName.text = nameSeparate[1]
//            } else {
//                txtFirstName.text = nameSeparate[0]
//            }
            lblName.text = username
        }
        
        if let email = profileData?.userEmail {
            txtEmail.text = email
        }
        
        if let phone = profileData?.mobileNo {
            txtPhone.text = phone
        }
        
        if let bData = badgeData {
            var bCount = 0
            for item in bData {
                if let wins = item.wins {
                    bCount += wins
                }
            }
            lblPoints.text = "\(bCount)"
        }
        
//        if let points = pointsStr {
//            lblPoints.text = points
//        }
    }
    
    func validateSameProfileData() -> Bool {
        if let firstName = txtFirstName.text {
            if let lastName = txtLastName.text {
                if firstName.count > 0 && firstName != "" {
                    if lastName.count > 0 && lastName != "" {
                        var username: String
                        
                        username = "\(firstName) \(lastName)"
                        
                        let request = ProfileUpdateRequest(userName: username, mobileNo: txtPhone.text)
                        let validationResult = ProfileValidation().Validate(profileRequest: request)
                        
                        if validationResult.success {
                            if profileData?.userName == username {
                                if profileData?.mobileNo == txtPhone.text {
                                    boolAlert = false
                                    return true
                                }
                            }
                        }
                    } else {
                        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.lastNameEmpty)
                        boolAlert = true
                        return true
                    }
                } else {
                    self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.firstNameEmpty)
                    boolAlert = true
                    return true
                }
            } else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.lastNameEmpty)
                boolAlert = true
                return true
            }
        } else {
            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.firstNameEmpty)
            boolAlert = true
            return true
        }
        return false
    }
    
//    func colorSetup() -> UIColor {
//        //Color setup according to chakra level
//        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
//
//        switch chakraLevel {
//        case 1:
//            return UIColor(hexString: ConstantThemeSolidColor.red)
//            break
//
//        case 2:
//            return UIColor(hexString: ConstantThemeSolidColor.orange)
//            break
//
//        case 3:
//            return UIColor(hexString: ConstantThemeSolidColor.yellow)
//            break
//
//        case 4:
//            return UIColor(hexString: ConstantThemeSolidColor.green)
//            break
//
//        case 5:
//            return UIColor(hexString: ConstantThemeSolidColor.blue)
//            break
//
//        case 6:
//            return UIColor(hexString: ConstantThemeSolidColor.purple)
//            break
//
//        case 7:
//            return UIColor(hexString: ConstantThemeSolidColor.violet)
//            break
//
//        default:
//            return UIColor(hexString: ConstantThemeSolidColor.red)
//            break
//        }
//    }
}
//MARK: - TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtPhone) {
            if (range.location == 0 && string == " ") {
                return false
            } else if (newString.count > 10) {
                return false
            } else {
                guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return false
                }
            }
        }
        return true
    }
}
