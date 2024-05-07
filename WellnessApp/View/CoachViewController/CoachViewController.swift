//
//  CoachViewController.swift
//  Luvo
//
//  Created by BEASiMAC on 04/07/22.
//
import AVFoundation
import UIKit
var selectedDate = Date()

class CellBannerCoach: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgView1: UIImageView!
    @IBOutlet var lbquotes: UILabel!
    @IBOutlet var lblAuthor: UILabel!
}


class CoachViewController: UIViewController,UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate, UITableViewDataSource,SideMenuDelegate{

    @IBOutlet weak var lblDate: UILabel!
    
   
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    @IBOutlet var collBannerCoach: UICollectionView!
    
    //Button
    @IBOutlet var btnSearch: UIBUtton_Designable!
    
    //View
    @IBOutlet var viewTopBanner: UIView!
    @IBOutlet var txtSearch: UITextField!
    
    //Label
    @IBOutlet var lblQuotes: UILabel!
    @IBOutlet var lblQuoteAuthor: UILabel!
    @IBOutlet weak var tableViewCoach: UITableView!
    
    private var sideMenu:CoachSideViewController!
    private var drawerTransition:DrawerTransition!
    
    @IBOutlet weak var collectionView: UICollectionView!

    var days = [String]()
    var totalSquares = [Int]()
    var totalSquaresNew = [String]()
    var todaydate : String = " "
    var sessionName : String = ""
    var sessionNameNew : String = ""
    var sessionId : String = ""
    var sessionIdNew : String = ""
    var coachId : String = " "
    var coachIdNew : String = " "
    var AppIdAgora : String = ""
    var AppIdAgoraNew : String = ""
    var AcessTokenAgora : String = ""
    var AcessTokenAgoraNew : String = ""
    var ChannelAgora : String = ""
    var ChannelAgoraNew : String = ""
    var CatagoryId : String = ""
    var CatagoryIdNew : String = ""
    var todaysMonth : Int = 1
    var todaysYear : Int = 2023
    var homeViewModel = HomeViewModel()
    var homeData: HomeResponse?
    var CoachViewModel = coachViewModel()
    var agoraCreationModel = AgoraCreationModel()
    var arrCoachdetails : [Deatails]?
    var arrCoachdata : [Datas]?
    var arrId = [String]()
    var arrsessionName = [String]()
    var arrSessionStartTime = [String]()
    var arrsessionEndtime = [String]()
    var arrAssaignOn = [String]()
    var arrCatagoryId = [String]()
    var arrAgoraappId = [String]()
    var arrAgoraAccessToken = [String]()
    var arrAgoraChannelName = [String]()
    var scrollTimer: Timer?
    var currenCallIndex = 0
    var arrQuotes = [String]()
    var arrAuthor = [String]()
    //var CoachstatusDataRequest: CoachViewStatusRequest?
    var CoachstatusData: CoachViewStatusResponse?
    var coachViewStatusModel = CoachViewStatusModel()
    
    var coachSearchModel = CoachSessionSearchModel()
    
    var convertedLocalStartTime : String = ""
    var convertedLocalEndTime : String = ""
    var convertedSessionstartDate : String = ""
    
    var isCallingFirstTime:Bool = true
    
    var isFromLogout:Bool = false
    var permissionValue : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
       

        // Do any additional setup after loading the view.
    }
    
    func checkForPermissions() -> Bool {
        var hasPermissions = false

        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: hasPermissions = true
            default: hasPermissions = requestCameraAccess()
        }
        // Break out, because camera permissions have been denied or restricted.
      //  if !hasPermissions { return
            
      //      false }
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized: hasPermissions = true
            default: hasPermissions = requestAudioAccess()
        }
        return hasPermissions
    }
    
    func requestCameraAccess() -> Bool {
        var hasCameraPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            hasCameraPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasCameraPermission
    }

    func requestAudioAccess() -> Bool {
        var hasAudioPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
            hasAudioPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasAudioPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true
        
        permissionValue = self.checkForPermissions()
        print(permissionValue)
        
//        if permissionValue == true
//        {
//            print("Hello")
//        }
//        else{
//
//            self.checkForPermissions()
//        }
       // isFromLogout = false
        
//        switch AVAudioSession.sharedInstance().recordPermission {
//            case .granted:
//                print("Permission granted")
//            case .denied:
//                print("Permission denied")
//            case .undetermined:
//                print("Request permission here")
//                AVAudioSession.sharedInstance().requestRecordPermission({ granted in
//                    // Handle granted
//
//                })
//            @unknown default:
//                print("Unknown case")
//            }
        
        totalSquares.removeAll()
        days.removeAll()
        totalSquaresNew.removeAll()
        
//        arrCoachdetails.removeAll()
//        arrId.removeAll()
//        arrsessionName.removeAll()
//        arrSessionStartTime.removeAll()
//        arrsessionEndtime.removeAll()
//        arrAssaignOn.removeAll()
//        arrCatagoryId.removeAll()
//        arrAgoraappId.removeAll()
//        arrAgoraAccessToken.removeAll()
//        arrAgoraChannelName.removeAll()
        
      //  self.homeViewModel.delegate = self
        self.homeViewModel.timezoneDelegate = self
        self.CoachViewModel.delegate = self
        self.coachViewStatusModel.coachstatDelegate = self
        self.homeViewModel.logoutDelegate = self
        self.homeViewModel.logoutDelegate = self
        self.coachSearchModel.CoachSessionSearchdelegate = self
        self.agoraCreationModel.AgoraCreationdelegate = self
        setupUI()
        setupCustomNavBar()
        setupSideMenu()
        setWeekView()
        self.updateGMTTimezone()
        
        
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
        let todayDate = dateFormatter.string(from: selectedDate)
        self.getData(dateSelected: todayDate)
        
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            
            return
        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY/MM/dd"
//        let todayDate = dateFormatter.string(from: selectedFDate)
//
//        let request = CoachRequest(sessionDate: todayDate)
//
//        CoachViewModel.postCoachData(date: request, token: token)
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        print("chakra level ...--->>>",chakraLevel)
        print("coloris ...--->>>",chakraColour)
        
       

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isCallingFirstTime = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let todaysDate = dateFormatter.string(from: selectedDate)
        todaydate = todaysDate
        print(todaydate)
        
        
//        if todaydate == "31"
//        {
//            self.collectionView?.scrollToItem(at: IndexPath(row: Int(todaysDate) ?? 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
//            self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
//
//            collectionView .reloadData()
//        }
//        else
//        {
//        let status = UserDefaults.standard.bool(forKey: "Isfromcoachsideview")
//        print(status)
//       //
//       if status==true
//      {
//
//        self.collectionView?.scrollToItem(at: IndexPath(row: Int(30) ?? 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
//        self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
//
//        collectionView .reloadData()
//        //}
//        }
//        else{

            self.collectionView?.scrollToItem(at: IndexPath(row: Int(todaysDate) ?? 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
            self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

            collectionView .reloadData()
      //  }
        
    }
    @objc func sliderNext()
    {
        //homeData?.quotesArray?.count
        debugPrint(homeData?.quotesArray?.count ?? 0)
        
        if currenCallIndex < (arrQuotes.count ) - 1
        {
            currenCallIndex = currenCallIndex + 1
        }
        else{
            
            currenCallIndex = 0
        }
        
        if currenCallIndex == 0
        {
        collBannerCoach.scrollToItem(at: IndexPath(item: currenCallIndex, section: 0), at: .left, animated: false)
        }
        
        else
        {
        collBannerCoach.scrollToItem(at: IndexPath(item: currenCallIndex, section: 0), at: .right, animated: true)
        }
    }
    
    func setWeekView()
    {
        totalSquares.removeAll()
    /*
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 31)

        while (current < nextSunday)
        {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }

//        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
//            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()?*/

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let todaysDate = dateFormatter.string(from: selectedDate)
        todaydate = todaysDate
        print(todaydate)

        dateFormatter.dateFormat = "MM"
        todaysMonth = Int(dateFormatter.string(from: selectedDate)) ?? 0
        print(todaysMonth )
        
        
     
        dateFormatter.dateFormat = "LLL"
        let nameOfMonth = dateFormatter.string(from: selectedDate)
        print(todaydate + " " + nameOfMonth)
        lblDate.text = todaydate + " " + nameOfMonth

        dateFormatter.dateFormat = "YYYY"
        todaysYear = Int(dateFormatter.string(from: selectedDate)) ?? 2023
        print(todaysYear )
        getDaysInMonth(month: todaysMonth , year:todaysYear )

       // getDaysInMonth(month:(todaysMonth ?? 0) + 1 , year:todaysYear ?? 0)


        //totalSquares.append(todaysDate) wb24r3802


      //  tableView.reloadData()
    }
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 4
       let height = (collectionView.frame.size.height - 2)

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

    func getDaysInMonth(month: Int, year: Int)  {
            let calendar = Calendar.current

            var startComps = DateComponents()
            startComps.day = 1
            startComps.month = month
            startComps.year = year

            var endComps = DateComponents()
            endComps.day = 1
            endComps.month = month == 12 ? 1 : month + 1
            endComps.year = month == 12 ? year + 1 : year


            let startDate = calendar.date(from: startComps)!
            let endDate = calendar.date(from:endComps)!


            let diff = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
            let numberOfDays : Int = (diff.day ?? 0)
            let numberOfDaysNew : Int = numberOfDays + 1

        for i in 1...numberOfDaysNew {
            print(i)
            
            if i <= numberOfDays
            {
                totalSquares.append(i)
                totalSquaresNew.append(String(i))
                debugPrint(totalSquaresNew)
            }
            else{
                
                totalSquares.append(i)
                totalSquaresNew.append(String(""))
                debugPrint(totalSquaresNew)
            }
           
            if i <= numberOfDays
            {

            let calendar = Calendar.current
            var dateComponents = DateComponents.init()
            dateComponents.day = Int(i)
            dateComponents.month = month
            dateComponents.year = year

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "EEEE"

            guard let date = calendar.date(from: dateComponents) else { return }

            let weekday = dateFormatter.string(from: date)

            let capWeekday = weekday.capitalized

            days.append(capWeekday)

            debugPrint(days)
            }
            
            else{
                
                days.append("")
                
            }


        }
        
        debugPrint(totalSquaresNew)

            //totalSquares.append(numberOfDays)
           // debugPrint(totalSquares)
        }
    @IBAction func btnSideMenu(_ sender: Any) {
        drawerTransition.presentDrawerViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }

    @IBAction func btnViewAll(_ sender: Any) {
        let LiveVC = ConstantStoryboard.Coach.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
        navigationController?.pushViewController(LiveVC, animated: true)
        
    }
    @IBAction func btnNext(_ sender: Any) {
        isCallingFirstTime = false
        totalSquares.removeAll()
        days.removeAll()
        totalSquaresNew.removeAll()
      todaysMonth += 1
        if todaysMonth == 13
        {
            todaysMonth = 1
            todaysYear = todaysYear + 1
        }
        print(todaysMonth)
        print(todaysYear)
      print(todaysMonth)
     getDaysInMonth(month: todaysMonth , year:todaysYear )
        collectionView.reloadData()
        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        

    }
    @IBAction func btnPrev(_ sender: Any) {
        isCallingFirstTime = false
        totalSquaresNew.removeAll()
        totalSquares.removeAll()
        days.removeAll()
      todaysMonth -= 1
      
        if todaysMonth == 0
        {
            todaysMonth = 12
            todaysYear = todaysYear - 1
        }
        print(todaysMonth)
        print(todaysYear)
     getDaysInMonth(month: todaysMonth , year:todaysYear )
        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        collectionView.reloadData()
        
    }
    @IBAction func btnSearch(_ sender: Any) {
//        let searchVC = ConstantStoryboard.searchStoryboard.instantiateViewController(withIdentifier: "SearchMeditationViewController") as! SearchMeditationViewController
//        searchVC.messageQuetes = lblQuotes.text!
//        searchVC.authorName = lblQuoteAuthor.text!
//        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: - Setup Custom Navbar
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    func setupSideMenu() {
        sideMenu = ConstantStoryboard.CoachSideMenu.instantiateViewController(withIdentifier: "CoachSideViewController") as? CoachSideViewController
        sideMenu.delegate = self
        drawerTransition = DrawerTransition(target: self, drawer: sideMenu)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // [coachResponse?.data?.quotesArray?.count]
     //   guard let breathArray = homeData?.exercises else { return 0 }

        if collectionView == collBannerCoach {
          //  return breathArray.count
            return arrQuotes.count
        }
        else
        {
          return totalSquares.count
           // return 32
        }

       // return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collBannerCoach {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellBannerCoach", for: indexPath) as! CellBannerCoach
            
            cell.lbquotes.text = arrQuotes[indexPath.row]
            cell.lblAuthor.text = arrAuthor[indexPath.row]


         //   let image = UIImage(named:"bannerHome")?.withTintColor(.systemPink, renderingMode: .alwaysTemplate)
            cell.imgView.image = UIImage(named:"bannerHome")
            cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

//            let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
//            let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
//            print("chakra level ...--->>>",chakraLevel)
//            print("coloris ...--->>>",chakraColour)
//            let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
//
//                    print(crownList)


    //        for view in viewTopBanner.subviews{
    //            view.removeFromSuperview()
    //        }

             // this gets things done
           // view.subviews.map({ $0.removeFromSuperview() })

//            if chakraColour==0 {
//                switch chakraLevel {
//                case 1:
//
//                    cell.imgView1.backgroundColor  = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
//                    break
//
//                case 3:
//
//                    cell.imgView1.backgroundColor =  #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
//
//                    break
//                case 4:
//
//                    cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
//
//                    break
//                case 5:
//
//                    cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
//
//                    break
//                case 2:
//
//                    cell.imgView1.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
//
//                    break
//                case 6:
//
//                    cell.imgView1.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
//
//                    break
//                case 7:
//
//                    cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
//
//                    break
//
//                default:
//
//                    break
//                }
//            }
//            else if crownList == 1 {
//                switch chakraColour {
//
//                        case 1:
//
//                            cell.imgView1.backgroundColor  = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
//                            break
//
//                        case 3:
//
//                            cell.imgView1.backgroundColor =  #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
//
//                            break
//                        case 4:
//
//                            cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
//
//                            break
//                        case 5:
//
//                            cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
//
//                            break
//                        case 2:
//
//                            cell.imgView1.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
//
//                            break
//                        case 6:
//
//                            cell.imgView1.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
//
//                            break
//                        case 7:
//
//                            cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
//
//
//                default:
//                    break
//                }
//            }
//                else {
//                    switch chakraLevel {
//                    case 1:
//
//                        cell.imgView1.backgroundColor  = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
//                        break
//
//                    case 3:
//
//                        cell.imgView1.backgroundColor =  #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
//
//                        break
//                    case 4:
//
//                        cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
//
//                        break
//                    case 5:
//
//                        cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
//
//                        break
//                    case 2:
//
//                        cell.imgView1.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
//
//                        break
//                    case 6:
//
//                        cell.imgView1.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
//
//                        break
//                    case 7:
//
//                        cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
//
//                        break
//
//                    default:
//
//                        break
//
//                    }
//
//                }

            return cell
            
        }else{
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell

      //  let date = totalSquares[indexPath.item]
      //  cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
      //  cell.dayOfweek.text = String(day[indexPath.item])
        cell.dayOfweek.text = String(days[indexPath.row].prefix(3))
        cell.dayOfMonth.text = String(totalSquaresNew[indexPath.row])

        debugPrint(indexPath.row)

        let today: Int = Int(todaydate) ?? 0

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "M"
        let todayDate1 = dateFormatter1.string(from: selectedDate)
        print(todaysMonth)

   if todayDate1.contains(String(todaysMonth))
   {
        if indexPath.row == today - 1
        {
            cell.backgroundColor = #colorLiteral(red: 0.5882352941, green: 0.06274509804, blue: 0.6078431373, alpha: 1)
        }
        else

        {
            cell.backgroundColor = UIColor.white
        }
   }
        else
        {
            if indexPath.row == 0
            {
                cell.backgroundColor = #colorLiteral(red: 0.5882352941, green: 0.06274509804, blue: 0.6078431373, alpha: 1)
            }
            else

            {
                cell.backgroundColor = UIColor.white
            }
            
        }

//        if(date == selectedDate)
//        {
//            cell.backgroundColor = UIColor.systemGreen
//        }
//        else
//        {
//            cell.backgroundColor = UIColor.white
//        }
        
        return cell
    }
        

}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
      //  selectedDate = totalSquares[indexPath.item]
      //  collectionView.reloadData()
       // tableView.reloadData()

//        debugPrint(Int(todaydate) ?? 0)
//
       
//            let indexpat = IndexPath(row: (Int(todaydate) ?? 0)-1, section: 0)
//
//            if let cell = collectionView.cellForItem(at: indexpat){
//                   cell.backgroundColor = UIColor.white
            
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "M"
                    let todayDate1 = dateFormatter1.string(from: selectedDate)
                    print(todaysMonth)
            
            if todayDate1.contains(String(todaysMonth))
            {
                
                if (Int(todaydate) ?? 0)>0
                {
            
            

            self.collectionView(self.collectionView, didDeselectItemAt: IndexPath(item: (Int(todaydate) ?? 0)-1, section: 0))
               }
                
                
        
            }
        else
        {
            print("Hello")
           // self.collectionView?.scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
            self.collectionView(self.collectionView, didDeselectItemAt: IndexPath(item: 0, section: 0))
        }


 //       }

//
//
//        if let cell = collectionView.cellForItem(at: indexpath)
//        {
//            cell.backgroundColor = UIColor.white
//
//        }
        
     
        
        if totalSquares[indexPath.row] == Int(1)
        {
            print("try")
            if todayDate1.contains(String(todaysMonth))
            {
                if isCallingFirstTime == false
                {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM"
                    var todaysMonth = Int(dateFormatter.string(from: selectedDate))
                    var todaysMonthNew : String = ""
                    if todaysMonth == 1
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    
                    if todaysMonth == 2
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 3
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 4
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 5
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 6
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 7
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 8
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 9
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 10
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 11
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }
                    if todaysMonth == 12
                    {
                        todaysMonthNew = (String(format: "%02d", todaysMonth!))
                        print(todaysMonthNew )
                     }

                dateFormatter.dateFormat = "YYYY"
                let todaysYearr = Int(dateFormatter.string(from: selectedDate))
                print(todaysYearr ?? 0)

//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "d"
//                let todaysDate = dateFormatter.string(from: selectedDate)
//                todaydate = todaysDate
//                print(todaydate)

               // let datee = String(todaysYear ?? 0) + "-" + String(todaysMonth ?? 0) + "-" + String(totalSquares[indexPath.row])
                    
                    if todaysYearr == todaysYear
                    {
               // let datee = String(todaysYear ?? 0) + "-" + String(todaysMonth ?? 0) + "-" + String(todaydate)
                        let datee = String(todaysYear ) + "-" + todaysMonthNew + "-" + String(todaydate)
                //////////////////////
                ///
                print(todaydate)
                print(datee)
                print(DateToMonth(dateStr: datee) ?? 2023-01-01)
                lblDate.text = DateToMonth(dateStr: datee)
//               // self.collectionView?.scrollToItem(at: IndexPath(row: Int(todaydate) ?? 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
//              //  self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
                self.getData(dateSelected: datee)
//
                collectionView.reloadData()
                
                
                self.viewWillAppear(true)
                }
                    else
                    {
                        print("Hello")
                    }
                }
                
            }
            else
            {
                print("Hello")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM"
                let todaysMonths = Int(dateFormatter.string(from: selectedDate))
                print(todaysMonths ?? 0)

                var todaysMonthNew : String = ""
                if todaysMonth == 1
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }

                if todaysMonth == 2
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 3
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 4
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 5
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 6
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 7
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 8
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 9
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 10
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 11
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 12
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }

                
                dateFormatter.dateFormat = "YYYY"
                let todaysYear = Int(dateFormatter.string(from: selectedDate))
                print(todaysYear ?? 0)
                
                let datee = String(todaysYear ?? 0) + "-" + todaysMonthNew + "-" + String(totalSquares[indexPath.row])
                print(totalSquares[indexPath.row])
                print(datee)
                print(DateToMonth(dateStr: datee) ?? 2023-01-01)
                lblDate.text = DateToMonth(dateStr: datee)
                self.getData(dateSelected: datee)
            //////
            }
        }
        else
        {
            if todayDate1.contains(String(todaysMonth))
            {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            let todaysMonth = Int(dateFormatter.string(from: selectedDate))
            print(todaysMonth ?? 0)


                var todaysMonthNew : String = ""
                if todaysMonth == 1
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }

                if todaysMonth == 2
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 3
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 4
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 5
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 6
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 7
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 8
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 9
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 10
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 11
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 12
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth!))
                    print(todaysMonthNew )
                 }
            
            dateFormatter.dateFormat = "YYYY"
            let todaysYear = Int(dateFormatter.string(from: selectedDate))
            print(todaysYear ?? 0)
            
            let datee = String(todaysYear ?? 0) + "-" + todaysMonthNew + "-" + String(totalSquares[indexPath.row])
            
            print(datee)
            print(DateToMonth(dateStr: datee) ?? 2023-01-01)
            lblDate.text = DateToMonth(dateStr: datee)
            self.getData(dateSelected: datee)
            }
            
            else
            {
                print("Hello")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM"
                let todaysMonths = Int(dateFormatter.string(from: selectedDate))
                print(todaysMonths ?? 0)

                var todaysMonthNew : String = ""
                if todaysMonth == 1
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }

                if todaysMonth == 2
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 3
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 4
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 5
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 6
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 7
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 8
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 9
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 10
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 11
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }
                if todaysMonth == 12
                {
                    todaysMonthNew = (String(format: "%02d", todaysMonth))
                    print(todaysMonthNew )
                 }

                dateFormatter.dateFormat = "YYYY"
                let todaysYear = Int(dateFormatter.string(from: selectedDate))
                print(todaysYear ?? 0)
                
                let datee = String(todaysYear ?? 0) + "-" + todaysMonthNew + "-" + String(totalSquares[indexPath.row])
                print(totalSquares[indexPath.row])
                print(datee)
                print(DateToMonth(dateStr: datee) ?? 2023-01-01)
                lblDate.text = DateToMonth(dateStr: datee)
                self.getData(dateSelected: datee)
            }
        }

            if let cell = collectionView.cellForItem(at: indexPath){
               //cell.backgroundColor = UIColor.systemGreen
                cell.backgroundColor = #colorLiteral(red: 0.5882352941, green: 0.06274509804, blue: 0.6078431373, alpha: 1)
           }

  //      }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        debugPrint(Int(todaydate) ?? 0)

           if let cell = collectionView.cellForItem(at: indexPath){
                cell.backgroundColor = UIColor.white
           }


        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       
        return arrId.count // Here also
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == tableViewCoach,
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoachTableViewCell") as? CoachTableViewCell {
            
            debugPrint(arrAgoraAccessToken[indexPath.row])
            debugPrint(arrAgoraChannelName[indexPath.row])
            
            convertedLocalStartTime = utcToLocal(dateStr: arrSessionStartTime[indexPath.row] as Any as! String) ?? "text"
            convertedSessionstartDate = SessionDate(dateStr: arrSessionStartTime[indexPath.row] as Any as! String) ?? "text"
            convertedLocalEndTime = utcToLocal(dateStr: arrsessionEndtime[indexPath.row] as Any as! String) ?? "text"
           
            cell.sessionTimeDuration.text = utcToLocal(dateStr: arrSessionStartTime[indexPath.row] as Any as! String)
            cell.sessionName.text = arrsessionName[indexPath.row]
            cell.sessionTimeDuration.text = convertedLocalStartTime + "-" + convertedLocalEndTime
            cell.btnStart.tag = indexPath.row
            cell.btnStart.addTarget(self, action: #selector(BtnCall(sender:)), for: .touchUpInside)
            debugPrint(arrsessionName[indexPath.row])
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func BtnCall(sender: UIButton)
    {
        let buttonTag = sender.tag
        print(buttonTag)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            print("hugranted")
            // Already Authorized
            
            
            
            print(convertedLocalStartTime)
            print(convertedLocalEndTime)
            print(convertedSessionstartDate)

            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "h:mm a"
            let dateString = df.string(from: date)
            
            let fd = DateFormatter()
            fd.dateFormat = "yyyy-MM-dd"
            let dateString1 = fd.string(from: date)
            
            if convertedSessionstartDate == dateString1
            {
            // if convertedLocalEndTime < dateString
                if convertedLocalStartTime == dateString || convertedLocalStartTime < dateString
    //             if convertedLocalStartTime == dateString || convertedLocalStartTime < dateString && convertedLocalEndTime < dateString
                    {
                print("Done")
                
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }

            
                   
                sessionId = arrId[buttonTag]
                CatagoryId = arrCatagoryId[buttonTag]
                    AppIdAgora = arrAgoraappId[buttonTag]
                AcessTokenAgora = arrAgoraAccessToken[buttonTag]
                ChannelAgora  = arrAgoraChannelName[buttonTag]
                sessionName = arrsessionName[buttonTag]
                    
                    
                    print("SESionId<><<>",sessionId)
                    print("CatagoryId<><><>",CatagoryId)
                    print("AppIdAgora<><><><>",AppIdAgora)
                    print("AcessTokenAgora<><><>",AcessTokenAgora)
                    print("ChannelAgora<><><><>",ChannelAgora)
                    print("sessionName<><><><>",sessionName)
                    
                    self.agoraCreationModel.AgoraCreationDetails(token: token, SessionId: sessionId)
                 
                
                print(AcessTokenAgora)
                }
                else
                {
                    print("None")
                    
                    let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                        self.view.stopActivityIndicator()
                        
                    }))

        //            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        //                  print("Handle Cancel Logic here")
        //            }))

                    present(refreshAlert, animated: true, completion: nil)
                }
            }
            else
            {
                print("None")
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                      print("Handle Ok logic here")
                    self.view.stopActivityIndicator()
                    
                }))

    //            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //                  print("Handle Cancel Logic here")
    //            }))

                present(refreshAlert, animated: true, completion: nil)
            }
            
            
            
         
            
    //        let LiveVC = ConstantStoryboard.CoachSideMenu.instantiateViewController(withIdentifier: "CoachViewAgoraVC") as! CoachViewAgoraVC
    ////                        LiveVC.sessionId = sessionId
    ////                        LiveVC.AgoraAppId = AppIdAgora
    ////                        LiveVC.Agoaratoken = AcessTokenAgora
    ////                        LiveVC.channelName = ChannelAgora
    //        navigationController?.pushViewController(LiveVC, animated: true)
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
               if granted == true {
                   
                   print("granted")
                   // User granted
               } else {
                   
                   print("Not granted")
                   
                   self.presentCameraSettings()
                   //self.checkForPermissions()
                   // User rejected
               }
           })
        }
    }
    
    func DateToMonth(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
           // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.timeZone = TimeZone.current
            
            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "dd LLL"
            
                return dateFormatter.string(from: date)
            }
            return nil
    }
    
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "h:mm a"
            
                return dateFormatter.string(from: date)
            }
            return nil
    }
    
    
    func SessionDate(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "yyyy-MM-dd"
            
                return dateFormatter.string(from: date)
            }
            return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        debugPrint(arrsessionName[indexPath.row].count)

        if tableView == tableViewCoach
        {
            if Int(arrsessionName[indexPath.row].count) < 50
            {
            return 90 //Choose your custom row height
            }
            else if Int(arrsessionName[indexPath.row].count) > 49 && Int(arrsessionName[indexPath.row].count) < 101
            {
                return 115
            }
            else if Int(arrsessionName[indexPath.row].count) > 101 && Int(arrsessionName[indexPath.row].count) < 151
            {
                return 170
            }
            else
            {
                return 70
            }
        }
        return 0
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            print("hugranted")
            // Already Authorized
            
            
            
            print(convertedLocalStartTime)
            print(convertedLocalEndTime)
            print(convertedSessionstartDate)

            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "h:mm a"
            let dateString = df.string(from: date)
            
            let fd = DateFormatter()
            fd.dateFormat = "yyyy-MM-dd"
            let dateString1 = fd.string(from: date)
            
            if convertedSessionstartDate == dateString1
            {
            // if convertedLocalEndTime < dateString
                if convertedLocalStartTime == dateString || convertedLocalStartTime < dateString
    //             if convertedLocalStartTime == dateString || convertedLocalStartTime < dateString && convertedLocalEndTime < dateString
                    {
                print("Done")
                
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }

            
                   
                sessionId = arrId[indexPath.row]
                CatagoryId = arrCatagoryId[indexPath.row]
                AppIdAgora = arrAgoraappId[indexPath.row]
                AcessTokenAgora = arrAgoraAccessToken[indexPath.row]
                ChannelAgora  = arrAgoraChannelName[indexPath.row]
                sessionName = arrsessionName[indexPath.row]
                    
                    
                    print("SESionId<><<>",sessionId)
                    print("CatagoryId<><><>",CatagoryId)
                    print("AppIdAgora<><><><>",AppIdAgora)
                    print("AcessTokenAgora<><><>",AcessTokenAgora)
                    print("ChannelAgora<><><><>",ChannelAgora)
                    print("sessionName<><><><>",sessionName)
                    
                    self.agoraCreationModel.AgoraCreationDetails(token: token, SessionId: sessionId)
                 
                
                print(AcessTokenAgora)
                }
                else
                {
                    print("None")
                    
                    let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                        self.view.stopActivityIndicator()
                        
                    }))

        //            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        //                  print("Handle Cancel Logic here")
        //            }))

                    present(refreshAlert, animated: true, completion: nil)
                }
            }
            else
            {
                print("None")
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                      print("Handle Ok logic here")
                    self.view.stopActivityIndicator()
                    
                }))

    //            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //                  print("Handle Cancel Logic here")
    //            }))

                present(refreshAlert, animated: true, completion: nil)
            }
            
            
            
         
            
    //        let LiveVC = ConstantStoryboard.CoachSideMenu.instantiateViewController(withIdentifier: "CoachViewAgoraVC") as! CoachViewAgoraVC
    ////                        LiveVC.sessionId = sessionId
    ////                        LiveVC.AgoraAppId = AppIdAgora
    ////                        LiveVC.Agoaratoken = AcessTokenAgora
    ////                        LiveVC.channelName = ChannelAgora
    //        navigationController?.pushViewController(LiveVC, animated: true)
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
               if granted == true {
                   
                   print("granted")
                   // User granted
               } else {
                   
                   print("Not granted")
                   
                   self.presentCameraSettings()
                   //self.checkForPermissions()
                   // User rejected
               }
           })
        }
        
        /*
        
        print(convertedLocalStartTime)
        print(convertedLocalEndTime)
        print(convertedSessionstartDate)

        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        let dateString = df.string(from: date)
        
        let fd = DateFormatter()
        fd.dateFormat = "yyyy-MM-dd"
        let dateString1 = fd.string(from: date)
        
        if convertedSessionstartDate == dateString1
        {
        // if convertedLocalEndTime < dateString
            if convertedLocalStartTime == dateString || convertedLocalStartTime < dateString
//             if convertedLocalStartTime == dateString || convertedLocalStartTime < dateString && convertedLocalEndTime < dateString
                {
            print("Done")
            
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }

            let request = CoachViewStatusRequest(status: "active", sessId: arrId[indexPath.row], agoraSId: "", coachId: coachId, ctgryId: arrCatagoryId[indexPath.row], agoraResourceId: "", agoraAccessToken: arrAgoraAccessToken[indexPath.row], channelName: arrAgoraChannelName[indexPath.row])
            coachViewStatusModel.postCoachStatusData(Request: request, token: token)
            sessionId = arrId[indexPath.row]
            CatagoryId = arrCatagoryId[indexPath.row]
            AppIdAgora = arrAgoraappId[indexPath.row]
            AcessTokenAgora = arrAgoraAccessToken[indexPath.row]
            ChannelAgora  = arrAgoraChannelName[indexPath.row]
            sessionName = arrsessionName[indexPath.row]
             
            
            print(AcessTokenAgora)
            }
            else
            {
                print("None")
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                      print("Handle Ok logic here")
                    self.view.stopActivityIndicator()
                    
                }))

    //            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //                  print("Handle Cancel Logic here")
    //            }))

                present(refreshAlert, animated: true, completion: nil)
            }
        }
        else
        {
            print("None")
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.view.stopActivityIndicator()
                
            }))

//            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                  print("Handle Cancel Logic here")
//            }))

            present(refreshAlert, animated: true, completion: nil)
        }
        
        
        
     
        
//        let LiveVC = ConstantStoryboard.CoachSideMenu.instantiateViewController(withIdentifier: "CoachViewAgoraVC") as! CoachViewAgoraVC
////                        LiveVC.sessionId = sessionId
////                        LiveVC.AgoraAppId = AppIdAgora
////                        LiveVC.Agoaratoken = AcessTokenAgora
////                        LiveVC.channelName = ChannelAgora
//        navigationController?.pushViewController(LiveVC, animated: true)
        */
    }
    
    func presentCameraSettings() {
        
        DispatchQueue.main.async {
        let alertController = UIAlertController (title: "Lovo", message: "Luvo needs camera and micrphone acess permission to start this session, allow permission from settings", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
    }
    }
    
    // UITextField Delegates
        func textFieldDidBeginEditing(_ textField: UITextField) {
            print("TextField did begin editing method called")
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            print("TextField did end editing method called\(textField.text!)")
        }
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            print("TextField should begin editing method called")
            return true;
        }
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            print("TextField should clear method called")
            return true;
        }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            print("TextField should end editing method called")
            return true;
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            print("While entering the characters this method gets called")
            if let text = txtSearch.text as NSString? {
                    let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
                   print(txtAfterUpdate)
                
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return false
                }
                coachSearchModel.getSessionDetails(token: token, sessionName: txtAfterUpdate)
                }
           
            return true;
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("TextField should return method called")
            
     
           
            textField.resignFirstResponder();
            return true;
        }
}

extension CoachViewController{
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
            let blogVC = ConstantStoryboard.CoachRecoredeSessionlist.instantiateViewController(withIdentifier: "CoachRecordedListVC") as! CoachRecordedListVC
            navigationController?.pushViewController(blogVC, animated: true)
            break

//        case 2:
//            //Favourite
//            let favVC = ConstantStoryboard.favouriteStoryboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
//            navigationController?.pushViewController(favVC, animated: true)
//            break
//
//        case 3:
//            //Chakra Level
//            let chakraVC = ConstantStoryboard.chakraLevelStoryboard.instantiateViewController(withIdentifier: "ChakraLevelViewController") as! ChakraLevelViewController
//            navigationController?.pushViewController(chakraVC, animated: true)
//            break

        case 2:
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

//        case 5:
//            //FAQ
//            let faqVC = ConstantStoryboard.faqStoryboard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
//            navigationController?.pushViewController(faqVC, animated: true)
//            break

        case 3:
            //Terms Of Services
            let termsVC = ConstantStoryboard.termsStoryboard.instantiateViewController(withIdentifier: "TermsAndServicesViewController") as! TermsAndServicesViewController
            navigationController?.pushViewController(termsVC, animated: true)
            break

        case 4:
            //Conact Us
            let contactVC = ConstantStoryboard.contactStoryboard.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            navigationController?.pushViewController(contactVC, animated: true)
            break

        case 5:
            //Chat With Admin
            let chatVC = ConstantStoryboard.chatStoryboard.instantiateViewController(withIdentifier: "ChatWithAdminVC") as! ChatWithAdminVC
            navigationController?.pushViewController(chatVC, animated: true)
            break


        case 6:
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

        case 7:
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
extension CoachViewController: LogoutDelegate {

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
     //   LoginManager().logOut()

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


extension CoachViewController: CoachViewStatusModelDelegate
{
    func didReceiveCoachViewStatusModelResponse(coachResponse: CoachViewStatusResponse?) {
        
        self.view.stopActivityIndicator()
        
        if(coachResponse?.status != nil && coachResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
            
            debugPrint(AcessTokenAgoraNew)
            debugPrint(ChannelAgoraNew)
                        let LiveVC = ConstantStoryboard.CoachSideMenu.instantiateViewController(withIdentifier: "CoachViewAgoraVC") as! CoachViewAgoraVC
                        LiveVC.sessionId = sessionIdNew
                        LiveVC.AgoraAppId = AppIdAgoraNew
                        LiveVC.Agoaratoken = AcessTokenAgoraNew
                        LiveVC.channelName = ChannelAgoraNew
                        LiveVC.coachId = coachIdNew
                        LiveVC.CatagoryId = CatagoryIdNew
                        LiveVC.SessionName = sessionNameNew
            LiveVC.agoraSId = (coachResponse?.results?.agoraSId)!
            LiveVC.agoraResourceId = (coachResponse?.results?.agoraResourceId)!
                        navigationController?.pushViewController(LiveVC, animated: true)

            
        }else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        
    }
    
    func didReceiveCoachViewStatusModelError(statusCode: String?) {
        
    }
    
    
}


extension CoachViewController: CoachViewModelDelegate
{
    func didReceiveCoachResponse(coachResponse: CoachResponse?) {
        
        self.view.stopActivityIndicator()
        
        if(coachResponse?.status != nil && coachResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
          //  print(coachResponse?.data?.quote?.authorName)
            
         //   coachResponse?.data?.coachId
            print([coachResponse?.details])
            
            
            //
            print([coachResponse?.data?.quotesArray?.count])
            lblQuotes.text = (coachResponse?.data?.quote?.quote)!
            lblQuoteAuthor.text = (coachResponse?.data?.quote?.authorName)!
            coachId = (coachResponse?.data?.coachId)!
            arrCoachdetails = coachResponse?.details
            
            arrId.removeAll()
            arrsessionName.removeAll()
            arrSessionStartTime.removeAll()
            arrsessionEndtime.removeAll()
            arrAssaignOn.removeAll()
            arrCatagoryId.removeAll()
            arrAgoraappId.removeAll()
            arrAgoraAccessToken.removeAll()
            arrAgoraChannelName.removeAll()
            arrQuotes.removeAll()
            arrAuthor.removeAll()
            
            for index in 0..<arrCoachdetails!.count {
               
                arrId.append(arrCoachdetails![index]._id!)
                arrsessionName.append(arrCoachdetails![index].sessionName!)
                arrSessionStartTime.append(arrCoachdetails![index].sessionStarttime!)
                arrsessionEndtime.append(arrCoachdetails![index].sessionEndtime!)
                arrAssaignOn.append(arrCoachdetails![index].assignOn!)
                arrCatagoryId.append(arrCoachdetails![index].ctgryId!)
                arrAgoraappId.append(arrCoachdetails![index].agoraAppId!)
                arrAgoraAccessToken.append(arrCoachdetails![index].agoraAccessToken!)
                arrAgoraChannelName.append(arrCoachdetails![index].chennelName!)
            }
            
            
            for index in 0..<(coachResponse?.data?.quotesArray!.count ?? 0)
            {
               debugPrint(index)
                arrQuotes.append(coachResponse?.data?.quotesArray![index].quote ?? "Test")
                arrAuthor.append(coachResponse?.data?.quotesArray![index].authorName ?? "Test")

            }
            debugPrint(arrQuotes.count)
            debugPrint(arrQuotes)
            debugPrint(arrsessionName.count)
            tableViewCoach.reloadData()
            collBannerCoach.reloadData()
            scrollTimer?.invalidate()
            scrollTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(sliderNext), userInfo: nil, repeats: true)

          
         //   guard let arrayQuestion =  arrCoachdetails?[0]._id else { return }
            
            
        }else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveCoachError(statusCode: String?) {
        
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func setupUI() {
        NotificationCenter.default.post(name: Notification.Name(ConstantLocalNotification.refreshHomeButtonColor), object: nil)
        
        //Label
      //  lblHeartClick.layer.cornerRadius = 8.0
      //  lblHeartClick.layer.masksToBounds = true
      ///  lblPointsClick.layer.cornerRadius = 8.0
       // lblPointsClick.layer.masksToBounds = true
        
      //  viewSteps.layer.borderColor = UIColor.colorSetup().cgColor
       // viewWaterIntake.layer.borderColor = UIColor.colorSetup().cgColor
       // viewMood.layer.borderColor = UIColor.colorSetup().cgColor
      //  viewHeartRate.layer.borderColor = UIColor.colorSetup().cgColor
       /// viewSleep.layer.borderColor = UIColor.colorSetup().cgColor
      //  viewPoints.layer.borderColor = UIColor.colorSetup().cgColor
        
      //  lblHeartClick.backgroundColor = UIColor.colorSetup()
      //  lblPointsClick.backgroundColor = UIColor.colorSetup()
        
      //  btnSearch.backgroundColor = UIColor.colorSetup()
      //  btnBreathViewAll.setTitleColor(UIColor.colorSetup(), for: .normal)
      //  btnBlogViewAll.setTitleColor(UIColor.colorSetup(), for: .normal)
      //  btnRecordedsession.setTitleColor(UIColor.colorSetup(), for: .normal)
      //  btnLivesession.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        //Color setup according to chakra level
   //     let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
  //      let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        
        let chakraLevel = 7
        let chakraColour = 0
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
            //    viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
           //     imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
           //     imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
           //     imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
            //    imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
           //     imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
            //    imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
            //    imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)
                
                break
                
            case 2:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a25e"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
         //       viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)
                
           //     imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.orange_steps)
          //      imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.orange_water)
           //     imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.orange_mood)
            //    imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.orange_heart)
            //    imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.orange_sleep)
        //        imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.orange_points)
         //       imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.orange_gratitude)
                
                break
                
            case 3:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb201","#fedd8f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
         //       viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)
                
          //      imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_steps)
           //     imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_water)
           //     imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_mood)
            //    imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_heart)
             //   imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_sleep)
             //   imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_points)
            //    imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_gratitude)
                
                break
                
            case 4:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#03a72e","#7fd295"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
            //    viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
                
           //     imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.green_steps)
           //     imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.green_water)
           //     imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.green_mood)
            //    imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.green_heart)
           //     imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.green_sleep)
           //     imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.green_points)
          //      imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.green_gratitude)
                
                break
                
            case 5:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#03aeef","#a2e1f9"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
            //    viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
//
            //    imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.sky_steps)
            //    imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.sky_water)
            //    imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.sky_mood)
            //    imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.sky_heart)
            //    imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.sky_sleep)
            //    imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.sky_points)
            //    imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.sky_gratitude)
                
                break
            
            case 6:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#612da9","#a487ce"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
           //     viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
           //     imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.violet_steps)
           //     imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.violet_water)
            //    imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.violet_mood)
            //    imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.violet_heart)
           //     imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.violet_sleep)
           //     imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.violet_points)
           //     imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.violet_gratitude)
                
                break
                
            case 7:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#a81f93","#e9c7e4"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
          //      viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
          //      imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.purple_steps)
          //      imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.purple_water)
           //     imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.purple_mood)
           //     imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.purple_heart)
           //     imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.purple_sleep)
          //      imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.purple_points)
           //     imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.purple_gratitude)
                
                break
                
            default:
                //red
               
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
            //    viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                
                
           //     imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
           //     imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
            //    imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
            //    imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
           //     imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
          //      imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
            //    imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)
                
                break
            }
        } else {
            switch chakraColour {


            case 1:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
          //      viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)

           //     imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
           //     imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
           //     imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
           //     imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
           //     imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
          //      imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
             //   imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)

                break

            case 2:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a25e"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
           //     viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)

          //      imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.orange_steps)
          //      imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.orange_water)
           //     imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.orange_mood)
          //      imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.orange_heart)
           //     imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.orange_sleep)
           //     imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.orange_points)
           //     imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.orange_gratitude)

                break

            case 3:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb201","#fedd8f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
         //       viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)

       //         imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_steps)
         //       imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_water)
          //      imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_mood)
           //     imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_heart)
         //       imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_sleep)
           //     imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_points)
          //      imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.yellow_gratitude)

                break

            case 4:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//
//                viewTopBanner.setGradientBackground(hexColor: ["#03a72e","#7fd295"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
       //         viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
        //        imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.green_steps)
        //        imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.green_water)
         //       imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.green_mood)//
        //        imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.green_heart)
        //        imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.green_sleep)
        //        imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.green_points)
        //        imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.green_gratitude)

                break

            case 5:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#03aeef","#a2e1f9"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
        //        viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)

       //         imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.sky_steps)
         //       imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.sky_water)
       //         imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.sky_mood)
        //        imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.sky_heart)
        //        imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.sky_sleep)
        //        imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.sky_points)
         //       imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.sky_gratitude)

                break

            case 6:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#612da9","#a487ce"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
      //          viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
//
      //          imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.violet_steps)
      //          imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.violet_water)
      //          imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.violet_mood)
      //          imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.violet_heart)
       //         imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.violet_sleep)
        //        imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.violet_points)
        //        imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.violet_gratitude)

                break

            case 7:
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#a81f93","#e9c7e4"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
       //         viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)

      //          imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.purple_steps)
      //          imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.purple_water)
       //         imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.purple_mood)
       //         imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.purple_heart)
      //          imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.purple_sleep)
      //          imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.purple_points)
       //         imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.purple_gratitude)

                break

            default:
                //red
//                viewTopBanner.backgroundColor=UIColor.clear
//                viewTopBanner.setNeedsDisplay()
//                viewTopBanner.setGradientBackground(hexColor: ["#ed000a","#f4696f"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
//                viewGratitudeBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
      //          viewGratitudeBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                

      //          imgSteps.image = UIImage.init(named: ConstantThemeHomeIcon.red_steps)
       //         imgWaterIntake.image = UIImage.init(named: ConstantThemeHomeIcon.red_water)
      //         imgMood.image = UIImage.init(named: ConstantThemeHomeIcon.red_mood)
      //          imgHeartRate.image = UIImage.init(named: ConstantThemeHomeIcon.red_heart)
       //         imgSleep.image = UIImage.init(named: ConstantThemeHomeIcon.red_sleep)
      //          imgPoints.image = UIImage.init(named: ConstantThemeHomeIcon.red_points)
      //          imgGratitude.image = UIImage.init(named: ConstantThemeHomeIcon.red_gratitude)

                break
           }
        }
                

    }
    
}

extension CoachViewController: TimezoneDelegate {
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

extension CoachViewController : CoachSessionSearchModelModelDelegate
{
    func didReceiveCoachSessionSearchModelResponse(RecordedResponse: CoachSessionSearchModelResponse?) {
        
    }
    
    func didReceiveCoachSessionSearchModelError(statusCode: String?) {
        
    }
    
    
}

extension CoachViewController : AgoracreationModelDelegate
{
    func didReceiveAgoraCreationModelResponse(AgoraCreationResponse: AgoraCreationResponse?) {
        
        print(AgoraCreationResponse?.result?.agoraAccessToken ?? "")
        print(AgoraCreationResponse?.result?.agoraAppId ?? "")
        print(AgoraCreationResponse?.result?.channelName ?? "")
        print(AgoraCreationResponse?.result?._id ?? "")
        print(AgoraCreationResponse?.result?.ctgryId ?? "")
        print(AgoraCreationResponse?.result?.coachId ?? "")
        
        CatagoryIdNew = AgoraCreationResponse?.result?.ctgryId ?? ""
        coachIdNew = AgoraCreationResponse?.result?.coachId ?? ""
        sessionNameNew = AgoraCreationResponse?.result?.sessionName ?? ""
        ChannelAgoraNew = AgoraCreationResponse?.result?.channelName ?? ""
        AcessTokenAgoraNew = AgoraCreationResponse?.result?.agoraAccessToken ?? ""
        AppIdAgoraNew = AgoraCreationResponse?.result?.agoraAppId ?? ""
        sessionIdNew = AgoraCreationResponse?.result?._id ?? ""
        
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        
        let request = CoachViewStatusRequest(status: "active", sessId: sessionIdNew, agoraSId: "", coachId: coachIdNew, ctgryId: CatagoryIdNew, agoraResourceId: "", agoraAccessToken: AcessTokenAgoraNew, channelName: ChannelAgoraNew)
          coachViewStatusModel.postCoachStatusData(Request: request, token: token)
              
        
    }
    
    func didReceiveAgoraCreationModelError(statusCode: String?) {
        
    }
    
    
}
