//
//  CoachViewAgoraVC.swift
//  Luvo
//
//  Created by BEASiMAC on 15/12/22.
//

import Foundation
import FirebaseDatabase
import UIKit
import AVFoundation
import AgoraRtcKit

class CoachViewAgoraVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var imgProfileView: UICollectionView!
    var ref: DatabaseReference!
    var  sessionId: String = ""
    var  coachId: String = ""
    var  agoraResourceId: String = ""
    var  agoraSId: String = ""
    var  CatagoryId: String = ""
    var agoraUserProfileModel = AgoraUserProfileModel()
    private var liveJoinViewModel = LiveJoinViewModel()
    var UserData: AgoraUserProfileImageResponse?
    var UserDataChat: AllUserChatResponse?
    private var countdownTimer: Timer?
   // @IBOutlet weak var btnDisconnect: UIButton!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var VwDisconnet: UIView!
    var coachViewStatusModel = CoachViewStatusModel()
    var UserchatData = AllUserChatModel()
    @IBOutlet weak var MainView: UIView!
    var chatViewModelCoach = UserchatWithCoachModel()
    var array = [String]()


    var arrText = [String]()
    var ReveredarrText = [String]()

    var arrName = [String]()
    var ReveresdarrName = [String]()

    var arrTime = [String]()
    var ReversedarrTime = [String]()

    var arrUserImage = [String]()
    var ReversedarrUserImage = [String]()



    @IBOutlet weak var localView: UIView!
  //  @IBOutlet weak var btnshare: UIButton!
    @IBOutlet weak var chatView: UITableView!
  //  @IBOutlet weak var imgvb: UIImageView!

    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var userDetail: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var imgVwMute: UIImageView!
   // @IBOutlet weak var imgVwDisconnect: UIImageView!
    @IBOutlet weak var imgVwCamera: UIImageView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
   // @IBOutlet weak var lblUserNumber: UILabel!
    
   // @IBOutlet weak var btnMute: UIButton!
    @IBOutlet weak var btnDisconnectCall: UIImageView!
    //@IBOutlet weak var btnSwitchCamera: UIButton!

   // @IBOutlet weak var btnMute: UIButton!
    
   // @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var lblLive: UILabel!
    
    @IBOutlet weak var txtfeildChat: UITextField!
    @IBOutlet weak var lblSessionName: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var ChatImageView: UIImageView!
    @IBOutlet weak var ChatArrowIcon: UIImageView!
    @IBOutlet weak var ChatOnOffImageView: UIImageView!

    
    var agoraEngine: AgoraRtcEngineKit!
    // By default, set the current user role to broadcaster to both send and receive streams.
    var userRole: AgoraClientRole = .broadcaster
    
    var AgoraAppId: String = ""
   
    
    var Agoaratoken: String = ""
    
    var channelName: String = ""
    var SessionName: String = ""
    
    
        var joinButton: UIButton!
       
    
        // Track if the local user is in a call
        
        var joined: Bool = false
        var isMute: Bool = false
        var isChatOn: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        lblUser.text = "0" + " User Here"
        lblSessionName.text = SessionName
        
        NotificationCenter.default.addObserver(self, selector: #selector(CoachViewAgoraVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(CoachViewAgoraVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        array.append(" I have a design that implements a dark blue UITextField, as the placeholder text is by default")
        array.append(" design that implements a ")
        array.append("  a design ")
        array.append(" I ")
        array.append(" I have a design that implements a dark blue UITextField, as the placeholder text is by default")
        array.append(" design that implements a ")
        array.append("  a design ")
        array.append(" I ")

        chatView.reloadData()
    
    }



    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localView.bringSubviewToFront(collectionViewImage)
        localView.bringSubviewToFront(viewCall)
        localView.bringSubviewToFront(chatView)
        localView.bringSubviewToFront(imgVwMute)
        localView.bringSubviewToFront(lblLive)
        localView.bringSubviewToFront(MainView)
        localView.bringSubviewToFront(lblSessionName)
        localView.bringSubviewToFront(btnDisconnectCall)
        localView.bringSubviewToFront(userDetail)
        localView.bringSubviewToFront(commentView)
        
        
        
        
        
        

       // chatView.estimatedRowHeight = 100.0
       // chatView.rowHeight = UITableView.automaticDimension
        chatView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));

       // UserDefaults.standard.value(forKey: "CoachProfileImage") ?? "Test"
       // imgVwMute?.layer.cornerRadius = (imgVwMute?.frame.size.width ?? 0.0) / 2
      //  imgVwDisconnect?.layer.cornerRadius = (imgVwDisconnect?.frame.size.width ?? 0.0) / 2
     //   imgVwCamera?.layer.cornerRadius = (imgVwCamera?.frame.size.width ?? 0.0) / 2

        btnDisconnectCall?.layer.cornerRadius = (btnDisconnectCall?.frame.size.width ?? 0.0) / 2
        btnDisconnectCall?.layer.masksToBounds =  true
        imgVwUser?.layer.cornerRadius = (imgVwUser?.frame.size.width ?? 0.0) / 2
        imgVwUser?.layer.masksToBounds = true
        imgVwUser?.layer.borderColor = #colorLiteral(red: 0.7058823529, green: 0.02352941176, blue: 0.05098039216, alpha: 1)
        imgVwUser?.layer.borderWidth = 3.0
        
        
        imgVwUser.sd_setImage(with: URL(string: UserDefaults.standard.value(forKey: "CoachProfileImage") as! String), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)

        lblLive.layer.cornerRadius = 8
        lblLive.layer.masksToBounds = true
        
        ChatImageView.layer.masksToBounds = true
        ChatImageView.layer.borderColor = UIColor.white.cgColor
        ChatImageView.layer.borderWidth = 2.0
        ChatImageView.layer.cornerRadius = 15
        
     



    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true
        
        ref = Database.database().reference()
        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
        self.ref.child("NewSessionStart").setValue(["value": time + ", session_id :" + sessionId + ", Type : SessionStart"])
        startTimer()
       // remoteView.addSubview(VwDisconnet)
        self.agoraUserProfileModel.AgoraUserdelegate = self
        self.UserchatData.AllUserChatdelegate = self
        self.coachViewStatusModel.coachstatDelegate = self
        
//        channelName = "demoTEST1681455723"
//        sessionId = "6438f61ac8836804284a4ae5"
//        Agoaratoken = "006a432736c8a3a470faece2344fa453f87IAAV/calfqhFTh3e/h6uVvreLC/uFLDz/4W8tIQTa8XQyoFodPcAAAAAIgB0dOmr60s6ZAQAAQBrh2BkAgBrh2BkAwBrh2BkBABrh2Bk"
//        AgoraAppId = "a432736c8a3a470faece2344fa453f87"
        
        debugPrint(sessionId)
        
        debugPrint(AgoraAppId)
        debugPrint(Agoaratoken)
        debugPrint(channelName)
        debugPrint(sessionId)

        self.childObserver()
       
        
       // initViews()
        initializeAgoraEngine()
        DispatchQueue.main.async {
          // your code here
           
            self.joinChannel()
            
            self.agoraEngine.muteLocalAudioStream(false)
        }
//        self.chatView.register(UINib(nibName: String(describing: ChatViewCell.self), bundle: nil), forCellReuseIdentifier: "ChatViewCell")
        self.chatView.rowHeight  = UITableView.automaticDimension
        self.chatView.estimatedRowHeight = 156
        
       // chatView .reloadData()
    }
    
    
    @objc func function() {
        
//        if isMute == false
//        {
//        let image = UIImage(named: "UM")
//        muteButton.setImage(image, for: .normal)
//            isMute = true
//        }
//        else if isMute == true
//        {
//            let image = UIImage(named: "m")
//            muteButton.setImage(image, for: .normal)
//                isMute = false
//
//        }
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.MainView.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.MainView.frame.origin.y = 0
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

            chatView.isHidden = false
            ChatOnOffImageView.image = UIImage(named: "chat1")
            isChatOn = true

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
           
           
            return true;
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("TextField should return method called")
            
     
           
            textField.resignFirstResponder();
            return true;
        }

    @IBAction func btnMute(_ sender: Any) {

        if isMute == false
        {
        let image = UIImage(named: "mute-microphone")  //mute-microphone microphone
            imgVwMute.image = image
            isMute = true
            agoraEngine.muteLocalAudioStream(true)

           // agoraEngine.switchCamera();
        }
        else if isMute == true
        {
            let image = UIImage(named: "microphone")
            imgVwMute.image = image
                isMute = false
            agoraEngine.muteLocalAudioStream(false)

        }
    }


    @IBAction func ChatToggle(_ sender: Any) {

        if isChatOn == true
        {
            chatView.isHidden = true
            ChatOnOffImageView.image = UIImage(named: "chat2")
            isChatOn = false
        }

        else if isChatOn == false
        {
            chatView.isHidden = false
            ChatOnOffImageView.image = UIImage(named: "chat1")
            isChatOn = true
        }
        

    }
    @IBAction func btnSwithCamera(_ sender: Any) {

         agoraEngine.switchCamera();
    }

    @objc func CallEnd() {
        
        if !joined {
            joinChannel()
            // Check if successfully joined the channel and set button title accordingly
            if joined { joinButton.setTitle("Leave", for: .normal)
                joinButton.setImage(UIImage(named: "call_disconnect.png"), for: .normal)
            }
        } else {
            leaveChannel()
            self.btnEndCall(true)
            // Check if successfully left the channel and set button title accordingly
            //if !joined { joinButton.setTitle("Join", for: .normal) }
        }
        
    }
    
    func startTimer() {
       
        countdownTimer?.invalidate() //cancels it if already running
        countdownTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getImageDetails), userInfo: nil, repeats: true) //1hr call
    }
    
    private func childObserver()
    {
        ref.child(sessionId).observe(.childChanged) { (snapshot) in
            
            if let value = snapshot.value as? String
            {
                debugPrint(value)
                let string = value
                if string.contains("UserJoin") {
                    print("exists")
                    self.getImageDetails()
                }
            
                if string.contains("Chat") {
                    print("chat")
                   // self.getImageDetails()
                    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()

                    return
                }
                    self.UserchatData.getChatDetails(token: token, SessionID: self.sessionId)
                }
                

            }
            
            
        }
        
    }
    
    @objc func getImageDetails()
    {
        
//        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//
//        print(time + ", Type :UserJoin")
//
//        self.ref.child(sessionId).setValue(["value": time + ", Type :UserJoin"])


        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        agoraUserProfileModel.getAgoraliveUerDetails(token: token, SesionId: sessionId)
        self.UserchatData.getChatDetails(token: token, SessionID: self.sessionId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            leaveChannel()
            DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
        }

//            override func viewDidLayoutSubviews() {
//                super.viewDidLayoutSubviews()
//               // remoteView.frame = CGRect(x: 20, y: 20, width: 350, height: 330)
//               // localView.frame = CGRect(x: 20, y: 350, width: 350, height: 330)
//            }
    
    func initViews() {
            // Initializes the remote video view. This view displays video when a remote host joins the channel.
           // remoteView = UIView()
           // self.view.addSubview(remoteView)
            // Initializes the local video window. This view displays video when the local user is a host.
          //  localView = UIView()
          //  self.view.addSubview(localView)
            //  Button to join or leave a channel
        
        
            joinButton = UIButton(type: .system)
            joinButton.frame = CGRect(x: 169, y: 453, width: 77, height: 62)
            joinButton.setTitle("Join", for: .normal)

            joinButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.view.addSubview(joinButton)
        }

    @objc func buttonAction(sender: UIButton!) {
            if !joined {
                joinChannel()
                // Check if successfully joined the channel and set button title accordingly
                if joined { joinButton.setTitle("Leave", for: .normal)
                    joinButton.setImage(UIImage(named: "call_disconnect.png"), for: .normal)
                }
            } else {
                leaveChannel()
                // Check if successfully left the channel and set button title accordingly
                if !joined { joinButton.setTitle("Join", for: .normal) }
            }
        }
    
    @IBAction func btnDisconnect(_ sender: Any) {
        
        leaveChannel()
        self.btnEndCall(true)
        
    }
    @IBAction func Leave(_ sender: Any) {
        
       
        
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
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
            self.view.endEditing(true)
            
            //self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            let request = UserChatRequest(text: txtfeildChat.text, sessionId: sessionId)
            chatViewModelCoach.postChatJoinData(Chat: request, token: token)
            
          //  var str : String? = sessionId
            
            debugPrint(sessionId)
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :UserJoin")
            self.ref.child(sessionId).setValue(["value": time + ", Type :Chat"])
            txtfeildChat.text = ""
            //1672236276, Type :SessionEnd
           // self.childObserver()
            
            
        }
    }
    
    
    func checkForPermissions() -> Bool {
        var hasPermissions = false

        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: hasPermissions = true
            default: hasPermissions = requestCameraAccess()
        }
        // Break out, because camera permissions have been denied or restricted.
        if !hasPermissions { return false }
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
    
    func showMessage(title: String, text: String, delay: Int = 2) -> Void {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true)
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        // Pass in your App ID here.
        config.appId = AgoraAppId
        // Use AgoraRtcEngineDelegate for the following delegate parameter.
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }

    func setupLocalVideo() {
        // Enable the video module
        agoraEngine?.enableVideo()
        // Start the local video preview
        agoraEngine?.startPreview()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        // Set the local video view
        agoraEngine?.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel() {
        if !self.checkForPermissions() {
            showMessage(title: "Error", text: "Permissions were not granted")
            return
        }

        let option = AgoraRtcChannelMediaOptions()

//        // Set the client role option as broadcaster or audience.
//        if self.userRole == .broadcaster {
//
//            let boolCoachVC = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromCoachVC)
//            if boolCoachVC == true
//            {
//            option.clientRoleType = .broadcaster
//            }
//            else{
//            option.clientRoleType = .audience
//            }
//            setupLocalVideo()
//        } else {
//            option.clientRoleType = .audience
//        }
        
        // Set the client role option as broadcaster or audience.
        if self.userRole == .broadcaster {
            option.clientRoleType = .broadcaster
            setupLocalVideo()
        } else {
            option.clientRoleType = .audience
        }

        // For a video call scenario, set the channel profile as communication.
        option.channelProfile = .communication

        // Join the channel with a temp token. Pass in your token and channel name here
        let result = agoraEngine?.joinChannel(
            byToken: Agoaratoken, channelId: channelName, uid: 0, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in
                
                print("uid....\(uid)")
                
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }
                let request = CoachViewStatusRequest(status: "active", sessId: self.sessionId, agoraSId: self.agoraSId, coachId: self.coachId, ctgryId: self.CatagoryId, agoraResourceId: self.agoraResourceId, agoraAccessToken: self.Agoaratoken, channelName: self.channelName)
                self.coachViewStatusModel.postCoachStatusData(Request: request, token: token)
            }
        )
            // Check if joining the channel was successful and set joined Bool accordingly
        if (result == 0) {
            joined = true
           // showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
            
        }
    }

    func leaveChannel() {
       // agoraEngine?.stopPreview()
        let result = agoraEngine?.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if (result == 0) { joined = false }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        lblUser.text = String(UserData?.userdetails?.count ?? 0) + " User Here"
        return UserData?.userdetails?.count ?? 0
       // return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCellUser", for: indexPath) as! AgoraCoachImageView
        
    debugPrint(UserData?.userdetails?[indexPath.row].location as Any)
        
//        cell.imgView.sd_setImage(with: URL(string: "https://lh3.googleusercontent.com/a-/AOh14GjTRfUXjqE2M_NCVNiUQ8Mvf8W64-xo10U-sP7Emw=s96-c"), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
        if let imgBreath = UserData?.userdetails?[indexPath.row].location {
//     //   https://lh3.googleusercontent.com/a-/AOh14GjTRfUXjqE2M_NCVNiUQ8Mvf8W64-xo10U-sP7Emw=s96-c
            cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
        //    cell.lblUserName.text = UserData?.userdetails?[indexPath.row].userName
//
       }
//        if let imgBreath = (UserData?.userdetails?[indexPath.row].location as Any) {
//            cell.imgView.sd_setImage(with: URL(string: imgBreath as! String), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
//        }
        
//        if let imgBreath = UserData?.userdetails?[indexPath.row].location {
//            cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
////            cell.lblSessionname.text = LiveData?.sessionList?[indexPath.row].sessionName
////            cell.LblCoachName.text = LiveData?.sessionList?[indexPath.row].coachname
////            cell.lblsessionDate.text = LiveData?.sessionList?[indexPath.row].sessionStarttime
//        }
        

        
        // cell.imgView.image = UIImage(named:"orange_gratitude.png")
      //  let date = totalSquares[indexPath.item]
      //  cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
      //  cell.dayOfweek.text = String(day[indexPath.item])
     //   cell.dayOfweek.text = String(days[indexPath.row].prefix(3))
     //   cell.dayOfMonth.text = String(totalSquares[indexPath.row])



        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {


    }
    
    @IBAction func btnEndCall(_ sender: Any) {
        
        ///willuncommentatthetimeofconference
        
        
        let refreshAlert = UIAlertController(title: "Luvo", message: "You want to end this session", preferredStyle: UIAlertController.Style.alert)
          refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        print("Handle Cancel Logic here")
              
              self.countdownTimer?.invalidate()
              
              self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)


              
              guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                //  self.view.stopActivityIndicator()
                  return
              }
              debugPrint("token--->",token)
              
              guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                  self.view.stopActivityIndicator()
                  return
              }
              let request = CoachViewStatusRequest(status: "recording", sessId: self.sessionId, agoraSId: self.agoraSId, coachId: self.coachId, ctgryId: self.CatagoryId, agoraResourceId: self.agoraResourceId, agoraAccessToken: self.Agoaratoken, channelName: self.channelName)
              self.coachViewStatusModel.postCoachStatusData(Request: request, token: token)
              
              
               }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                              print("Handle Cancel Logic here")
            
            
        }))

            present(refreshAlert, animated: true, completion: nil)
                    
        
        countdownTimer?.invalidate()
        
      

        //willuncommentatthetimeofconference

        
//        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//            self.view.stopActivityIndicator()
//            return
//        }
//        debugPrint("token--->",token)

        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
          // self.view.stopActivityIndicator()
            return
        }
        let request = CoachViewStatusRequest(status: "recording", sessId: sessionId, agoraSId: agoraSId, coachId: coachId, ctgryId: CatagoryId, agoraResourceId: agoraResourceId, agoraAccessToken: Agoaratoken, channelName: channelName)
        coachViewStatusModel.postCoachStatusData(Request: request, token: token)

        // Do any additional setup after loading the view.
        
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        
        
       
    }
    
    
    
    
    
    
    
    
//    @IBAction func btnEndCall(_ sender: Any) {
//
//        let refreshAlert = UIAlertController(title: "Luvo", message: "You want to end this session", preferredStyle: UIAlertController.Style.alert)
//          refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//        print("Handle Cancel Logic here")
//
//              self.countdownTimer?.invalidate()
//
//              self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
//
//
//
//              guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//                //  self.view.stopActivityIndicator()
//                  return
//              }
//              debugPrint("token--->",token)
//
//              guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//                  self.view.stopActivityIndicator()
//                  return
//              }
//              let request = CoachViewStatusRequest(status: "recording", sessId: self.sessionId, agoraSId: self.agoraSId, coachId: self.coachId, ctgryId: self.CatagoryId, agoraResourceId: self.agoraResourceId, agoraAccessToken: self.Agoaratoken, channelName: self.channelName)
//              self.coachViewStatusModel.postCoachStatusData(Request: request, token: token)
//
//
//               }))
//
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                              print("Handle Cancel Logic here")
//
//
//        }))
//
//            present(refreshAlert, animated: true, completion: nil)
//
//
//        countdownTimer?.invalidate()
//
//
//
//
//
////        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
////            self.view.stopActivityIndicator()
////            return
////        }
////        debugPrint("token--->",token)
////
////        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
////            self.view.stopActivityIndicator()
////            return
////        }
////        let request = CoachViewStatusRequest(status: "recording", sessId: sessionId, agoraSId: agoraSId, coachId: coachId, ctgryId: CatagoryId, agoraResourceId: agoraResourceId, agoraAccessToken: Agoaratoken, channelName: channelName)
////        coachViewStatusModel.postCoachStatusData(Request: request, token: token)
//
//        // Do any additional setup after loading the view.
//
//      //   let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to start a Conference Call", preferredStyle: UIAlertController.Style.alert)
////         let refreshAlert = UIAlertController(title: "Luvo", message: "You want to end this session", preferredStyle: UIAlertController.Style.alert)
///*
//
//         refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//               print("Handle Ok logic here")
//
//             let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//
//             print(time + ", Type :SessionEndCallStart")
//
//             self.ref.child(self.sessionId).setValue(["value": time + ", Type :SessionEndCallStart"])
//
//             refreshAlert.dismiss(animated: true, completion: nil)
//             let callVC = ConstantStoryboard.Call.instantiateViewController(withIdentifier: "CoachCallVC") as! CoachCallVC
//             callVC.sessionId = self.sessionId
//             callVC.agoraToken = self.Agoaratoken
//             callVC.agoraAppId = self.AgoraAppId
//             callVC.agoraChannelName = self.channelName
//             self.navigationController?.pushViewController(callVC, animated: true)
//
//
//         }))*/
//
//        //     refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//        //           print("Handle Cancel Logic here")
//
////                 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
////                       print("Handle Cancel Logic here")
////
////                let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
////
////                print(time + ", Type :SessionEndCallStart")
////
////                self.ref.child(self.sessionId).setValue(["value": time + ", Type :SessionEnd"])
////                self.navigationController?.popViewController(animated: true)
////            }))
////
////        present(refreshAlert, animated: true, completion: nil)
//
//
//
//
//
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let LiveArray = UserDataChat?.results else {return 0}
//
        return LiveArray.count // Here also

   //    return 8
        
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as! ChatViewCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
       // cell.backgroundColor = .clear
       // cell.vard.backgroundColor = .red
        
//        if let imgBreath = UserDataChat?.results?[indexPath.row].location {
//            cell.userImage.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////
//            cell.userImage.layer.cornerRadius = cell.userImage.bounds.width / 2
//            cell.userImage.clipsToBounds = true
//        }
 //       if let imgBreath = ReversedarrUserImage[indexPath.row] {
            cell.userImage.sd_setImage(with: URL(string: ReversedarrUserImage[indexPath.row]), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
            cell.userImage.layer.cornerRadius = cell.userImage.bounds.width / 2
            cell.userImage.clipsToBounds = true
 //       }

        cell.UserName.text = ReveresdarrName[indexPath.row]
       // cell.UserName.text = UserDataChat?.results?[indexPath.row].userName
       // cell.UserTxt.text = UserDataChat?.results?[indexPath.row].text ReveredarrText
        cell.UserTxt.text = ReveredarrText[indexPath.row]
        cell.userTime.text = utcToLocal(dateStr: ReversedarrTime[indexPath.row] as Any as! String) ?? "text"
      
       // cell.userTime.text = utcToLocal(dateStr: UserDataChat?.results?[indexPath.row].chatOn as Any as! String) ?? "text"

        debugPrint(UserDataChat?.results?[indexPath.row].chatOn ?? "test")

        return cell
    }
    

    
}

func utcToLocal(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "HH:mm"
           // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

            return dateFormatter.string(from: date)
        }
        return nil
}


extension CoachViewAgoraVC: AgoraUserProfileModelDelegate
{
    func didReceiveAgoraUserProfileModelResponse(AgoraResponse: AgoraUserProfileImageResponse?) {

        self.view.stopActivityIndicator()

        if(AgoraResponse?.status != nil && AgoraResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            debugPrint(AgoraResponse?.userdetails?.count as Any)
            UserData = AgoraResponse
         
//            for index in 0..<UserData!.count {
//
//            }

            collectionViewImage.reloadData()


        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }

    }

    func didReceiveAgoraUserProfileModelError(statusCode: String?) {

    }

}
extension CoachViewAgoraVC: AgoraRtcEngineDelegate {
    // Callback called when a new host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraEngine?.setupRemoteVideo(videoCanvas)
    }
}
extension CoachViewAgoraVC: AllUserChatModelDelegate
{
    func didReceiveAllUserChatResponse(ChatAllResponse: AllUserChatResponse?) {
        
        debugPrint(ChatAllResponse)
        
        self.view.stopActivityIndicator()
        
        if(ChatAllResponse?.status != nil && ChatAllResponse?.status?.lowercased() == ConstantStatusAPI.success) {
           
           
               
                debugPrint(ChatAllResponse?.results as Any)
               UserDataChat  = ChatAllResponse

            arrName.removeAll()
            arrText.removeAll()
            arrTime.removeAll()
            arrUserImage.removeAll()
            ReveredarrText.removeAll()
            ReveresdarrName.removeAll()
            ReversedarrTime.removeAll()
            ReversedarrUserImage.removeAll()
            for index in 0..<(UserDataChat?.results!.count ?? 0) {

               // debugPrint(UserDataChat?.results?.count as Any)
                arrName.append(UserDataChat?.results![index].userName! ?? "Tst")
                arrText.append(UserDataChat?.results![index].text! ?? "Tst")
                arrTime.append(UserDataChat?.results![index].chatOn! ?? "Tst")
                arrUserImage.append(UserDataChat?.results![index].location! ?? "Tst")

            }
            ReveredarrText = Array(arrText.reversed())
            ReveresdarrName =  Array(arrName.reversed())
            ReversedarrTime = Array(arrTime.reversed())
            ReversedarrUserImage = Array(arrUserImage.reversed())

            debugPrint(arrText)
            debugPrint(ReveredarrText)
            chatView .reloadData()
            
        }
        
    }
    
    func didReceiveAllUserChatModelError(statusCode: String?) {
        
    }
    
    
}

//extension CoachViewAgoraVC : CoachViewStatusModelDelegate
//{
//    func didReceiveCoachViewStatusModelResponse(coachResponse: CoachViewStatusResponse?) {
//        if(coachResponse?.status != nil && coachResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            self.view.stopActivityIndicator()
//
//     //   let refreshAlert = UIAlertController(title: "Luvo", message: "You want to end this session", preferredStyle: UIAlertController.Style.alert)
//     //   refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//           //   print("Handle Cancel Logic here")
//
//       let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//
//       print(time + ", Type :SessionEndCallStart")
//
//       self.ref.child(self.sessionId).setValue(["value": time + ", Type :SessionEnd"])
//       self.navigationController?.popViewController(animated: true)
//  // }))
//
//
////present(refreshAlert, animated: true, completion: nil)
//        //}
//        }
//    }
//
//    func didReceiveCoachViewStatusModelError(statusCode: String?) {
//
//    }
//
//
//
//}

extension CoachViewAgoraVC : CoachViewStatusModelDelegate
{
    func didReceiveCoachViewStatusModelResponse(coachResponse: CoachViewStatusResponse?) {
        if(coachResponse?.status != nil && coachResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            self.view.stopActivityIndicator()
        
//     //   let refreshAlert = UIAlertController(title: "Luvo", message: "You want to end this session", preferredStyle: UIAlertController.Style.alert)
//     //   refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//           //   print("Handle Cancel Logic here")
//
//       let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//
//       print(time + ", Type :SessionEndCallStart")
//
//       self.ref.child(self.sessionId).setValue(["value": time + ", Type :SessionEnd"])
//       self.navigationController?.popViewController(animated: true)
//  // }))
//
//
////present(refreshAlert, animated: true, completion: nil)
//        //}
            
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to start a Conference Call", preferredStyle: UIAlertController.Style.alert)
   //         let refreshAlert = UIAlertController(title: "Luvo", message: "You want to end this session", preferredStyle: UIAlertController.Style.alert)

    
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")

                let time = String(UInt64(Date().timeIntervalSince1970 * 1000))

                print(time + ", Type :SessionEndCallStart")

                self.ref.child(self.sessionId).setValue(["value": time + ", Type :SessionEndCallStart"])
                
                self.ref.child("NewSessionStart").setValue(["value": time + ", session_id :" + self.sessionId + ", Type : SessionEnd"])

                refreshAlert.dismiss(animated: true, completion: nil)
                let callVC = ConstantStoryboard.Call.instantiateViewController(withIdentifier: "CoachCallVC") as! CoachCallVC
                callVC.sessionId = self.sessionId
                callVC.agoraToken = self.Agoaratoken
                callVC.agoraAppId = self.AgoraAppId
                callVC.agoraChannelName = self.channelName
                self.navigationController?.pushViewController(callVC, animated: true)


            }))

                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                      print("Handle Cancel Logic here")

                 //   refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                 //         print("Handle Cancel Logic here")

                   let time = String(UInt64(Date().timeIntervalSince1970 * 1000))

                   print(time + ", Type :SessionEndCallStart")

                   self.ref.child(self.sessionId).setValue(["value": time + ", Type :SessionEnd"])
                    self.ref.child("NewSessionStart").setValue(["value": time + ", session_id :" + self.sessionId + ", Type : SessionEnd"])
                   self.navigationController?.popViewController(animated: true)
               }))

           present(refreshAlert, animated: true, completion: nil)
           
           
        }
    }
    
    func didReceiveCoachViewStatusModelError(statusCode: String?) {
        
    }
    
    
    
}
