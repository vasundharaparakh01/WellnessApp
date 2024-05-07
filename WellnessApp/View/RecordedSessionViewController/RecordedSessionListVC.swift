//
//  RecordedSessionListVC.swift
//  Luvo
//
//  Created by BEASiMAC on 12/12/22.
//

import UIKit

class RecordedSessionListVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    var convertedLocalStartTime : String = ""
    var convertedLocalEndTime : String = ""
    var arrDuration = [String]()
    var sessionId: String = ""
    var catagoryName: String = ""
    var sessionNameLabel: String = ""
    var CoachName: String = ""
    var NoUsers: String = ""
    var Duration: String = ""
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var CatagoryName: UILabel!
    @IBOutlet weak var txtFldSearchRename: UITextField!
    var recordedSessionViewModel = RecordedSessionViewModel()
    var UserData: RecordedSessionResponse?
    private var liveJoinViewModel = LiveJoinViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        
        
        debugPrint(sessionId)
        debugPrint(catagoryName)
       
        self.recordedSessionViewModel.Recordeddelegate = self
        
        let status = UserDefaults.standard.bool(forKey: "isFromHomeList")
                                print(status)
                                
        if status==false
        {
            recordedSessionViewModel.getRecordDetails(token: token, catagoryId: sessionId, sessionName: "")
            self.CatagoryName.text = catagoryName
                    
        }
        else
        {
            recordedSessionViewModel.getRecordDetails(token: token, catagoryId: "", sessionName: "")
            self.CatagoryName.text = "All Recorded Session"
        }
       setupCustomNavBar()
      //  setupUI()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        guard let LiveArray = UserData?.results else {return 0}

        return LiveArray.count // Here also
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let image = UIImage(named: "Swift")?.withRenderingMode(.alwaysTemplate)
        //        let imageView = UIImageView(image: image)
        //        imageView.tintColor = .systemPink
       
        if tableView == tblVwList,
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecoredeSessionTableViewCell") as? RecoredeSessionTableViewCell {
            let image = UIImage(named: "Icon feather-user")?.withRenderingMode(.alwaysTemplate)
            cell.ivgVW.image = image
            cell.ivgVW.tintColor = UIColor.colorSetup()
            
            let imagecal = UIImage(named: "Icon feather-calendar")?.withRenderingMode(.alwaysTemplate)
            cell.imgVwCalednder.image = imagecal
            cell.imgVwCalednder.tintColor = UIColor.colorSetup()
            
            let imageclock = UIImage(named: "Icon feather-clock")?.withRenderingMode(.alwaysTemplate)
            cell.imgVwClock.image = imageclock
            cell.imgVwClock.tintColor = UIColor.colorSetup()
           // cell.imgVwSubtiltle.image = imageclock
            cell.imgVwSubtiltle.tintColor = UIColor.colorSetup()
//            debugPrint(UserData?.results?[indexPath.row].sessionName ?? "test")
          //  (RecordedResponse?.results?[0].coachSessionDetails?.sessionName as Any)
           // if let imgBreath = UserData?.results?[indexPath.row]coachSessionDetails?.sessionThumbnailLocation
                if let imgBreath = UserData?.results?[indexPath.row].coachSessionDetails?.sessionThumbnailLocation{
                cell.Imgthumbnail.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)

                debugPrint(UserData?.results?[indexPath.row].coachSessionDetails?.sessionName ?? "test")

                cell.lblSessionname.text = UserData?.results?[indexPath.row].coachSessionDetails?.sessionName
                cell.LblCoachName.text = UserData?.results?[indexPath.row].coachSessionDetails?.coachname
                cell.lblSubTitle.text = UserData?.results?[indexPath.row].coachSessionDetails?.subTitle

              


                convertedLocalStartTime = utcToLocal(dateStr: UserData?.results?[indexPath.row].coachSessionDetails?.sessionStarttime as Any as! String) ?? "text"

                convertedLocalEndTime = utcToLocal(dateStr: UserData?.results?[indexPath.row].coachSessionDetails?.sessionStarttime as Any as! String) ?? "text"

                cell.lblsessionDate.text = convertedLocalStartTime


                var coachJoinedOn : String = ""
                var coachExitedOn : String = ""

                coachJoinedOn = TimeDuration(dateStr: UserData?.results?[indexPath.row].coachSessionDetails?.coachJoinedOn as Any as! String) ?? "text"

                coachExitedOn = TimeDuration(dateStr: UserData?.results?[indexPath.row].coachSessionDetails?.coachExitedOn as Any as! String) ?? "text"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone.current
                let date1 = dateFormatter.date(from: coachJoinedOn)
                let date2 = dateFormatter.date(from: coachExitedOn)

                if let date1 = date1 {
                    if let date2 = date2 {
                        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: date1, to: date2)
                        let formattedString1 = String(format: "%02ld", difference.hour!)
                        let formattedString2 = String(format: "%02ld", difference.minute!)
                        let formattedString3 = String(format: "%02ld", difference.second!)
                        print(formattedString1)
                        print(formattedString2)
                        print(formattedString3)

                        Duration = formattedString1+"Hr"+formattedString2+"min"+formattedString3+"Secs"
                        arrDuration.append(Duration)
                        cell.lblSessionDuration.text = formattedString1+"Hr"+formattedString2+"min"+formattedString3+"Secs"
                    }
                }
            }
            
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(false, forKey: "isFromCoachRecordedSession")
        UserDefaults.standard.set(true, forKey: "isFromRecordedSession")
        UserDefaults.standard.set(true, forKey: "FromSettings")
        print(convertedLocalStartTime)
        print(UserData?.isPaymented ?? "true")
        let signupVC = ConstantStoryboard.videoPlay.instantiateViewController(identifier: "VideoPlay") as! VideoPlay
        if UserData?.isPaymented == false
        {
            signupVC.isPayMent = "false"
        }
        else
        {
            signupVC.isPayMent = "true"
        }
        signupVC.coachImage = (UserData?.results?[indexPath.row].userDetails?.location)!
        signupVC.RecordedUrl = (UserData?.results?[indexPath.row].videoLocation)!
        signupVC.Durstion = arrDuration[indexPath.row]
        signupVC.dateE =  convertedLocalStartTime
        signupVC.SessionName = (UserData?.results?[indexPath.row].coachSessionDetails?.sessionName)!
        signupVC.CoachName = (UserData?.results?[indexPath.row].coachSessionDetails?.coachname)!
        signupVC.NoofUsers = String((UserData?.results?[indexPath.row].coachSessionDetails?.coachname)!)
        signupVC.Description = (UserData?.results?[indexPath.row].coachSessionDetails?.subTitle)!
        self.navigationController?.pushViewController(signupVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        
        if Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) > 100 && Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) < 149
                {
                    return 115
                }
               else if Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) > 150 && Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) < 199
               {
                   return 130
               }
        
                else if Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) > 200 && Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) < 251
                {
                   return 145
               }
        else if Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) > 50 && Int(UserData?.results?[indexPath.row].coachSessionDetails?.subTitle?.count ?? 0) < 100
         {
            return 100
        }
                else{
                    return 80
            }
        
        
        }

    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
               // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
                return dateFormatter.string(from: date)
            }
            return nil
    }


    func TimeDuration(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
               // dateFormatter.dateFormat = "MMM d, yyyy"
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

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
            
        
            debugPrint(sessionId)
            debugPrint(catagoryName)
            
            debugPrint(txtFldSearchRename.text) 
           
            self.recordedSessionViewModel.Recordeddelegate = self
            
            let status = UserDefaults.standard.bool(forKey: "isFromHomeList")
                                    print(status)
                                    
            if status==false
            {
                print(txtFldSearchRename.text ?? "trst")
                recordedSessionViewModel.getRecordDetails(token: token, catagoryId: sessionId, sessionName: txtFldSearchRename.text ?? "test")
                self.CatagoryName.text = catagoryName
                        
            }
            else
            {
                print(txtFldSearchRename.text ?? "trst")
                recordedSessionViewModel.getRecordDetails(token: token, catagoryId: "", sessionName: txtFldSearchRename.text ?? "test")
                self.CatagoryName.text = "All Recorded Session"
            }
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
}

extension RecordedSessionListVC: RecordedSessionViewModelDelegate
{
    func didReceiveRecordedSessionResponse(RecordedResponse: RecordedSessionResponse?) {
        
        self.view.stopActivityIndicator()
        
        if(RecordedResponse?.status != nil && RecordedResponse?.status?.lowercased() == ConstantStatusAPI.success) {
           
           
               
         //   debugPrint(RecordedResponse?.results?[0].coachSessionDetails?.sessionName as Any)
                UserData = RecordedResponse
                tblVwList.reloadData()
            
        }
        else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
            
    }
    
    func didReceiveRecordedSessionError(statusCode: String?) {
        
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
        
    }
    
   
}
