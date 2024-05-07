//
//  coachCallViewController.swift
//  Luvo
//
//  Created by BEASiMAC on 05/01/23.
//

import UIKit

class UserCallViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
   
   
    @IBOutlet weak var lblcatagory: UILabel!
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var tblVwList: UITableView!
    var LiveData: UserCallListResponse?
    var usercalllistModel = UserCallListModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usercalllistModel.UserCallListDelegate =  self
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        setupCustomNavBar()
        setupUI()
        
        usercalllistModel.getUserCallListData(token: token, SearchText: "?sessName" + "")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }

    func setupUI()
    {
        
       // btnDoneHiddenPopup.backgroundColor = UIColor.colorSetup()
      //  imgVWuser.backgroundColor = UIColor.colorSetup()
      // imgVWBackground.backgroundColor = UIColor.colorSetup()
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let LiveArray = LiveData?.sessionCallDetails else {return 0}
        
        return LiveArray.count // Here also
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tblVwList,
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCallTableViewCell") as? UserCallTableViewCell {
            let image = UIImage(named: "Icon feather-user")?.withRenderingMode(.alwaysTemplate)
            cell.ivgVW.image = image
            cell.ivgVW.tintColor = UIColor.colorSetup()
            
         //   let imagesub = UIImage(named: "Icon feather-user")?.withRenderingMode(.alwaysTemplate)
         //   cell.imgVwSubtitle.image = imagesub
            cell.imgVwSubtitle.tintColor = UIColor.colorSetup()
            
            let imagecal = UIImage(named: "Icon feather-calendar")?.withRenderingMode(.alwaysTemplate)
            cell.imgVwCalednder.image = imagecal
            cell.imgVwCalednder.tintColor = UIColor.colorSetup()
            
            let imageclock = UIImage(named: "Icon feather-clock")?.withRenderingMode(.alwaysTemplate)
            cell.imgVwClock.image = imageclock
            cell.imgVwClock.tintColor = UIColor.colorSetup()
            
            if let imgBreath = LiveData?.sessionCallDetails?[indexPath.row].sessionThumbnailLocation {
                cell.Imgthumbnail.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                
                cell.lblSessionname.text = LiveData?.sessionCallDetails?[indexPath.row].sessionName
                cell.LblCoachName.text = LiveData?.sessionCallDetails?[indexPath.row].coachname
                cell.lblSubtitle.text = LiveData?.sessionCallDetails?[indexPath.row].subTitle
                if LiveData?.sessionCallDetails?[indexPath.row].callStatus ?? "test" == "active"
                {
                    cell.imgViewLive.isHidden = false
                }
                else
                {
                    cell.imgViewLive.isHidden = true
                }
                var convertedLocalStartTimeDuration : String = ""
                var convertedLocalEndTimeDuration : String = ""

                convertedLocalStartTimeDuration = TimeDuratuin(dateStr: LiveData?.sessionCallDetails?[indexPath.row].sessionStarttime as Any as! String) ?? "text"

                convertedLocalEndTimeDuration = TimeDuratuin(dateStr: LiveData?.sessionCallDetails?[indexPath.row].sessionEndtime as Any as! String) ?? "text"
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
                
                
                var convertedLocalStartTime : String = ""
                var convertedLocalEndTime : String = ""
                
                convertedLocalStartTime = utcToLocal(dateStr: LiveData?.sessionCallDetails?[indexPath.row].sessionStarttime as Any as! String) ?? "text"
               
                convertedLocalEndTime = utcToLocal(dateStr: LiveData?.sessionCallDetails?[indexPath.row].sessionEndtime as Any as! String) ?? "text"


                
                cell.lblsessionDate.text = convertedLocalStartTime

                
         }
            cell.backgroundColor = UIColor.clear
            
            return cell
    }
            return UITableViewCell()

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
            usercalllistModel.getUserCallListData(token: token, SearchText: "?sessName" + (txtFldSearch.text ?? "test"))
            tblVwList.reloadData()
            return true;
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("TextField should return method called")
           
            textField.resignFirstResponder();
            return true
        }
    


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

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let callVC = ConstantStoryboard.Call.instantiateViewController(withIdentifier: "UserCallAgoraVC") as! UserCallAgoraVC
    callVC.AgoraAppId = LiveData?.sessionCallDetails?[indexPath.row].agoraAppId ?? "test"
    callVC.Agoaratoken = LiveData?.sessionCallDetails?[indexPath.row].agoraAccessToken ?? "test"
    callVC.channelName = LiveData?.sessionCallDetails?[indexPath.row].channelName ?? "test"
    callVC.sessionId = LiveData?.sessionCallDetails?[indexPath.row]._id ?? "test"
    callVC.AgoraUId = LiveData?.sessionCallDetails?[indexPath.row].agoraUId ?? "test"
    callVC.CallId = LiveData?.sessionCallDetails?[indexPath.row].callId ?? "test"
    self.navigationController?.pushViewController(callVC, animated: true)
    
    
}


    @IBAction func btnBack(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
    }

}

//func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        if (indexPath.row % 2) != 0{
////               return 80
////
////            }else{
////
////                return 115
////
////            }
//
//
//
//
////    if Int(LiveData?.sessionCallDetails?[indexPath.row].subTitle?.cou) > 100 && Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) < 149
////    {
////        return 115
////    }
////   else if Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) > 150 && Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) < 199
////    {
////       return 130
////   }
////
////    else if Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) > 200 && Int(LiveData?.sessionList?[indexPath.row].subTitle?.count ?? 0) < 251
////     {
////        return 145
////    }
////    else{
////        return 80
////    }
//    }

extension UserCallViewController :UserCallListModelDelegate
{
    func didReceiveUserCallListResponse(UserCallList: UserCallListResponse?) {
        
        
        self.view.stopActivityIndicator()
        
        if(UserCallList?.status != nil && UserCallList?.status?.lowercased() == ConstantStatusAPI.success) {
            
            
            print(UserCallList?.sessionCallDetails ?? "test")
            LiveData = UserCallList
            tblVwList .reloadData()
            
        }
    }
    
    func didReceiveUserCallListError(statusCode: String?) {
        
    }
    
    
    
}
