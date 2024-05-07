//
//  UserCallAgoraVC.swift
//  Luvo
//
//  Created by BEASiMAC on 05/01/23.
//

import UIKit
import AgoraRtcKit
import Firebase
import FirebaseDatabase
import AVFoundation
class UserCallAgoraVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{

    
    var agoraEngine: AgoraRtcEngineKit!
    // By default, set the current user role to broadcaster to both send and receive streams.
    var userRole: AgoraClientRole = .broadcaster
    var AgoraAppId: String = ""
    var Agoaratoken: String = ""
    var channelName: String = ""
    var  sessionId: String = ""
    var  AgoraUId: String = ""
    var  CallId: String = ""
    var  UserCallId: String = ""
    var joinButton: UIButton!
    private var countdownTimer: Timer?
    var joined: Bool = false
    
    var arrText = [String]()
    var ReveredarrText = [String]()

    var arrName = [String]()
    var ReveresdarrName = [String]()

    var arrTime = [String]()
    var ReversedarrTime = [String]()

    var arrUserImage = [String]()
    var ReversedarrUserImage = [String]()
    
    var isMute: Bool = true
    var isHandsup: Bool = false
    
    var isRemoved: Bool = true
    
   
    
    ///////////////////
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var ChatImageView: UIImageView!
    
    
    @IBOutlet weak var imgVwDonate: UIImageView!
    @IBOutlet weak var vwDonate: UIView!
    
   
    @IBOutlet weak var btnshare: UIButton!
    @IBOutlet weak var chatView: UITableView!
    @IBOutlet weak var imgvb: UIImageView!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var userDetail: UIView!
   
    @IBOutlet weak var imgVwCamera: UIImageView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var btnDisconnectCall: UIImageView!
    @IBOutlet weak var lblLive: UILabel!
    @IBOutlet weak var txtfeildChat: UITextField!
    @IBOutlet weak var lblSessionName: UILabel!
    @IBOutlet weak var btnSend: UIButton!
   
    @IBOutlet weak var ChatArrowIcon: UIImageView!
    @IBOutlet weak var ChatOnOffImageView: UIImageView!
    @IBOutlet weak var HandRaiseOnOffImageView: UIImageView!
    
    //////////////
   // @IBOutlet weak var localView: UIView!
    // var localView: UIView!
   // var remoteView: UIView!
    // The video feed for the r
   var ref: DatabaseReference!
    var chatCallViewModel = UserChatWithCallModelVC()
    var UserCallchatData = AllUserCallChatModel()
    var UserDataChat: AllUserChatResponse?
    var UserImaggeData: CoachCallUserListResponse?
    var CallUserList = CoachCallUserListModel()
    var callListdetails = callUserjoin()
    var handRaiseModel  = HandRaiseModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        ref = Database.database().reference()
        
        
       // remoteView.addSubview(VwDisconnet)
       // self.agoraUserProfileModel.AgoraUserdelegate = self
        debugPrint(sessionId)
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
         //   self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        debugPrint(CallId)
        debugPrint(AgoraAppId)
        debugPrint(Agoaratoken)
        debugPrint(channelName)
        debugPrint(sessionId)
        debugPrint(AgoraUId)
        startTimer()
       
     //   childObserver()
        
        
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          // your code here
            self.initializeAgoraEngine()
            self.joinChannel()
            self.agoraEngine.muteLocalAudioStream(true)
            let image = UIImage(named: "mute-microphone")  //mute-microphone microphone
            self.imgvb.image = image
            self.isMute = true
           // self.view.addSubview(remoteView)
           // remoteView.addSubview(btnDisconnect)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
       // postCallJoinData
        HandRaiseOnOffImageView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(CoachViewAgoraVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(CoachViewAgoraVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        ref = Database.database().reference()
        childObserver()
        
        chatView.reloadData()
        self.UserCallchatData.AllUserChatCalldelegate = self
        self.CallUserList.coachcallUserListDelegate = self
       
        self.handRaiseModel.handRaisedelegate = self
        self.callListdetails.calljoinUser = self


        self.chatView.rowHeight  = UITableView.automaticDimension
        self.chatView.estimatedRowHeight = 156
        chatView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
       // self.view.stopActivityIndicator()
        return
        }
        let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
        
        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
        print(time + ", Type :Chat, du")
        self.ref.child(sessionId+"call").setValue(["value": time + ", Type :UserJoin, du : " + userId])
        
        let request = LiveCallJoinRequest(sessionId: sessionId, callId: CallId, callJoinedStatus: "Joining")
        self.callListdetails.postCallJoinData(date: request, token: token)
        
        self.getChat()
       
        
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        
     //   remoteView.bringSubviewToFront(collectionViewImage)
     //   remoteView.bringSubviewToFront(viewCall)
     //   remoteView.bringSubviewToFront(chatView)
     //   remoteView.bringSubviewToFront(vwDonate)
     //   remoteView.bringSubviewToFront(lblLive)
        remoteView.bringSubviewToFront(MainView)
     //   remoteView.bringSubviewToFront(lblSessionName)
     //   remoteView.bringSubviewToFront(btnDisconnectCall)
     //   remoteView.bringSubviewToFront(userDetail)
        remoteView.bringSubviewToFront(commentView)
        
        
        ChatImageView.layer.masksToBounds = true
        ChatImageView.layer.borderColor = UIColor.white.cgColor
        ChatImageView.layer.borderWidth = 2.0
        ChatImageView.layer.cornerRadius = 15
        
        imgVwUser.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: "CoachImage") ?? "TEST"), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        imgVwUser?.layer.cornerRadius = (imgVwUser?.frame.size.width ?? 0.0) / 2
        imgVwUser?.layer.masksToBounds = true
        imgVwUser?.layer.borderColor = #colorLiteral(red: 0.7058823529, green: 0.02352941176, blue: 0.05098039216, alpha: 1)
        imgVwUser?.layer.borderWidth = 3.0

        lblLive.layer.cornerRadius = 8
        lblLive.layer.masksToBounds = true

        ChatImageView.layer.masksToBounds = true
        ChatImageView.layer.borderColor = UIColor.white.cgColor
        ChatImageView.layer.borderWidth = 2.0
        ChatImageView.layer.cornerRadius = 15
        
    }
    
    private func childObserver()
    {
        
        ref.child(sessionId+"call").observe(.childChanged) { (snapshot) in
            
            if let value = snapshot.value as? String
            {
                debugPrint(value)
                let string = value
                if string.contains("Chat, du") {
                    print("exists")
                    self.getChat()
                }
                
                
                
                else if string.contains("UnmuteCall, du")
                {
                    let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
                    debugPrint(string)
                    debugPrint(userId)
                    if string.contains(userId)
                    {
                    self.isMute = false
                    //self.btnEndCall(false) 1677500376, Type :MuteCall, du : 623548
                    self.muteUnmute()
                        
                        
                    }
                    else{
                        self.isMute = true
                        self.muteUnmute()
                    }
                }
                
                else if string.contains("MuteCall, du")
                {
                    let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
                    debugPrint(string)
                    debugPrint(userId)
                    self.isMute = true
                    //self.btnEndCall(false) 1677500376, Type :MuteCall, du : 623548
                    self.muteUnmute()
                }
                
                else if string.contains("handRaise, du")
                {
                   
                    let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
                    debugPrint(string)
                    debugPrint(userId)
                    
                    if string.contains(userId)
                    {
                    self.handsup()
                    }
                    else
                    {
                        
                    }
                }
                
                else if string.contains("RemoveUserCall, du ")
                {
                    let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
                    debugPrint(userId)
                    print(string)
                    
                    if string.contains(userId)
                    {
                    
                    let refreshAlert = UIAlertController(title: "Luvo", message: "Coach has removed you from call", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                       // isRemoved = true
                        self.btnEndCall(true)
                        
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: HomeViewController.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
                        
                    }))

                    self.present(refreshAlert, animated: true, completion: nil)
                    }
                }
                
                else if string.contains("CallEnd, du ")
                {
                    
                    let refreshAlert = UIAlertController(title: "Luvo", message: "Coach has ended the call", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                       // isRemoved = true
                        self.btnEndCall(true)
                        
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: HomeViewController.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
                        
                    }))

                    self.present(refreshAlert, animated: true, completion: nil)
                }

            }
        }
        
    }
    
    func muteUnmute()
    {
        if isMute == false
        {
            print("hello1")
            let image = UIImage(named: "microphone")  //mute-microphone microphone microphone
            self.imgvb.image = image
            self.agoraEngine.muteLocalAudioStream(false)
            HandRaiseOnOffImageView.isHidden = true
            self.isMute = true
            
        }
        else if isMute == true
        {
            let image = UIImage(named: "mute-microphone")
            self.imgvb.image = image
            self.agoraEngine.muteLocalAudioStream(true)
            print("hello2")
            self.isMute = false
        }
    }
    
    func getChat()
    {
        print("exists")
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
       // self.view.stopActivityIndicator()
        return
    }
        
       self.UserCallchatData.getChatCallDetails(token: token, CallId: CallId)
        
       
        
       
        
    }
    
    func startTimer() {
        
        
        countdownTimer?.invalidate() //cancels it if already running
        countdownTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getImageDetails), userInfo: nil, repeats: true) //1hr call
    }
    
    @IBAction func btnHandsUp(_ sender: Any) {
        
//        if isHandsup == false
        
        print(isMute)
//        {
        
        if isMute == true
        {
            let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
            
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :Chat, du")
            self.ref.child(sessionId+"call").setValue(["value": time + ", Type :handRaise, du : " + userId])
//            isHandsup = true
//            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//                self.view.stopActivityIndicator()
//                return
//            }
//            let request = AllUserhandRaiseRequest(userCallId: CallId, hand: "up")
//            handRaiseModel.postChatCallJoinData(Chat: request, token: token)
            
//        }
//        else if isHandsup == true
//        {
//            let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
//
//            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//            print(time + ", Type :Chat, du")
//            self.ref.child(sessionId+"call").setValue(["value": time + ", Type :handRaise, du : " + userId])
//            isHandsup = false
//            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//                self.view.stopActivityIndicator()
//                return
//            }
//            let request = AllUserhandRaiseRequest(userCallId: CallId, hand: "down")
//            handRaiseModel.postChatCallJoinData(Chat: request, token: token)
//        }
        }
    }
    
    func handsup()
    {
                if isHandsup == false
                {
                    isHandsup = true
                    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                       // self.view.stopActivityIndicator()
                        return
                    }
                    let request = AllUserhandRaiseRequest(userCallId: UserCallId, hand: "up")
                    handRaiseModel.postChatCallJoinData(Chat: request, token: token)
                    HandRaiseOnOffImageView.isHidden = false
                    self.chatText()

                    
                }
                else if isHandsup == true
                {
                    isHandsup = false
                    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                      //  self.view.stopActivityIndicator()
                        return
                    }
                    let request = AllUserhandRaiseRequest(userCallId: UserCallId, hand: "down")
                    handRaiseModel.postChatCallJoinData(Chat: request, token: token)
                    HandRaiseOnOffImageView.isHidden = true
                }
    }

    func chatText()
    {
        let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String

        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
        print(time + ", Type :Chat, du")
        self.ref.child(sessionId+"call").setValue(["value": time + ", Type :Chat, du : " + userId])


        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
         //   self.view.stopActivityIndicator()
            return
        }
        self.view.endEditing(true)

        let userName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserName) as! String
        print(userName)

        //self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        let request = UserChatCallRequest(text: userName + " has one question", callId: CallId)
        chatCallViewModel.postChatCallJoinData(Chat: request, token: token)

    }
    
    
    @objc func getImageDetails()
    {
//        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//
//        print(time + ", Type :UserJoin")
//
//        self.ref.child(sessionId).setValue(["value": time + ", Type :UserJoin"])

        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
         //   self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        self.CallUserList.getCoachCallUserListData(token: token, CallId: CallId)
    }
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            leaveChannel()
            DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
        }

           
    
    
    func initViews() {
            // Initializes the remote video view. This view displays video when a remote host joins the channel.
           
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
    
    @IBAction func btnChat(_ sender: Any) {
        
        leaveChannel()
        
        let chatVC = ConstantStoryboard.chatUser.instantiateViewController(withIdentifier: "ChatWithCoachVC") as! ChatWithCoachVC
        chatVC.sessionId = sessionId
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func Leave(_ sender: Any) {
        
        leaveChannel()
        
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
                print("uid....\(self.AgoraUId)")
                 self.view.stopActivityIndicator()
                
                self.rtcEngine(self.agoraEngine, didJoinedOfUid: UInt(self.AgoraUId) ?? 326391943, elapsed: elapsed)
                    //self.rtcEngine(self.agoraEngine, didJoinedOfUid: uid, elapsed: elapsed)
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
        // Check if leaving the channel wa
        
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
              //  self.view.stopActivityIndicator()
                return
            }
            self.view.endEditing(true)
            
            //self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            let request = UserChatCallRequest(text: txtfeildChat.text, callId: CallId)
            chatCallViewModel.postChatCallJoinData(Chat: request, token: token)
            
          
            debugPrint(UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId))
                debugPrint(sessionId+"call")
            
            let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
            
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :Chat, du")
            self.ref.child(sessionId+"call").setValue(["value": time + ", Type :Chat, du : " + userId])
            txtfeildChat.text = ""
                
            
            
        }
    }
    
    @IBAction func btnEndCall(_ sender: Any) {
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
           // self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)

        let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
        
        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
        print(time + ", Type :Chat, du")
        self.ref.child(sessionId+"call").setValue(["value": time + ", Type :UserJoin, du : " + userId])
        let request = LiveCallJoinRequest(sessionId: sessionId, callId: CallId, callJoinedStatus: "Exiting")
        self.callListdetails.postCallJoinData(date: request, token: token)
//        if isRemoved == false
//        {
//        self.navigationController?.popViewController(animated: true)
//        }
//        else
//        {
//
//        }
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let LiveArray = UserDataChat?.results else {return 0}
//
        return LiveArray.count // Here also

     //  return 8

    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as! ChatViewCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
       // cell.backgroundColor = .clear
       // cell.vard.backgroundColor = .red "https://lh3.googleusercontent.com/a-/AOh14GjTRfUXjqE2M_NCVNiUQ8Mvf8W64-xo10U-sP7Emw=s96-c"

//        if let imgBreath = UserDataChat?.results?[indexPath.row].location {
//            cell.userImage.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////
//            cell.userImage.layer.cornerRadius = cell.userImage.bounds.width / 2
//            cell.userImage.clipsToBounds = true
//        }
//
//        cell.UserName.text = UserDataChat?.results?[indexPath.row].userName
//        cell.UserTxt.text = UserDataChat?.results?[indexPath.row].text
//
//        cell.userTime.text = utcToLocal(dateStr: UserDataChat?.results?[indexPath.row].chatOn as Any as! String) ?? "text"

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

        //debugPrint(UserDataChat?.results?[indexPath.row].chatOn ?? "test")

        return cell
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

  



func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    lblUser.text = String(UserImaggeData?.results?.count ?? 0) + " User Here"
    return UserImaggeData?.results?.count ?? 0
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCellUser", for: indexPath) as! AgoraCoachImageView

//        debugPrint(UserData?.userdetails?[indexPath.row].location as Any)
//        if let imgBreath = (UserData?.userdetails?[indexPath.row].location as Any) {
//            cell.imgView.sd_setImage(with: URL(string: imgBreath as! String), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
//        }

    if let imgBreath = UserImaggeData?.results?[indexPath.row].location {
        cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
       // cell.lblUserName.text = UserData?.userdetails?[indexPath.row].userName
//
    }


  //  convertedLocalStartTime = utcToLocal(dateStr: UserData?.results?[indexPath.row].sessionStarttime as Any as! String) ?? "text"

//        var imageString : String? = ""
//        imageString = (UserData?.userdetails?[indexPath.row].location as Any as? String)
//
////        if let imgBreath = UserData?.userdetails?[indexPath.row].location as Any as? String ?? "text"{
//        cell.imgView.sd_setImage(with: URL(string: imageString!), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////
////            cell.lblSessionname.text = LiveData?.sessionList?[indexPath.row].sessionName
////            cell.LblCoachName.text = LiveData?.sessionList?[indexPath.row].coachname
////            cell.lblsessionDate.text = LiveData?.sessionList?[indexPath.row].sessionStarttime
 //   }



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
}

extension UserCallAgoraVC: AgoraRtcEngineDelegate {
    // Callback called when a new host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        //videoCanvas.uid = uid
        videoCanvas.uid = UInt(AgoraUId) ?? 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraEngine?.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("joined channel, \(channel)!")
    }
    func rtcEngine(
        _ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole
    ) {
        print(newRole)
    }
}

extension UserCallAgoraVC: UserChatWithCallModelDelegate {
    func didReceiveUserchatWithCoachCallError(statusCallCode: String?) {
        
        
        
    }
    
    func didReceiveUserchatWithCoachCallResponse(ChatcallResponse: UserchatWithCoachResponse?) {
       // self.view.stopActivityIndicator()
    if(ChatcallResponse?.status != nil && ChatcallResponse?.status?.lowercased() == ConstantStatusAPI.success)
    {
//    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//    self.view.stopActivityIndicator()
//    return
//  }
    
    debugPrint(ChatcallResponse?.results?.sessionId ?? "test")
       // UserchatData.getChatDetails(token: token, SessionID: ChatResponse?.results?.sessionId ?? "test")
    }
    
    
    
    }
}

extension UserCallAgoraVC : AllUserCallChatModelDelegate
{
    func didReceiveAllUserCallChatResponse(ChatAllResponse: AllUserChatResponse?) {
        
        debugPrint(ChatAllResponse ?? "text")
        
        

        if(ChatAllResponse?.status != nil && ChatAllResponse?.status?.lowercased() == ConstantStatusAPI.success) {

            self.view.stopActivityIndicator()

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
    
    func didReceiveAllUserCallChatModelError(statusCode: String?) {
        
    }
    
    
}

extension UserCallAgoraVC : CoachCallUserListModelDelegate
{
    func didReceiveCoachCallUserListResponse(coachCallUserListResponse: CoachCallUserListResponse?) {
        
        if(coachCallUserListResponse?.status != nil && coachCallUserListResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
            print(coachCallUserListResponse?.results ?? "test")
            UserImaggeData = coachCallUserListResponse
            
            print(UserImaggeData?.results?.count ?? 0)
            collectionViewImage.reloadData()
           
            
        }
        
    }
    
    func didReceiveCoachCallUserListError(statusUserListCode: String?) {
        
    }
    
    
}

extension UserCallAgoraVC : UserCallJoinViewModelDelegate
{
    func didReceiveUserCallJoinResponse(liveResponse: LiveCallJoinResponse?) {
        
        
        UserCallId = liveResponse?.results?._id ?? "test"
        debugPrint(UserCallId)
        
        
    }
    
    func didReceiveUserCallJoinError(statusCode: String?) {
        
    }
    
    
}

extension UserCallAgoraVC : HandRaiseModelDelegate
{
    func didReceiveHandRaiseResponse(HandRaiseResponse: AllUserHandRaiseResponse?) {
        
    }
    
    func didReceiveHandRaiseError(statusCode: String?) {
        
    }
    
    
    
}
