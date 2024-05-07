//
//  HomeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 02/09/21.
//

import FirebaseDatabase
import StoreKit
import UIKit
import FBSDKLoginKit
import HealthKit
var fromSideMenu = false    //To disable API call on viewWillAppear when openning side menu

class CellBreath: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView_Designable!
    @IBOutlet var lblTitle: UILabel!
}
class CellRecord: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView_Designable!
    @IBOutlet var lblTitle: UILabel!
}

class CellLive: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView_Designable!
    @IBOutlet var lblTitle: UILabel!
}


class CellBanner: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgView1: UIImageView!
    @IBOutlet var lbquotes: UILabel!
    @IBOutlet var lblAuthor: UILabel!
}


class UpcomingList: UITableViewCell {
@IBOutlet var imgViewCoach: UIImageView!
@IBOutlet var imgViewCalender: UIImageView!
@IBOutlet var lblCoach: UILabel!
@IBOutlet var lblTime: UILabel!
@IBOutlet var Sessonname: UILabel!
@IBOutlet var imgViewLive: UIImageView!
@IBOutlet var lblCatagory: UILabel!
    
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 15.0
       // self.layer.borderWidth = 5.0
      //  self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    
    }


class CellBlog: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
}

class HomeViewController: UIViewController, SideMenuDelegate, UITextFieldDelegate { //, RoundedCornerNavigationBar
    var healthStore = HKHealthStore()
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    private var countdownTimer: Timer?
    //Button
    @IBOutlet var btnSearch: UIBUtton_Designable!
    
    //View
    @IBOutlet var viewTopBanner: UIView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var viewSteps: UIView!
    @IBOutlet var viewWaterIntake: UIView!
    @IBOutlet var viewMood: UIView!
    @IBOutlet var viewHeartRate: UIView!
    @IBOutlet var viewSleep: UIView!
    @IBOutlet var viewPoints: UIView!
    @IBOutlet var viewGratitudeBanner: UIView!
    
    //Image View
    @IBOutlet var imgSteps: UIImageView!    
    @IBOutlet var imgWaterIntake: UIImageView!
    @IBOutlet var imgMood: UIImageView!
    @IBOutlet var imgHeartRate: UIImageView!
    @IBOutlet var imgSleep: UIImageView!
    @IBOutlet var imgPoints: UIImageView!
    @IBOutlet var imgGratitude: UIImageView!
    @IBOutlet var imageViewGif: UIImageView!
    
    //Label
   // @IBOutlet var lblQuotes: UILabel!
    @IBOutlet var lblQuoteAuthor: UILabel!
    @IBOutlet var lblSteps: UILabel!
    @IBOutlet var lblWaterIntake: UILabel!
    @IBOutlet var lblMood: UILabel!
    @IBOutlet var lblHeartRate: UILabel!
    @IBOutlet var lblHeartClick: UILabel!
    @IBOutlet var lblSleep: UILabel!
    @IBOutlet var lblPoints: UILabel!
    @IBOutlet var lblPointsClick: UILabel!
    @IBOutlet var lblGratitude: UILabel!
    
    //Button
    @IBOutlet var btnBreathViewAll: UIButton!
    @IBOutlet var btnBlogViewAll: UIButton!
    @IBOutlet var btnRecordedsession: UIButton!
    @IBOutlet var btnLivesession: UIButton!
    @IBOutlet var btnUserRcordedSession: UIButton!
    @IBOutlet var btnDonateUs: UIButton!
    @IBOutlet var btnUpcomingSession: UIButton!
    @IBOutlet var btnHeaderLive: UIButton!
    
    //CollectionView
    @IBOutlet var collBreathExercise: UICollectionView!
    @IBOutlet var collBlog: UICollectionView!
    @IBOutlet var collRec: UICollectionView!
    @IBOutlet var collLive: UICollectionView!

    @IBOutlet var collBanner: UICollectionView!


    
    @IBOutlet weak var upComingSession: UITableView!
    
    @IBOutlet weak var btnVideoCall: UIButton!
    
    var chakraDiplayViewModel = ChakraDisplayViewModel()
    var homeViewModel = HomeViewModel()
    var homeData: HomeResponse?
    var liveJoinViewModelUpcoming = LiveJoinViewModel()
    var sessionIdUpcoming: String = ""
    var ref: DatabaseReference!
    
    var UpcomingArray2 = [Any]()
    
    private var sideMenu:SideMenuViewController!
    private var drawerTransition:DrawerTransition!
    var scrollTimer: Timer?
    var currenCallIndex = 0
    private var heartViewModel = HeartViewModel()
    
    var AlreadyActive: Bool = false
    var Started: Bool = false
    var string: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
//        setupCustomNavBar()
//        txtSearch.delegate = self
//        chakraDiplayViewModel.delegate = self
//        homeViewModel.delegate = self
//        homeViewModel.timezoneDelegate = self
//        homeViewModel.logoutDelegate = self
//
//        setupSideMenu()
//
////        Temporary
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJF9.eyJ1c2VybmFtZSI6IlBhbmthaiBuYXJheWFuIFNhcmthciIsIm1vYmlsZSI6Ijk4MDc2NTQzMjEiLCJpYXQiOjE2NDAzMzEwOTMsInN1YiI6IjYxODAzYTU1OTMxZGNiNTVkOTM2N2ViYiJ9.GeVFiMe5pkbC-1-IDfNFIM4Z-4HrhLxtT58W3fT9SVU"
//        UserDefaults.standard.set(token, forKey: ConstantUserDefaultTag.udToken)
//
//        let userid = "464694"
        //UserDefaults.standard.set(userid, forKey: ConstantUserDefaultTag.udUserId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        for v in view.subviews{
//           if v is UIView{
//              v.removeFromSuperview()
//           }
    
//        }
//        print(UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromLive))//
        UserDefaults.standard.set(false, forKey: "isFromSave")
        imageViewGif.isHidden = true
        btnHeaderLive.isHidden = true
        let status = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromLive)
        print(status)
        if status==true
        {
            imageViewGif.isHidden = false
            btnHeaderLive.isHidden = false
        }
        else
        {
            imageViewGif.isHidden = true
            btnHeaderLive.isHidden = true
        }
        
        let jeremyGif = UIImage.gifImageWithName("liveNew")
        imageViewGif.image = jeremyGif
        ref = Database.database().reference()
        self.childObserver()
        btnDonateUs.isHidden = true
        ref = Database.database().reference()
       // upComingSession.reloadData()
        upComingSession.layer.cornerRadius = 10
        
        heartViewModel.delegateWatchHeartPostData = self
        
        UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udFromsideMenu)
        
        setupCustomNavBar()
        txtSearch.delegate = self
        chakraDiplayViewModel.delegate = self
        homeViewModel.delegate = self
        homeViewModel.timezoneDelegate = self
        homeViewModel.logoutDelegate = self
        liveJoinViewModelUpcoming.Liveviewdelegate = self
        setupSideMenu()
      //  viewTopBanner.setNeedsDisplay()
        viewGratitudeBanner.setNeedsDisplay()
        
      //  super.viewWillAppear(animated)
        
        self.view.endEditing(true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomeViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
//        setupNotificationBadge()  //not required as data getting refreshed and notification getting called
                
        if fromSideMenu == false {
            ///API calling sequence will be timezone -> chakra level -> home data
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.updateGMTTimezone()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.getChakraLevelData()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.getData()
            }
        }
        
//        scrollTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(sliderNext), userInfo: nil, repeats: true)

        
    }
    
    @objc func sliderNext()
    {
        //homeData?.quotesArray?.count
        debugPrint(homeData?.quotesArray?.count ?? 0)
        
        if currenCallIndex < (homeData?.quotesArray?.count ?? 0) - 1
        {
            currenCallIndex = currenCallIndex + 1
        }
        else{
            
            currenCallIndex = 0
        }
        
        if currenCallIndex == 0
        {
        collBanner.scrollToItem(at: IndexPath(item: currenCallIndex, section: 0), at: .left, animated: false)
        }
        
        else
        {
        collBanner.scrollToItem(at: IndexPath(item: currenCallIndex, section: 0), at: .right, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//                for v in view.subviews{
//                   if v is UIView{
//                    v.removeFromSuperview()
//                   }
//                }
        
        fromSideMenu = false
        //Remove Local Notification (I guess it will have no effect)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(ConstantLocalNotification.refreshHomeButtonColor), object: nil)
        
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
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    @IBAction func btnUpcomingSessionLive(_ sender: Any) {
        
        let LiveVC = ConstantStoryboard.LiveSessionList.instantiateViewController(withIdentifier: "LiveSessionListViewController") as! LiveSessionListViewController
        LiveVC.sessionId = ""
        LiveVC.CatagoryName = "All Upcoming Sessions"
        navigationController?.pushViewController(LiveVC, animated: true)
    }
    
    @IBAction func btnUpcomingSession(_ sender: Any) {
        
        let LiveVC = ConstantStoryboard.LiveSessionList.instantiateViewController(withIdentifier: "LiveSessionListViewController") as! LiveSessionListViewController
        LiveVC.sessionId = ""
        LiveVC.CatagoryName = "All Upcoming Sessions"
        navigationController?.pushViewController(LiveVC, animated: true)
        
        
//        let refreshAlert = UIAlertController(title: "Luvo", message: "Recording section is coming soon", preferredStyle: UIAlertController.Style.alert)
//
//        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//              print("Handle Ok logic here")
//
//        }))
//
////        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
////              print("Handle Cancel Logic here")
////        }))
//
//        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnRecord(_ sender: Any) {
        
        
        let refreshAlert = UIAlertController(title: "Luvo", message: "Recording section is coming soon", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
           
        }))

//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//              print("Handle Cancel Logic here")
//        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnRecordedList(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "isFromHomeList")
        let LiveVC = ConstantStoryboard.RecordedSessionList.instantiateViewController(withIdentifier: "RecordedSessionListVC") as! RecordedSessionListVC
      //  LiveVC.sessionId = (homeData?.recording?[indexPath.row].ctgryId)!
      //  LiveVC.sessionName = homeData?.recording?[indexPath.row].categoryName ?? "test"
        navigationController?.pushViewController(LiveVC, animated: true)
        
    }
    
    @IBAction func btnDonation(_ sender: Any) {

        UserDefaults.standard.set(true, forKey: "IsfromHome")
        UserDefaults.standard.set(false, forKey: "IsfromRecord")
        UserDefaults.standard.set(false, forKey: "IsfromSession")
              let callVC = ConstantStoryboard.Payment.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
              self.navigationController?.pushViewController(callVC, animated: false)


        
    }
    @IBAction func btnLive(_ sender: Any) {
        
        
        let refreshAlert = UIAlertController(title: "Luvo", message: "Live section is coming soon", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
           
        }))

//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//              print("Handle Cancel Logic here")
//        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK: - Side Menu
    func setupSideMenu() {
        sideMenu = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        sideMenu.delegate = self
        drawerTransition = DrawerTransition(target: self, drawer: sideMenu)
    }
    
    
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    //MARK: - Setup UI
    func setupUI() {        
        NotificationCenter.default.post(name: Notification.Name(ConstantLocalNotification.refreshHomeButtonColor), object: nil)
        
        //Label
        lblHeartClick.layer.cornerRadius = 8.0
        lblHeartClick.layer.masksToBounds = true
        lblPointsClick.layer.cornerRadius = 8.0
        lblPointsClick.layer.masksToBounds = true
        
        viewSteps.layer.borderColor = UIColor.colorSetup().cgColor
        viewWaterIntake.layer.borderColor = UIColor.colorSetup().cgColor
        viewMood.layer.borderColor = UIColor.colorSetup().cgColor
        viewHeartRate.layer.borderColor = UIColor.colorSetup().cgColor
        viewSleep.layer.borderColor = UIColor.colorSetup().cgColor
        viewPoints.layer.borderColor = UIColor.colorSetup().cgColor
        
        lblHeartClick.backgroundColor = UIColor.colorSetup()
        lblPointsClick.backgroundColor = UIColor.colorSetup()
        
        btnSearch.backgroundColor = UIColor.colorSetup()
        btnBreathViewAll.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnBlogViewAll.setTitleColor(UIColor.colorSetup(), for: .normal)
       // btnRecordedsession.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnUpcomingSession.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnDonateUs.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnDonateUs.tintColor = UIColor.colorSetup()
        btnUserRcordedSession.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnVideoCall.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnVideoCall.tintColor = UIColor.colorSetup()
        
        
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
        
        print(crownList)
        print("chakra level ...--->>>",chakraLevel)
        print("coloris ...--->>>",chakraColour)
        
//        for view in viewTopBanner.subviews{
//            view.removeFromSuperview()
//        }
        
         // this gets things done
       // view.subviews.map({ $0.removeFromSuperview() })
        
        if chakraColour==0 {
            switch chakraLevel {
            case 1:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)
                
                break
                
            case 2:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a25e"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.orange_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.orange_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.orange_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.orange_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.orange_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.orange_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.orange_gratitude)
                
                break
                
            case 3:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb201","#fedd8f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)
                
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_gratitude)
                
                break
                
            case 4:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#03a72e","#7fd295"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.green_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.green_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.green_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.green_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.green_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.green_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.green_gratitude)
                
                break
                
            case 5:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#03aeef","#a2e1f9"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
//
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.sky_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.sky_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.sky_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.sky_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.sky_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.sky_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.sky_gratitude)
                
                break
            
            case 6:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#612da9","#a487ce"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.violet_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.violet_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.violet_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.violet_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.violet_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.violet_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.violet_gratitude)
                
                break
                
            case 7:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#a81f93","#e9c7e4"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.purple_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.purple_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.purple_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.purple_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.purple_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.purple_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.purple_gratitude)
                
                break
                
            default:
                //red
               
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)
                
                break
            }
        } else if crownList == 1 {
            switch chakraColour {


            case 1:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)

                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)

                break

            case 2:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a25e"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)

                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.orange_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.orange_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.orange_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.orange_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.orange_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.orange_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.orange_gratitude)

                break

            case 3:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb201","#fedd8f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)

                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_gratitude)

                break

            case 4:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//
//                viewTopBanner.setGradientBackground(hexColor: ["#03a72e","#7fd295"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.green_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.green_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.green_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.green_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.green_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.green_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.green_gratitude)

                break

            case 5:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#03aeef","#a2e1f9"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)

                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.sky_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.sky_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.sky_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.sky_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.sky_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.sky_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.sky_gratitude)

                break

            case 6:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#612da9","#a487ce"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
//
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.violet_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.violet_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.violet_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.violet_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.violet_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.violet_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.violet_gratitude)

                break

            case 7:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#a81f93","#e9c7e4"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)

                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.purple_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.purple_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.purple_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.purple_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.purple_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.purple_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.purple_gratitude)

                break

            default:
                //red
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                

                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)

                break
           }
        }
        else
        {
            switch chakraLevel {
            case 1:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)
                
                break
                
            case 2:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a25e"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.orange_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.orange_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.orange_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.orange_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.orange_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.orange_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.orange_gratitude)
                
                break
                
            case 3:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb201","#fedd8f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)
                
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_gratitude)
                
                break
                
            case 4:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#03a72e","#7fd295"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.green_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.green_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.green_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.green_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.green_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.green_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.green_gratitude)
                
                break
                
            case 5:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#03aeef","#a2e1f9"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
//
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.sky_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.sky_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.sky_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.sky_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.sky_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.sky_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.sky_gratitude)
                
                break
            
            case 6:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#612da9","#a487ce"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.violet_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.violet_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.violet_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.violet_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.violet_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.violet_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.violet_gratitude)
                
                break
                
            case 7:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#a81f93","#e9c7e4"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.purple_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.purple_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.purple_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.purple_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.purple_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.purple_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.purple_gratitude)
                
                break
                
            default:
                //red
               
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                
                
                imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
                imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
                imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
                imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
                imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
                imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
                imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)
                
                break
            }
        }
                

    }
//MARK:  ---- Text field delegate ------
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnSearch(UIButton.self)
    }
    
    //MARK: - Tap Gesture
    @IBAction func tapGesSteps(_ sender: Any) {
        let exerVC = ConstantStoryboard.exerciseStoryboard.instantiateViewController(withIdentifier: "ExerciseStatsViewController") as! ExerciseStatsViewController
        if let stepGoal = homeData?.daily_goal {
            exerVC.stepsGoal = "\(stepGoal)"
        }
        exerVC.fromHome = true
        navigationController?.pushViewController(exerVC, animated: true)
    }
    
    @IBAction func btnVideoCall(_ sender: Any) {
        
        let callVC = ConstantStoryboard.Call.instantiateViewController(withIdentifier: "UserCallViewController") as! UserCallViewController
        self.navigationController?.pushViewController(callVC, animated: true)
        
          ///      let callVC = ConstantStoryboard.Payment.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
          //      self.navigationController?.pushViewController(callVC, animated: false)
        
    }
    @IBAction func tapGesWater(_ sender: Any) {
        let waterVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WaterIntakeViewController") as! WaterIntakeViewController
        isFromBackWater = false //Bool in WaterIntakeVC
//        waterVC.fromHome = true
        navigationController?.pushViewController(waterVC, animated: true)
    }
    
    @IBAction func tapGesMood(_ sender: Any) {
        let moodVC = ConstantStoryboard.moodStoryboard.instantiateViewController(withIdentifier: "MoodViewController") as! MoodViewController
        moodVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        navigationController?.present(moodVC, animated: true)
    }
    
    @IBAction func tapGesHeartRate(_ sender: Any) {
        
        
        let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                print(status)

                if status==true
        {
                 //   startTimer ()
                    
                    let heartStatVC = ConstantStoryboard.heartRateStoryboard.instantiateViewController(withIdentifier: "WatchHeartRateStatsViewController") as! WatchHeartRateStatsViewController
                            navigationController?.pushViewController(heartStatVC, animated: true)
        }
        else
        {
        
        let heartVC = ConstantStoryboard.heartRateStoryboard.instantiateViewController(withIdentifier: "HeartRateMeasureViewController") as! HeartRateMeasureViewController
        navigationController?.pushViewController(heartVC, animated: true)
        }
    }
    
    func startTimer() {
        
        countdownTimer?.invalidate() //cancels it if already running
        countdownTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(WatchHeartrate), userInfo: nil, repeats: true) //1hr call
    }
    
    @objc func WatchHeartrate (){
        
       
            guard let smaplequery = HKObjectType.quantityType(forIdentifier:.heartRate) else
            {
                return
            }
            let startdate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            let predicate = HKQuery.predicateForSamples(withStart: startdate, end: Date(), options: .strictEndDate)
            let shortDescipto = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending:false)
                
            let queryy = HKSampleQuery(sampleType: smaplequery, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [shortDescipto]) {(sample, result, error) in
                guard error == nil else
                {
                    return
                }
                
                
                
                let data = result![0] as! HKQuantitySample
              //  print(result!)
                let unit = HKUnit (from: "count/min")
                let latestHR = data.quantity.doubleValue(for: unit)
                print("Latest HR\(latestHR) BPM")
                
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd hh:mm: s"
                let startdatee = dateformatter.string(from: data.startDate)
               // let enddatee = dateformatter.string(from: data.enddate)
                print("StartDate \(startdatee)")
                
                dateformatter.timeZone = TimeZone(abbreviation: "UTC")
                if let dt = dateformatter.date(from: startdatee) {
                    dateformatter.timeZone = TimeZone.current
                    dateformatter.dateFormat = "yyyy-MM-dd h:mm a"
                   // convertedLocalTime = dateformatter.string(from: dt)
                    print("convertedLocalTime--",dateformatter.string(from: dt))
                    } else {
                        print("There was an error decoding the string")
                    }

                   
                
                
                
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }
                let request = HeartRateWatchStatRequest(min: "70", max: "170", avg: String(latestHR), device_cat: "watch", device_type: "apple watch", add_date: startdatee)
                DispatchQueue.main.async {

                    self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                }
                
               
                //heartViewModel.postWatchHeartRateData(: request, token: token)
                self.heartViewModel.postWatchHeartRateData(heartDataRequest: request, token: token)
                
            }
            
            self.healthStore.execute(queryy)
        
       
        
    }
    
    @IBAction func tapGesSleep(_ sender: Any) {
//        let sleepVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SleepTrackViewController") as! SleepTrackViewController
//        navigationController?.pushViewController(sleepVC, animated: true)
        self.tabBarController?.selectedIndex = 4
    }
    
    @IBAction func tapGesPoints(_ sender: Any) {
        let badgeVC = ConstantStoryboard.badgesStoryboard.instantiateViewController(withIdentifier: "BadgeViewController") as! BadgeViewController
        badgeVC.arrBadgeData = homeData?.user_badges
        badgeVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navigationController?.present(badgeVC, animated: true)
    }
    
    @IBAction func tapGesGratitude(_ sender: Any) {
        let gratitudeVC = ConstantStoryboard.gratitudeStoryboard.instantiateViewController(withIdentifier: "GratitudeViewController") as! GratitudeViewController
        navigationController?.pushViewController(gratitudeVC, animated: true)
    }
    
    //MARK: - Button Func
    @IBAction func btnSideMenu(_ sender: Any) {
        drawerTransition.presentDrawerViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        let searchVC = ConstantStoryboard.searchStoryboard.instantiateViewController(withIdentifier: "SearchMeditationViewController") as! SearchMeditationViewController
      //  searchVC.messageQuetes = lblQuotes.text!
      //  searchVC.authorName = lblQuoteAuthor.text!
        searchVC.arrQuotes =  (homeData?.quotesArray)!
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func btnBreathingViewAll(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFromMeditation")
        
        let breathVC = ConstantStoryboard.breathExercisesStoryboard.instantiateViewController(withIdentifier: "BreathExerciseViewAllViewController") as! BreathExerciseViewAllViewController
        navigationController?.pushViewController(breathVC, animated: true)
    }
    
    @IBAction func btnBlogViewAll(_ sender: Any) {
        let blogVC = ConstantStoryboard.blogStoryboard.instantiateViewController(withIdentifier: "BlogListViewController") as! BlogListViewController
        navigationController?.pushViewController(blogVC, animated: true)
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
        print("Home BADGE COUNT-----\(badgeCount)")
    }
}
extension HomeViewController: WatchHeartDataPostDelegate {
    
    func didReceiveWatchHeartPostDataResponse(WatchheartPostDataResponse: HeartRateResponse?) {
        
        if(WatchheartPostDataResponse?.status != nil && WatchheartPostDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterGoalDataResponse)
//
            
            self.view.stopActivityIndicator()
            
                                let heartStatVC = ConstantStoryboard.heartRateStoryboard.instantiateViewController(withIdentifier: "WatchHeartRateStatsViewController") as! WatchHeartRateStatsViewController
                                        navigationController?.pushViewController(heartStatVC, animated: true)
            
            
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
//                                        message: "Your heart ",
//                                        alertStyle: .alert,
//                                        actionTitles: ["Cancel","OK"],
//                                        actionStyles: [.cancel, .default],
//                                        actions: [
//                                            {
//                                                _ in
//                                                print("Logout cancelled")
//                                            },
//                                            {
//                                                _ in
//
//                                                self.setUserLogout()
//                                            }])
           // }
           
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: WatchheartPostDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    
    }
    
    func didReceiveWatchHeartPostDataError(statusCode: String?) {
        
    }
    
    
    
}

//MARK: -----SideMenu Delegate
extension HomeViewController {
    func didSelectSideMenu(selectedIndex: Int, name: String) {
        debugPrint("Side menu ----->",selectedIndex, name)
        fromSideMenu = true
        
        switch selectedIndex {
        case 0:
            //Application Settings
            let settingsVC = ConstantStoryboard.settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            navigationController?.pushViewController(settingsVC, animated: true)
            break
            
        case 1:
            //Blog
            let blogVC = ConstantStoryboard.blogStoryboard.instantiateViewController(withIdentifier: "BlogListViewController") as! BlogListViewController
            navigationController?.pushViewController(blogVC, animated: true)
            break
            
        case 2:
            //Favourite
            let favVC = ConstantStoryboard.favouriteStoryboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            navigationController?.pushViewController(favVC, animated: true)
            break
            
        case 3:
            //Chakra Level
            let chakraVC = ConstantStoryboard.chakraLevelStoryboard.instantiateViewController(withIdentifier: "ChakraLevelViewController") as! ChakraLevelViewController
            navigationController?.pushViewController(chakraVC, animated: true)
            break
            
        case 4:
            //Share with Friends
            print("Share is working------>")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let text = "Luvo© - Your personal health & fitness app"
                let image = UIImage(named: "Splash")
                let myWebsite = NSURL(string:"https://apps.apple.com/in/app/luvo-zest2live/id1617104475")
                let shareAll: [Any] = [text, image!, myWebsite!]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
    //            activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]    //Include the app to exclude from sharing
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
                fromSideMenu = false
            }
            break
            
        case 5:
            //FAQ
            let faqVC = ConstantStoryboard.faqStoryboard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            navigationController?.pushViewController(faqVC, animated: true)
            break
            
        case 6:
            //Terms Of Services
            let termsVC = ConstantStoryboard.termsStoryboard.instantiateViewController(withIdentifier: "TermsAndServicesViewController") as! TermsAndServicesViewController
            navigationController?.pushViewController(termsVC, animated: true)
            break
            
        case 7:
            //Conact Us
            let contactVC = ConstantStoryboard.contactStoryboard.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            navigationController?.pushViewController(contactVC, animated: true)
            break
            
        case 8:
            //Chat With Admin
            let chatVC = ConstantStoryboard.chatStoryboard.instantiateViewController(withIdentifier: "ChatWithAdminVC") as! ChatWithAdminVC
            navigationController?.pushViewController(chatVC, animated: true)
            break
            
            
        case 9:
//                    if #available(iOS 14.0, *) {
//                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//                                SKStoreReviewController.requestReview(in: scene)
//                            }
//                        } else if #available(iOS 10.3, *) {
//                            SKStoreReviewController.requestReview()
//                        }
            
            
            guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1617104475?action=write-review")
                    else { fatalError("Expected a valid URL") }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)

            
            break
//
            
        case 10:
            let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
            
            let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
            
            print(crownList)
            
            if chakraLevel == 7
            {
                if crownList == 1
                {
            
            let questionVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "QuestionOneViewController") as! QuestionOneViewController
            navigationController?.pushViewController(questionVC, animated: true)
            
            UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udFromsideMenu)
            }
            else
            {
                
                //As You are not in Crown Chakra you are not authorize to retake the quize
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                            message: "Listening to all the audios in Chakra meditation will enable you to Retake The Quiz",
                                            alertStyle: .alert,
                                            actionTitles: ["OK"],
                                            actionStyles: [.default],
                                            actions: [
                                                {
                                                    _ in
                                                    
                                                    self.navigationController?.popViewController(animated: true)
                                                }])
                }
            }
            }
            else{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                            message: "Listening to all the audios in Chakra meditation will enable you to Retake The Quiz",
                                            alertStyle: .alert,
                                            actionTitles: ["OK"],
                                            actionStyles: [.default],
                                            actions: [
                                                {
                                                    _ in
                                                    
                                                    self.navigationController?.popViewController(animated: true)
                                                }])
                }
                
            }
            break
            
        case 11:
            //Logout
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                        message: "Do you want to logout ?",
                                        alertStyle: .alert,
                                        actionTitles: ["Cancel","OK"],
                                        actionStyles: [.cancel, .default],
                                        actions: [
                                            {
                                                _ in
                                                print("Logout cancelled")
                                            },
                                            {
                                                _ in
                                                
                                                self.setUserLogout()
                                            }])
            }
            
            break
            
        default:
            break
        }
    }
    
    func didSelectViewProfile() {
        fromSideMenu = true
        if let points = homeData?.point?.totalPoint {
            let profileVC = ConstantStoryboard.profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileVC.pointsStr = String(points) //String((homeData?.point?.totalPoint)! as Int)
            navigationController?.pushViewController(profileVC, animated: true)
        } else {
            let profileVC = ConstantStoryboard.profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileVC.pointsStr = "0"
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

//MARK: ----Logout Delegate
extension HomeViewController: LogoutDelegate {
    
    fileprivate func setUserLogout() {
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
            guard let fcmToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            let request = LogoutRequest(fcm: fcmToken)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            homeViewModel.postLogoutData(logoutRequest: request, token: token)
        }
    }
    
    fileprivate func sentToLoginPage() {
        //Stop all time step tracking. It will start after Login, Social Login and Signup response
        (UIApplication.shared.delegate as? AppDelegate)?.stopTracking()
        print("Logout Stop Background Tracking-------------------------->")
       
        
        //Facebook Logout-----------
        LoginManager().logOut()
        
        //Store FCM token to reuse--------
        guard let FCMToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
            return
        }
        //Clear all UserDefault
        UserDefaults.resetDefaults()
        //Restore back FCM Device Token
        UserDefaults.standard.set(FCMToken, forKey: ConstantUserDefaultTag.udFCMToken)
        
        //Reset the badge count over the app icon on device.
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udFromBackGround)
        let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let rootNC = UINavigationController(rootViewController: initialViewController)
        rootNC.isNavigationBarHidden = true
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = rootNC
    }
    
    func didReceiveLogoutResponse(logoutResponse: LogoutResponse?) {
        self.view.stopActivityIndicator()
        
        if(logoutResponse?.status != nil && logoutResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(profilePictureUploadResponse)
           
            if let msg = logoutResponse?.message {
                openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                        message: "Logout Successful",
                                        alertStyle: .alert,
                                        actionTitles: ["OK"],
                                        actionStyles: [.default],
                                        actions: [
                                            { _ in
                                                
                                                
                                                fromSideMenu = false
                                                //Goto next page
                                                self.sentToLoginPage()
                                            }
                                        ])
               
               
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: logoutResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveLogoutError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}


extension HomeViewController: TimezoneDelegate {
    fileprivate func updateGMTTimezone() {
        ///Check user timezone to current timezone. If not same then call save api and also update 'userDetails' NSUserdefault
        do {
            if let userData = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserDetails) {
                let data = try JSONDecoder().decode(LoginUserDetails.self, from: userData as! Data)
                
                let currentTimeZone = Date().GMToffsetInHours()
                print("Current Timezone--->\(currentTimeZone)")
                
                if let timezone = data.timeZone {
                    if timezone.count == 0 || timezone == "0:00" {
                        updateTimezone(currentTimezone: currentTimeZone)
                    } else if currentTimeZone != timezone {
                        //Call API
                        updateTimezone(currentTimezone: currentTimeZone)
                    }
                }
            }
        } catch let error {
            print("HomeVC Timezone Error--->\(error.localizedDescription)")
        }
    }
    
    fileprivate func updateTimezone(currentTimezone: String?) {
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
            
            let request = TimezoneRequest(timezone: currentTimezone)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            homeViewModel.postGMTData(timezoneRequest: request, token: token)
        }
    }
    
    func didReceiveTimezoneResponse(timezoneResponse: TimezoneResponse?) {
        self.view.stopActivityIndicator()
        
        if(timezoneResponse?.status != nil && timezoneResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(timezoneResponse)
            
            //If timezone got updated by api then change the userDetails timezone data manually also
            do {
                if let userData = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserDetails) {
                    var data = try JSONDecoder().decode(LoginUserDetails.self, from: userData as! Data)
                    
                    let currentTimeZone = Date().GMToffsetInHours()
                    print("Current Timezone---\(currentTimeZone)")
                    data.timeZone = currentTimeZone
                    
                    let dataEncode = try JSONEncoder().encode(data)
                    UserDefaults.standard.set(dataEncode, forKey: ConstantUserDefaultTag.udUserDetails)
                }
            } catch let error {
                print("HomeVC Error--->\(error.localizedDescription)")
            }
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: timezoneResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveTimezoneError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
