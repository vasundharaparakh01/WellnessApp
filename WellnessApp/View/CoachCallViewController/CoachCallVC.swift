//
//  CoachCallVC.swift
//  Luvo
//
//  Created by BEASiMAC on 03/01/23.
//

import UIKit
import FirebaseDatabase
import UIKit
import AVFoundation
import AgoraRtcKit

class CoachCallVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    

    
    //var chatView: UITableView!
    //var muteButton: UIButton!
   // var callButton: UIButton!
    //var cameraButton: UIButton!
    
    var CoachCallModel = coachCallModel()
    var coachCallUserList = CoachCallUserListModel()
    var callMute = CoachCallUserMute()
    var callHandRaise = CoachCallUserHandRaiseModel()
    var userRemove = CoachRemoveUserModel()
    var UserCallchatData = AllUserCallChatModel()
    
    // Track if the local user is in a call
    var joined: Bool = false
    var isMute: Bool = false
    var isEnd: Bool = false
    var sessionId : String = ""
    var agoraToken : String = ""
    var agoraAppId : String = ""
    var agoraUId : String = ""
    var agoraChannelName : String = ""
    private var countdownTimer: Timer?
    var agoraEngine: AgoraRtcEngineKit!
    // By default, set the current user role to broadcaster to both send and receive streams.
    var userRole: AgoraClientRole = .broadcaster
    var callId: String = ""
    var RemovecallId: String = ""
    var RemoveSesionId: String = ""
    var userCallId: String = ""
    var userCallIdUserId: String = ""
    var muteCallId: String = ""
    var UserData: CoachCallUserListResponse?
    var HandRaiseData: CoachHandRaiseResponse?
    var UserDataChat: AllUserChatResponse?
    var chatCallViewModel = UserChatWithCallModelVC()
    var ref: DatabaseReference!

    // Update with the App ID of your project generated on Agora Console.
   // let appID = "8fda6058db064863847beb264970c0a8"
   // let appID = "5b3ea4b0c9294002bccee2703bd05542"
    // Update with the temporary token generated in Agora Console.
    
    var arrText = [String]()
    var ReveredarrText = [String]()

    var arrName = [String]()
    var ReveresdarrName = [String]()

    var arrTime = [String]()
    var ReversedarrTime = [String]()

    var arrUserImage = [String]()
    var ReversedarrUserImage = [String]()
    
   // var arruser = []
    
    ///////////////////
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var ChatImageView: UIImageView!
    @IBOutlet weak var imgVwMute: UIImageView!
    
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
    @IBOutlet weak var lblUserCount: UILabel!
    @IBOutlet weak var btnSend: UIButton!
   
    @IBOutlet weak var ChatArrowIcon: UIImageView!
    @IBOutlet weak var ChatOnOffImageView: UIImageView!
    @IBOutlet weak var HandRaiseOnOffImageView: UIImageView!
    
    //////////////
    ///
     var isMuteSelf: Bool = false
    
   // @IBOutlet weak var localView: UIView!
   // @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var chatViewNew: UIView!
    @IBOutlet weak var UserList: UIView!
    @IBOutlet weak var TableViewUserList: UITableView!

    @IBOutlet weak var tblVwHandRaise: UITableView!
    @IBOutlet weak var txtFeildChat: UITextField!
    
    var array = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint(sessionId)
        debugPrint(agoraToken)
        debugPrint(agoraAppId)
        debugPrint(agoraChannelName)
        
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
           
    
            self.initializeAgoraEngine()
            self.joinChannel()
            
//            let sess = self.sessionId+"call"
//            let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
//            let sess2 = ", Type :UserJoin, du : " + sess1
//          //  UserDefaults.standard.set(loginResponse?.userDetail?.userId, forKey: "CoachID")
//            //UserDefaults.standard.set(loginResponse?.userDetail?.userId, forKey: ConstantUserDefaultTag.udUserId)
//
//            print(sess1)
//            print(sess2)
//            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//            print(time + ", Type :UserJoin")
//            self.ref.child(self.sessionId).setValue(["value": time + ", Type :CallStart"])
            
                
            
          
        }
        CoachCallModel.coachcallDelegate = self
        coachCallUserList.coachcallUserListDelegate = self
        callMute.CoachCallUserMuteDelegate = self
        callHandRaise.CoachCallUserHandRaiseDelegate = self
        userRemove.CoachRemoveDelegate = self
        
        array.append(" Nilanjan Ghosh")
        array.append(" design that implements a ")
        array.append("  a design ")
        array.append(" I ")
        array.append(" Beas Consultancy")
        array.append(" pankaj narayan sarkar")
        array.append("  a design ")
        array.append(" I ")

        lblUser.text = "0" + " User Here"
      //  tblVwHandRaise.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        localView.bringSubviewToFront(MainView)
        localView.bringSubviewToFront(commentView)
        localView.bringSubviewToFront(UserList)
        MainView.bringSubviewToFront(chatView)
       // MainView.bringSubviewToFront(bt)
       // chatView.backgroundColor = UIColor.red
        
        ChatImageView.layer.masksToBounds = true
        ChatImageView.layer.borderColor = UIColor.white.cgColor
        ChatImageView.layer.borderWidth = 2.0
        ChatImageView.layer.cornerRadius = 15

        imgVwUser.sd_setImage(with: URL(string: UserDefaults.standard.value(forKey: "CoachProfileImage") as! String), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        imgVwUser?.layer.cornerRadius = (imgVwUser?.frame.size.width ?? 0.0) / 2
        imgVwUser?.layer.masksToBounds = true
        imgVwUser?.layer.borderColor = #colorLiteral(red: 0.7058823529, green: 0.02352941176, blue: 0.05098039216, alpha: 1)
        imgVwUser?.layer.borderWidth = 3.0

        lblLive.layer.cornerRadius = 8
        lblLive.layer.masksToBounds = true

        lblUserCount?.layer.cornerRadius = (lblUserCount?.frame.size.width ?? 0.0) / 2
        lblUserCount.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        
        ref = Database.database().reference()
        
        self.UserCallchatData.AllUserChatCalldelegate = self
        
        self.chatView.rowHeight  = UITableView.automaticDimension
        self.chatView.estimatedRowHeight = 156
        chatView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        
        UserList.isHidden = true
        
    }
    
    func getChat(){
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
        self.view.stopActivityIndicator()
        return
    }
        print(callId)
        
       self.UserCallchatData.getChatCallDetails(token: token, CallId: callId)
    }

    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            leaveChannel()
            DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
        }

    private func childObserver()
    {
        
        ref.child(sessionId+"call").observe(.childChanged) { (snapshot) in
    
      if let value = snapshot.value as? String
      {
        debugPrint(value)
        let string = value
        if string.contains("UserJoin") {
            print("exists")
            self.usercall()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    //call any function
                self.HandRaise()
             }
        }
        
        else if string.contains("handRaise")
        {
            print("get Lost")
            self.HandRaise()
            //self.tblVwHandRaise.reloadData()
            
            
        }
       else if string.contains("Chat, du") {
              print("exists")
              self.getChat()
          }

    }
}
        
    }
    
    
    func initViews() {
            // Initializes the remote video view. This view displays video when a remote host joins the channel.
         //   remoteView = UIView()
         //   self.view.addSubview(remoteView)
            // Initializes the local video window. This view displays video when the local user is a host.
           // localView = UIView()
          //  self.view.addSubview(localView)
            //  Button to join or leave a channel

//        chatView = UITableView()
//        chatView.translatesAutoresizingMaskIntoConstraints = false
//        chatView.backgroundColor = .clear
//        chatView.register(TableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
//        chatView.dataSource = self
//        chatView.delegate = self
//        chatView.rowHeight = UITableView.automaticDimension
//        chatView.estimatedRowHeight = UITableView.automaticDimension
//        chatView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));


//
//            joinButton = UIButton(type: .system)
//            joinButton.frame = CGRect(x: 40, y: 20, width: 100, height: 50)
//            joinButton.setTitle("Join", for: .normal)
        
//        let image = UIImage(named: "m")
//        muteButton = UIButton()
//        muteButton = UIButton(type: .system)
//       // muteButton.translatesAutoresizingMaskIntoConstraints = false
//        muteButton.setImage(image, for: .normal)
//        muteButton.addTarget(self, action: #selector(function), for: .touchUpInside)
//
        
       // let imageCall = UIImage(named: "btn_end_call")
      ///  callButton = UIButton()
       // callButton = UIButton(type: .system)
       // muteButton.translatesAutoresizingMaskIntoConstraints = false
      //  callButton.setImage(imageCall, for: .normal)
      //  callButton.addTarget(self, action: #selector(CallEnd), for: .touchUpInside)
//
        
//        let imageCam = UIImage(named: "btn_end_call")
//        cameraButton = UIButton()
//        cameraButton = UIButton(type: .system)
//       // muteButton.translatesAutoresizingMaskIntoConstraints = false
//        cameraButton.setImage(imageCam, for: .normal)
//        cameraButton.addTarget(self, action: #selector(CallEnd), for: .touchUpInside)




//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.bounds.size.height{
//
//            case 480:
//                print("iPhone 4S")
//            case 568:
//                print("iPhone 5")
//            case 667:
//                print("iPhone 7")
//             //   chatView.frame = CGRect(x: 105, y: 190, width: 260, height: 230)
//             //   muteButton.frame = CGRect(x: 15, y: 450, width: 100, height: 100)
//             //   callButton.frame = CGRect(x: 135, y: 478, width: 45, height: 45)
//             //   cameraButton.frame = CGRect(x: 230, y: 478, width: 45, height: 45)
//            case 926:
//                print("iPhone 7")
//             //   chatView.frame = CGRect(x: 120, y: 680, width: 260, height: 230)
//            default:
//                print(UIScreen.main.bounds.size.height)
//            }
//        }
//
//
//
//      //  addConstraints()
//      //  self.view.addSubview(chatView)
//      //  self.view.addSubview(joinButton)
//      //  self.view.addSubview(muteButton)
//      //  self.view.addSubview(callButton)
//      //  self.view.addSubview(cameraButton)
//


      

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


            debugPrint(UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId))
                debugPrint(sessionId+"call")

            let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String

            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :Chat, du")
            self.ref.child(sessionId+"call").setValue(["value": time + ", Type :Chat, du : " + userId])
            txtfeildChat.text = ""
            
            //self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            let request = UserChatCallRequest(text: txtfeildChat.text, callId: callId)
            chatCallViewModel.postChatCallJoinData(Chat: request, token: token)
            

        }
    }
    
    
    @objc func CallEnd() {
        
//        if !joined {
//            joinChannel()
//            // Check if successfully joined the channel and set button title accordingly
//            //if joined { joinButton.setTitle("Leave", for: .normal)
//                //joinButton.setImage(UIImage(named: "call_disconnect.png"), for: .normal)
//            //}
//        } else {
//            leaveChannel()
            self.btnEndCall(true)
            // Check if successfully left the channel and set button title accordingly
            //if !joined { joinButton.setTitle("Join", for: .normal) }
       // }
        
    }
    
    @IBAction func viewClose(_ sender: Any) {
        
//            let xPosition = UserList.frame.origin.x + 2000
//            let yPosition = UserList.frame.origin.y  // Slide Up - 20px
//
//            let width = UserList.frame.size.width
//            let height = UserList.frame.size.height
//
//        UIView.animate(withDuration: 1.0, animations: {
//            self.UserList.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            self.UserList.isHidden = true
         //   })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
        config.appId = agoraAppId
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
        
        func random(digits:Int) -> String {
            var number = String()
            for _ in 1...digits {
               number += "\(Int.random(in: 1...9))"
            }
            return number
        }
        let result = agoraEngine?.joinChannel(
            byToken: agoraToken, channelId: agoraChannelName, uid: (UInt(random(digits: 6)) ?? 0), mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }
                DispatchQueue.main.async {
                debugPrint("token--->",token)
                print(Int(random(digits: 6)) ?? 0)
                print("uid....\(uid)")
                self.agoraUId = String(uid)
                
                self.CoachCallModel.getCoachCallData(token: token, SessionId: self.sessionId, status: "/active",agoraUid: "?agoraUId=" + String(uid))
                }
            }
        )
        //let tfry = agoraEngine?.j()
            // Check if joining the channel was successful and set joined Bool accordingly
        if (result == 0) {
            joined = true
           // showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
        }
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }

    func leaveChannel() {
        agoraEngine?.stopPreview()
        let result = agoraEngine?.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if (result == 0) { joined = false }
    }
    @IBAction func btnMute(_ sender: Any) {

        if isMuteSelf == false
        {
        let image = UIImage(named: "mute-microphone")  //mute-microphone microphone
            imgVwMute.image = image
            isMuteSelf = true
            agoraEngine.muteLocalAudioStream(true)

           // agoraEngine.switchCamera();
        }
        else if isMuteSelf == true
        {
            let image = UIImage(named: "microphone")
            imgVwMute.image = image
            isMuteSelf = false
            agoraEngine.muteLocalAudioStream(false)

        }
    }

    @IBAction func btnEndCall(_ sender: Any) {

        let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to end this conference call", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")

            let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String

            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :Chat, du")
            self.ref.child(self.sessionId+"call").setValue(["value": time + ", Type :CallEnd, du : " + userId])

            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            debugPrint(self.agoraUId)

          //  debugPrint("token--->",token)
           // print("uid....\(uid)")
            self.CoachCallModel.getCoachCallData(token: token, SessionId: self.sessionId, status: "/inactive",agoraUid: "?agoraUId=" + "")



            for controller in self.navigationController!.viewControllers as Array {
                                      if controller.isKind(of: CoachViewController.self) {
                                          self.navigationController!.popToViewController(controller, animated: true)
                                          break
                                      }
                                  }


        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancl logic here")

        }))

        self.present(refreshAlert, animated: true, completion: nil)
       


  
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == TableViewUserList
        {
        guard let LiveArray = UserData?.results else {return 0}
            lblUser.text = String(LiveArray.count ) + " User Here"
            lblUserCount.text = String(LiveArray.count)
        return LiveArray.count

           // return 10
            
        }
        if tableView == tblVwHandRaise
        {
            
            guard let HandArray = HandRaiseData?.results else {return 0}

           return HandArray.count
            
      //      return array.count
        }
        
        if tableView == chatView
        {
            guard let LiveArraychat = UserDataChat?.results else {return 0}
    //
            return LiveArraychat.count // Here also
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = UITableViewCell()
        if tableView == TableViewUserList
        {
        
        let cell = TableViewUserList.dequeueReusableCell(withIdentifier: "UserTableList", for: indexPath) as! UserTableList
        
        if UserData?.results?[indexPath.row].voice == "mute"
        {
          print("Yes it is muted ====== >>>>><<<< =======")
            let image = UIImage(named: "mute-microphone")
            cell.imgVwMute.image = image
        }
        else
        {
            print("No it is noot muted ====== >>>>><<<< =======")
            let image = UIImage(named: "microphone")
            cell.imgVwMute.image = image
        }
        userCallId = UserData?.results?[indexPath.row].userCallId ?? "test" //userName
        userCallIdUserId = UserData?.results?[indexPath.row].userId ?? "test"
        RemovecallId = UserData?.results?[indexPath.row].callId ?? "test"
        RemoveSesionId = UserData?.results?[indexPath.row].sessionId ?? "test"
        cell.btnMute.tag = indexPath.row
        cell.btnMute.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(userRemove(sender:)), for: .touchUpInside)
        cell.imgVprofile.sd_setImage(with: URL(string: UserData?.results?[indexPath.row].location ?? "test"), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////            cell.imgVprofile.sd_setImage(with: URL(string: "https://lh3.googleusercontent.com/a/AATXAJy3cmFoHzZ1oe_rCHpK64SUb11WM2u9GONjHLxZ=s96-c"), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        cell.imgVprofile.layer.cornerRadius = cell.imgVprofile.bounds.width / 2
        cell.imgVprofile.clipsToBounds = true
        cell.lblUername.text = UserData?.results?[indexPath.row].userName ?? "test"

        
        return cell
        }
        
        if tableView == tblVwHandRaise
        {
            let cell = tblVwHandRaise.dequeueReusableCell(withIdentifier: "HandRaiseTableViewCell", for: indexPath) as! HandRaiseTableViewCell
            cell.layer.cornerRadius=10 //set corner radius here
            cell.layer.borderColor = UIColor.white.cgColor  // set cell border color here
            cell.layer.borderWidth = 2 // set border width here
           // cell.LblUserNameHandRaise.text = UserData?.results?[indexPath.row].userName
            cell.LblUserNameHandRaise.text = HandRaiseData?.results?[indexPath.row].userName
            //cell.LblUserNameHandRaise.text = array[indexPath.row]
            
            return cell
            
            
        }
        
        if tableView == chatView
        {
            let cell = chatView.dequeueReusableCell(withIdentifier: "CaoachChatViewCell", for: indexPath) as! CaoachChatViewCell
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            cell.backgroundColor = .clear
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

            cell.NewuserImage.sd_setImage(with: URL(string: ReversedarrUserImage[indexPath.row]), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
    //
           cell.NewuserImage.layer.cornerRadius = cell.NewuserImage.bounds.width / 2
            cell.NewuserImage.clipsToBounds = true
    //       }

        cell.NewUserName.text = ReveresdarrName[indexPath.row]
       // cell.UserName.text = UserDataChat?.results?[indexPath.row].userName
       // cell.UserTxt.text = UserDataChat?.results?[indexPath.row].text ReveredarrText
        cell.NewUserTxt.text = ReveredarrText[indexPath.row]
         cell.NewuserTime.text = utcToLocal(dateStr: ReversedarrTime[indexPath.row] as Any as! String) ?? "text"

            return cell
        }
        
      return returnCell
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblVwHandRaise
        {
            debugPrint( HandRaiseData?.results?[indexPath.row].callId ?? "")
            debugPrint( HandRaiseData?.results?[indexPath.row].sessionId ?? "")
            
//            let sess = sessionId+"call"
//          //  let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
//            let sess2 = ", Type :UnmuteCall, du : " + userCallIdUserId
//           // print(sess1)
//            print(sess2)
//            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//            self.ref.child(sess).setValue(["value": time + sess2])
            
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            let request = coachCallUserMuteRequest(callId: ( HandRaiseData?.results?[indexPath.row].callId), voice: "unmute", userCallId: ( HandRaiseData?.results?[indexPath.row].userCallId), hand: "down" )
            callMute.postCoachCallUserMuteData(Request: request, token: token)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                
                
                let sess = self.sessionId+"call"
              //  let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
                let sess2 = ", Type :UnmuteCall, du : " + self.muteCallId
               // print(sess1)
                print(sess2)
                let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
                self.ref.child(sess).setValue(["value": time + sess2])
                
//                self.coachCallUserList.getCoachCallUserListData(token: token, CallId: ( self.HandRaiseData?.results?[indexPath.row].callId)!)
               // isMute = true callId sessionId
               // callId
                
               // self.coachCallUserList.getCoachCallUserListData(token: token, CallId: self.callId)
                
                self.usercall()

                self.HandRaise()

//                let sess = self.sessionId+"call"
//              //  let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
//                let sess2 = ", Type :handRaise, du : " + self.userCallIdUserId
//               // print(sess1)
//                print(sess2)
//                let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//                self.ref.child(sess).setValue(["value": time + sess2])

                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")

           // currentCart.remove(at: indexPath.row) //Remove element from your array
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func userRemove(sender: UIButton)
    {
        let buttonTag = sender.tag

            let indexPath = IndexPath(row: buttonTag, section: 0)
            let currentCell = TableViewUserList.cellForRow(at: indexPath)! as! UserTableList
       // TableViewUserList.deleteRows(at: [indexPath], with: .automatic)
       // UserData?.results?.remove(at: buttonTag)
       // debugPrint(UserData?.results ?? "" )
       // TableViewUserList.reloadData()
       //debugPrint(UserData?.results?[buttonTag].userId ?? "test")
      //  debugPrint(UserData?.results?[indexPath.row].callId ?? "test")
      //  debugPrint(UserData?.results?[indexPath.row].sessionId ?? "test")

        let sess = sessionId+"call"
      //  let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
        let sess2 = ", Type :RemoveUserCall, du : " + (UserData?.results?[buttonTag].userId ?? "test")
       // print(sess1)
        print(sess2)
        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
        self.ref.child(sess).setValue(["value": time + sess2])

        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        
        UserData?.results?.remove(at: buttonTag)
        debugPrint(UserData?.results ?? "" )
        
        TableViewUserList.reloadData()

       // let request = Coachuserremoverequest(sessionId: (UserData?.results?[indexPath.row].sessionId ?? "test"), callId: (UserData?.results?[indexPath.row].callId ?? "test"), callJoinedStatus: "Exiting", userId: (UserData?.results?[buttonTag].userId ?? "test"))
       // userRemove.postCoachRemoveData(Request: request, token: token)

    }
    
    @IBAction func btnSideControl(_ sender: Any) {
        
        UserList.isHidden = false
        
//        let xPosition = UserList.frame.origin.x
//        let yPosition = UserList.frame.origin.y  // Slide Up - 20px
//
//        let width = UserList.frame.size.width
//        let height = UserList.frame.size.height
//
//    UIView.animate(withDuration: 1.0, animations: {
//        self.UserList.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
//      //  self.UserList.isHidden = true
//        })
        
    }
    @objc func connected(sender: UIButton){
        
       // debugprint(UserData?.results?[sender.tag].voice == "mute")
        print(UserData?.results?[sender.tag].voice ?? "")
        
        if UserData?.results?[sender.tag].voice == "mute"
        {
            isMute = false
        }
        else
        {
            isMute = true
        }
        
        if isMute == false
        {
        
        let buttonTag = sender.tag

            let indexPath = IndexPath(row: buttonTag, section: 0)
            let currentCell = TableViewUserList.cellForRow(at: indexPath)! as! UserTableList
            let image = UIImage(named: "microphone")
            currentCell.imgVwMute.image = image


        print(UserData?.results?[buttonTag].userCallId ?? "test") //userCallId
        print(UserData?.results?[buttonTag].userId ?? "test") //userCallIdUserId
        
        
       // MuteCall by user I d from listing
        
        let sess = sessionId+"call"
      //  let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
        let sess2 = ", Type :UnmuteCall, du : " + (UserData?.results?[buttonTag].userId ?? "test")
       // print(sess1)
        print(sess2)
        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
        self.ref.child(sess).setValue(["value": time + sess2])
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        
        let request = coachCallUserMuteRequest(callId: (UserData?.results?[buttonTag].callId ?? "test"), voice: "unmute", userCallId: (UserData?.results?[buttonTag].userCallId ?? "test"), hand: "down" )
        callMute.postCoachCallUserMuteData(Request: request, token: token)
            //isMute = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.usercall()
            }
            
        }
        else if isMute == true
        {
            let buttonTag = sender.tag
            print(userCallId)
            print(userCallIdUserId)
            print(UserData?.results?[buttonTag].userCallId ?? "test") //userCallId
            print(UserData?.results?[buttonTag].userId ?? "test") //userCallIdUserId

            let indexPath = IndexPath(row: buttonTag, section: 0)
            let currentCell = TableViewUserList.cellForRow(at: indexPath)! as! UserTableList
            let image = UIImage(named: "mute-microphone")
            currentCell.imgVwMute.image = image
            
            
           // MuteCall by user I d from listing
            
            let sess = sessionId+"call"
          //  let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
            let sess2 = ", Type :MuteCall, du : " + (UserData?.results?[buttonTag].userId ?? "test")
           // print(sess1)
            print(sess2)
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            self.ref.child(sess).setValue(["value": time + sess2])
            
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            let request = coachCallUserMuteRequest(callId: (UserData?.results?[buttonTag].callId ?? "test"), voice: "mute", userCallId: (UserData?.results?[buttonTag].userCallId ?? "test"), hand: "down" )
            callMute.postCoachCallUserMuteData(Request: request, token: token)
               // isMute = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.usercall()
            }
            
        }
        
     //   self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
    }
    
    func usercall()
    {
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        
        coachCallUserList.getCoachCallUserListData(token: token, CallId: callId)
        
    }
    
    func HandRaise(){
        
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        
        callHandRaise.getCoachCallUserHandRaise(token: token, CallId: callId)
    }
}

extension CoachCallVC: AgoraRtcEngineDelegate {
    // Callback called when a new host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraEngine?.setupRemoteVideo(videoCanvas)
    }
    
   
}

extension CoachCallVC: CoachCallModelDelegate
{
    func didReceiveCoachCallResponse(coachCallResponse: CoachCallResponse?) {
        
        if(coachCallResponse?.status != nil && coachCallResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
            let time1 = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time1 + ", Type :UserJoin")
            self.ref.child(self.sessionId).setValue(["value": time1 + ", Type :CallStart"])
            
            print(coachCallResponse?.results?._id)
            callId = (coachCallResponse?.results?._id) ?? "test"
            self.getChat()
           // self.usercall()
            
            let sess = sessionId+"call"
            let sess1 = (UserDefaults.standard.string(forKey: "CoachID") ?? "Test")
            let sess2 = ", Type :UserJoin, du : " + sess1
          //  UserDefaults.standard.set(loginResponse?.userDetail?.userId, forKey: "CoachID")
            //UserDefaults.standard.set(loginResponse?.userDetail?.userId, forKey: ConstantUserDefaultTag.udUserId)
            
            print(sess1)
            print(sess2)
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :UserJoin")
            self.ref.child(sess).setValue(["value": time + sess2])
                
            childObserver()

            
        }
    }
    
    func didReceiveCoachCallError(statusCode: String?) {
        
        
    }
    
    
}

extension CoachCallVC: CoachCallUserListModelDelegate
{
    func didReceiveCoachCallUserListResponse(coachCallUserListResponse: CoachCallUserListResponse?) {
        
        if(coachCallUserListResponse?.status != nil && coachCallUserListResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
            print(coachCallUserListResponse?.results ?? "test")
            UserData = coachCallUserListResponse
            TableViewUserList.reloadData()
            
        }
        
    }
    
    func didReceiveCoachCallUserListError(statusUserListCode: String?) {
        
    }
    
    
    
}

extension CoachCallVC: CoachCallUserMuteModelDelegate
{
    func didReceiveCoachCallUserMuteModelResponse(muteResponse: coachCallUserMuteResponse?) {
        
        debugPrint(muteResponse?.details?.callJoinedBy ?? "test")
        muteCallId =  muteResponse?.details?.callJoinedBy ?? ""
        
       // DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
        
      //  }
    }
    
    func didReceiveCoachCallUserMuteModelError(statusCode: String?) {
        
        
    }
    
    
    
}

extension CoachCallVC : CoachCallUserHandRaiseModelDelegate
{
    func didReceiveCoachCallUserHandRaiseResponse(CoachCallUserHandRaiseResponse: CoachHandRaiseResponse?) {
        
        if(CoachCallUserHandRaiseResponse?.status != nil && CoachCallUserHandRaiseResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
            print(CoachCallUserHandRaiseResponse ?? "test")
            HandRaiseData = CoachCallUserHandRaiseResponse
            
//            let xPosition = UserList.frame.origin.x + 2000
//            let yPosition = UserList.frame.origin.y  // Slide Up - 20px
//
//            let width = UserList.frame.size.width
//            let height = UserList.frame.size.height
//
//        UIView.animate(withDuration: 1.0, animations: {
//            self.UserList.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
//            })
            tblVwHandRaise.reloadData()
        }
        
    }
    
    func didReceiveCoachCallUserHandRaiseError(statusUserListCode: String?) {
        
    }
    
    
    
}
extension CoachCallVC : AllUserCallChatModelDelegate
{
    func didReceiveAllUserCallChatModelError(statusCode: String?) {
        
    }
    
    func didReceiveAllUserCallChatResponse(ChatAllResponse: AllUserChatResponse?) {
        
        debugPrint(ChatAllResponse ?? "text")
        
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
}
extension CoachCallVC: UserChatWithCallModelDelegate {
    func didReceiveUserchatWithCoachCallError(statusCallCode: String?) {
        
        
        
    }
    
    func didReceiveUserchatWithCoachCallResponse(ChatcallResponse: UserchatWithCoachResponse?) {
        self.view.stopActivityIndicator()
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

extension CoachCallVC: CoachCallUserRemoveDelegate {
    func didReceiveCoachCallUserRemoveResponse(removeResponse: CoachUserRemoveResponse?) {

    }

    func didReceiveCoachCallUserRemoveError(statusCode: String?) {

    }



}
