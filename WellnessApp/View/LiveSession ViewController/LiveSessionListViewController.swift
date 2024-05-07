//
//  LiveSessionListViewController.swift
//  Luvo
//
//  Created by BEASiMAC on 06/12/22.
//

import UIKit
import FirebaseDatabase
class LiveSessionListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
   
    @IBOutlet var viewHiddenPopup: UIView!
    @IBOutlet var btnDoneHiddenPopup: UIBUtton_Designable!
    
    @IBOutlet weak var lblcatagory: UILabel!
    @IBOutlet weak var imgVWBackground: UIImageView!
    @IBOutlet weak var imgVWuser: UIImageView!
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet weak var imgVwSession: UIImageView!
    @IBOutlet weak var lblSessionName: UILabel!
    @IBOutlet weak var lblCoachName: UILabel!
    
    @IBOutlet weak var txtFldSearch: UITextField!
    var LiveData: LiveListViewResponse?
    var livelistviewModel = LiveListViewModel()
    private var liveJoinViewModel = LiveJoinViewModel()
    
    var NewsessionId: String = ""
    var sessrionstatus: String = ""
    
    var AgoraAppId: String = ""
    var AgoraToken: String = ""
    var AgoraChannelName: String = ""
    var CoachImage: String = ""
    var SessionName: String = ""
    
    
    var ref: DatabaseReference!
    
    var sessionId: String = ""
    var CatagoryName: String = ""
    var sessionName: String = ""
    @IBOutlet weak var tblVwList: UITableView!
    override func viewDidLoad() {
    super.viewDidLoad()
        
     print(CatagoryName)
        lblcatagory.text = CatagoryName

        //tblVwList.rowHeight = UITableView.automaticDimension
        //tblVwList.estimatedRowHeight = 500
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

     //   self.tblVwList.rowHeight  = UITableView.automaticDimension
    //    self.tblVwList.estimatedRowHeight = 150

//        tableView.estimatedRowHeight = 695
//
//        tableView.rowHeight = UITableViewAutomaticDimension
        
       // imgVwSession.layer.cornerRadius = imgVwSession.bounds.width / 2
       // imgVwSession.clipsToBounds = true

//        imgVwSession.layer.borderWidth = 1
//        imgVwSession.layer.masksToBounds = false
//        imgVwSession.layer.borderColor = UIColor.black.cgColor
//        imgVwSession.layer.cornerRadius = imgVwSession.frame.height/2
//        imgVwSession.clipsToBounds = true


        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        
        ref = Database.database().reference()
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        
        self.livelistviewModel.ListLivedelegate = self
        liveJoinViewModel.Liveviewdelegate = self
        
        txtFldSearch.delegate = self
        
        debugPrint(sessionId)
        setupCustomNavBar()
        setupUI()
        setupPopupUI()
        livelistviewModel.getLiveDetails(token: token, catagoryId: sessionId, sessionName: sessionName)
        
    }
    fileprivate func setupPopupUI() {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
    }
    
    fileprivate func showPopup() {
        viewHiddenPopup.isHidden = false
        viewHiddenPopup.alpha = 1.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        guard let LiveArray = LiveData?.sessionList else {return 0}
        
        return LiveArray.count // Here also
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 // count of items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let image = UIImage(named: "Swift")?.withRenderingMode(.alwaysTemplate)
        //        let imageView = UIImageView(image: image)
        //        imageView.tintColor = .systemPink
       
        if tableView == tblVwList,
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveSessionListViewCell") as? LiveSessionListViewCell {
            let image = UIImage(named: "Icon feather-user")?.withRenderingMode(.alwaysTemplate)
            cell.ivgVW.image = image
            cell.ivgVW.tintColor = UIColor.colorSetup()

          // let imagesub = UIImage(named: "Icon feather-user")?.withRenderingMode(.alwaysTemplate)
          //  cell.imgVwSubtitle.image = imagesub
            cell.imgVwSubtitle.tintColor = UIColor.colorSetup()
            
            let imagecal = UIImage(named: "Icon feather-calendar")?.withRenderingMode(.alwaysTemplate)
            cell.imgVwCalednder.image = imagecal
            cell.imgVwCalednder.tintColor = UIColor.colorSetup()
            
            let imageclock = UIImage(named: "Icon feather-clock")?.withRenderingMode(.alwaysTemplate)
            cell.imgVwClock.image = imageclock
            cell.imgVwClock.tintColor = UIColor.colorSetup()
            
            if let imgBreath = LiveData?.sessionList?[indexPath.row].sessionThumbnailLocation {
                cell.Imgthumbnail.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                
                cell.lblSessionname.text = LiveData?.sessionList?[indexPath.row].sessionName
                cell.LblCoachName.text = LiveData?.sessionList?[indexPath.row].coachname
                cell.lblSubtitle.text = LiveData?.sessionList?[indexPath.row].subTitle
                
                debugPrint(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? "text")
                
                if LiveData?.sessionList?[indexPath.row].sessionStatus ?? "test" == "active"
                {
                    cell.imgViewLive.isHidden = false
               }
                else
                {
                    cell.imgViewLive.isHidden = true
                }
                cell.imgViewLive.layer.cornerRadius = 10
                cell.imgViewLive.clipsToBounds = true
                var convertedLocalStartTime : String = ""
                var convertedLocalEndTime : String = ""
                
                convertedLocalStartTime = utcToLocal(dateStr: LiveData?.sessionList?[indexPath.row].sessionStarttime as Any as! String) ?? "text"
               
                convertedLocalEndTime = utcToLocal(dateStr: LiveData?.sessionList?[indexPath.row].sessionEndtime as Any as! String) ?? "text"


                
                cell.lblsessionDate.text = convertedLocalStartTime

                
                var convertedLocalStartTimeDuration : String = ""
                var convertedLocalEndTimeDuration : String = ""

                convertedLocalStartTimeDuration = TimeDuratuin(dateStr: LiveData?.sessionList?[indexPath.row].sessionStarttime as Any as! String) ?? "text"

                convertedLocalEndTimeDuration = TimeDuratuin(dateStr: LiveData?.sessionList?[indexPath.row].sessionEndtime as Any as! String) ?? "text"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone.current
                let date1 = dateFormatter.date(from: convertedLocalStartTimeDuration)
                let date2 = dateFormatter.date(from: convertedLocalEndTimeDuration)

                if let date1 = date1 {
                    if let date2 = date2 {
                        let difference = Calendar.current.dateComponents([.hour, .minute], from: date1, to: date2)
                        let formattedString1 = String(format: "%02ld", difference.hour!)
                        let formattedString2 = String(format: "%02ld", difference.minute!)
                        print(formattedString1)
                        print(formattedString2)
                        
                        cell.lblSessionDuration.text = formattedString1 + "Hr" + formattedString2 + "min"
                    }
                }

               // TimeDiffer(dateStrStart: convertedLocalStartTime, dateStrEnd: convertedLocalEndTime)


            }
            
            
            
          //  cell.sessionName.text = arrsessionName[indexPath.row]
          //  let startTime = arrSessionStartTime[indexPath.row]
            
           // cell.sessionTimeDuration.text = arrsessionEndtime[indexPath.row]
        //    debugPrint(arrsessionName[indexPath.row])


            cell.backgroundColor = UIColor.clear

           // debugPrint(cell.lblSubtitle.count)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lblCoachName.text = LiveData?.sessionList?[indexPath.row].coachname
        lblSessionName.text = LiveData?.sessionList?[indexPath.row].sessionName
        SessionName = LiveData?.sessionList?[indexPath.row].sessionName ?? "test"
        if let imgBreath = LiveData?.sessionList?[indexPath.row].sessionThumbnailLocation {           imgVwSession.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
       }
        NewsessionId = (LiveData?.sessionList?[indexPath.row]._id)!
        sessrionstatus = (LiveData?.sessionList?[indexPath.row].sessionStatus)!
        AgoraToken = (LiveData?.sessionList?[indexPath.row].agoraAccessToken)!
        AgoraAppId = (LiveData?.sessionList?[indexPath.row].agoraAppId)!
        AgoraChannelName = (LiveData?.sessionList?[indexPath.row].channelName)!
        CoachImage = (LiveData?.sessionList?[indexPath.row].coachProfileImage)!
        debugPrint(NewsessionId)
       showPopup()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (indexPath.row % 2) != 0{
//               return 80
//
//            }else{
//
//                return 115
//
//            }
        
        print(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? "")
        
        if Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) > 100 && Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) < 149
        {
            return 115
        }
       else if Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) > 150 && Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) < 199
        {
           return 130
       }
        
        else if Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) > 200 && Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) < 251
         {
            return 145
        }
        else if Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) > 50 && Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) < 100
         {
            return 100
        }
        else{
            return 80
        }
        }

   // }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    func TimeDuratuin(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
              //  dateFormatter.dateFormat = "MMM d, yyyy"
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"

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
                dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
              //  dateFormatter.dateFormat = "HH : MM"
            
                return dateFormatter.string(from: date)
            }
            return nil
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
            
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return true
            }
            debugPrint("token--->",token)
            livelistviewModel.getLiveDetails(token: token, catagoryId: sessionId, sessionName: txtFldSearch.text ?? "test")
            tblVwList.reloadData()
            return true;
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("TextField should return method called")
           
            textField.resignFirstResponder();
            return true;
        }
    

    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    @IBAction func btnDoneHiddenPopup(_ sender: Any) {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
        
       
        
        if sessrionstatus == "active"
        {
            debugPrint(NewsessionId)
            debugPrint(sessrionstatus)
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            debugPrint("token--->",token)
            
//            let request = SignupResquest(name: txtUsername.text, userEmail: txtEmail.text, mobileNo: txtPhoneNo.text, password: txtPassword.text, dateOfBirth: "", FCMToken: FCMToken)
//            signupViewModel.signupUser(signupRequest: request)
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))

            print(time + ", Type :UserJoin")
            
            self.ref.child(NewsessionId).setValue(["value": time + ", Type :UserJoin"])
           // self.ref.child(NewsessionId).setValue(["value": "1672237568, Type :UserJoin"])
            
            let request = LiveJoinRequest(sessionId: NewsessionId, action: "Joining")
            liveJoinViewModel.postLiveJoinData(date: request, token: token)
        }else
        {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                
                
            }))

//            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                  print("Handle Cancel Logic here")
//            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    func setupUI()
    {
        
        btnDoneHiddenPopup.backgroundColor = UIColor.colorSetup()
        imgVWuser.tintColor = UIColor.colorSetup()
        let tintableImage = UIImage(named: "Icon feather-user")?.withRenderingMode(.alwaysTemplate)
        imgVWuser.image = tintableImage
        imgVWuser.tintColor = UIColor.colorSetup()
      // imgVWBackground.backgroundColor = UIColor.colorSetup()
        

    }
    
    @IBAction func btnClose(_ sender: Any) {
        
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
    }
    
}

extension LiveSessionListViewController: LiveListViewModelDelegate
{
    func didReceiveLiveListResponse(ListResponse: LiveListViewResponse?) {
        self.view.stopActivityIndicator()
        
        if(ListResponse?.status != nil && ListResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(homeResponse)
            LiveData = ListResponse
            debugPrint(LiveData as Any)
            setupUI()
            tblVwList.reloadData()
           
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    
    
    func didReceiveLiveListError(statusCode: String?) {
        
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    
    
}

extension LiveSessionListViewController: LiveJoinViewModelDelegate
{
    func didReceiveLiveJoinResponse(liveResponse: LiveJoinResponse?) {
        
        self.view.stopActivityIndicator()
        
        if(liveResponse?.status != nil && liveResponse?.status?.lowercased() == ConstantStatusAPI.success) {
           
            debugPrint(liveResponse?.joinedsessionsdetails?.sessionId as Any)
            
           
            
            let LiveVC = ConstantStoryboard.LiveSessionList.instantiateViewController(withIdentifier: "AgoraStreamViewController") as! AgoraStreamViewController
            LiveVC.sessionId = (liveResponse?.joinedsessionsdetails?.sessionId as Any) as! String
            LiveVC.AgoraAppId = AgoraAppId
            LiveVC.Agoaratoken = AgoraToken
            LiveVC.channelName = AgoraChannelName
            LiveVC.coachImage = CoachImage
            LiveVC.sessionName = SessionName
            navigationController?.pushViewController(LiveVC, animated: true)
           
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        
    }
    
    func didReceiveLiveJoinError(statusCode: String?) {
        
        
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
