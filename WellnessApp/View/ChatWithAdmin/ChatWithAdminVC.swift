//
//  ChatWithAdminVC.swift
//  Luvo
//
//  Created by Sahidul on 23/12/21.
//

import UIKit

class ChatWithAdminVC: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewMessageText: UIView!
    @IBOutlet weak var messageTV: UITextView!
    
    var chatViewModel = ChatWithAdminViewModel()
    var messageArraySection: [[Message]]? {
        didSet {
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.scrollToBottom()
                }
            }
        }
    }
    
    private var countdownTimer: Timer?
    let refreshControl = UIRefreshControl()
    
//    let chatArray = ["hello", "hello how are you", "My wife was great", "hjs hjsggvdfv hhg igig iegeif giegheig eiheiuh iuvihei huieh ehueuhehfuashf uoiehuegh uehg ueh oeh regheo", "hbvdbfvbdffv mvbjkdfbv dfmvbdfjb v vjf v", "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", "jkdbjkdfbjkbjv jd hvuhohd oihdf oihohvo iaioaji oufiref peiuioeuie vdhvduihsu soihia osvioviof viojvioej udhdhhdfh df hodh odvoih  diojaioj iodj iojv iodaj ioajioioa eguio aerioepj ioe "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        setupUI()
        setupTableView()
        chatViewModel.delegate = self
        getChatDetails()
        
        //Timer
        countdownTimer?.invalidate() //cancels it if already running
        countdownTimer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true) //10min call
        
        //Pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        chatTableView.addSubview(refreshControl) // not required when using UITableViewController
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
        countdownTimer?.invalidate()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
    
    //MARK: Setup Custom Navbar------------
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: Nav Button Func-------------
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    fileprivate func setupUI() {
        btnCamera.layer.cornerRadius = btnCamera.frame.height / 2
        btnAttachment.layer.cornerRadius = btnAttachment.frame.height / 2
        btnSend.layer.cornerRadius = btnSend.frame.height / 2
        btnSend.backgroundColor = UIColor.colorSetup()
        viewMessageText.layer.cornerRadius = 22
    }
    
    fileprivate func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.register(UINib.init(nibName: "ChatWithAdminTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatWithAdminTableViewCell")
        chatTableView.register(UINib.init(nibName: "ChatReceiveTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatReceiveTableViewCell")
        chatTableView.register(UINib.init(nibName: "ChatReceivedImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatReceivedImageTableViewCell")
        chatTableView.register(UINib.init(nibName: "ChatWithAdminIMageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatWithAdminIMageTableViewCell")
        
    }
    
    fileprivate func getChatDetails() {
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
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            chatViewModel.getMessagesList(token: token)
        }
    }
    
    //MARK: ----Timer Function
    @objc func refreshData() {
        getChatDetails()
    }
    
//MARK: ----------- Button Function ------------
    @IBAction func btnCameraAction(_ sender: Any) {
        ImagePickerManager().pickImageCamera(self) { image in
            let resizeImage = image.resizeWithWidth(width: 200)!
            let jpegRepresent = resizeImage.jpegData(compressionQuality: 1.0)
            
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
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                let request = ChatSendRequest(message: "", image: jpegRepresent)
                self.chatViewModel.sendMessageImage(messageRequest: request, token: token)
            }
        }
    }
    
    @IBAction func btnAttachmentAction(_ sender: Any) {
//        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Under development")
        ImagePickerManager().pickImageGallery(self) { image in
            let resizeImage = image.resizeWithWidth(width: 200)!
            let jpegRepresent = resizeImage.jpegData(compressionQuality: 1.0)
            
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
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                let request = ChatSendRequest(message: "", image: jpegRepresent)
                self.chatViewModel.sendMessageImage(messageRequest: request, token: token)
            }
        }
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
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            let request = ChatSendRequest(message: messageTV.text!, image: nil)
            chatViewModel.sendMessageText(messageRequest: request, token: token)
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

//MARK: *********** TableView delegate and DataSource *********
extension ChatWithAdminVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageArraySection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArraySection?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let label = UILabel()
        label.frame = CGRect.init(x: (headerView.frame.width / 2) - 60, y: 5, width: 120, height: headerView.frame.height-10)
        label.textAlignment = .center
        guard let chatDate = messageArraySection?[section][0].addDate else { return headerView }
        let title = chatViewModel.convertDateToStringFormat(dateString: chatDate, format: DateFormats.dateFormatForChatDate)
        let todayDate = chatViewModel.convertCurrentDateToString(format: DateFormats.dateFormatForChatDate)
        label.text = (title == todayDate) ? "Today" : "\(title)"
        label.backgroundColor = UIColor.init(named: "userChatColor")
        label.layer.cornerRadius = label.frame.height / 2
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = messageArraySection?[indexPath.section][indexPath.row]
        let userId: String = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as! String
        
        if data?.senderID == userId {
            if data?.message == nil {
                let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatReceivedImageTableViewCell") as! ChatReceivedImageTableViewCell
                cell.selectionStyle = .none
                cell.updtaeReceivedImageTableCellData(cellData: data!)
                if let sendTime = data?.addDate {
                    cell.lebelReadTime.text = chatViewModel.convertDateToStringFormat(dateString: sendTime, format: DateFormats.dateFormatForChatTime)
                }
                return cell
            } else {
                let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatReceiveTableViewCell") as! ChatReceiveTableViewCell
                cell.selectionStyle = .none
                cell.updtaeReceivedTableCellData(cellData: data!)
                if let sendTime = data?.addDate {
                cell.lebelReadTime.text = chatViewModel.convertDateToStringFormat(dateString: sendTime, format: DateFormats.dateFormatForChatTime)
                }
                return cell
            }
        } else {
            if data?.message == nil {
                let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatWithAdminIMageTableViewCell") as! ChatWithAdminIMageTableViewCell
                cell.selectionStyle = .none
                cell.updtaeSendImageTableCellData(cellData: data!)
                if let sendTime = data?.addDate {
                cell.labelSeen.text = chatViewModel.convertDateToStringFormat(dateString: sendTime, format: DateFormats.dateFormatForChatTime)
                }
                return cell
            } else {
                let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatWithAdminTableViewCell") as! ChatWithAdminTableViewCell
            //    cell.selectionStyle = .none
            //    cell.updtaeSendTableCellData(cellData: data!)
            //    if let sendTime = data?.addDate {
            //    cell.lebelReadTime.text = chatViewModel.convertDateToStringFormat(dateString: sendTime, format: DateFormats.dateFormatForChatTime)
            //    }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if messageArraySection?[indexPath.section][indexPath.row].message == nil {
             guard let imageUrl = messageArraySection?[indexPath.section][indexPath.row].image else {return}
             let chatImageVC = ConstantStoryboard.chatStoryboard.instantiateViewController(withIdentifier: "ChatImageFullScreenVC") as! ChatImageFullScreenVC
             chatImageVC.modalPresentationStyle = .fullScreen
             chatImageVC.imageUrl = imageUrl
             self.navigationController?.present(chatImageVC, animated: true, completion: nil)
         }
    }
    
    func scrollToBottom() {
        let lastSection = (messageArraySection?.count ?? 0) - 1
        if lastSection > 0 {
            let lastRow = (messageArraySection?[lastSection].count ?? 0) - 1
            if lastSection >= 0, lastRow >= 0 {
                self.chatTableView.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: true)
            }
        }
    }
}

extension ChatWithAdminVC: ChatWithAdminViewModelDelegate {
    
    func didReceiveMessagesDataResponse(chatDataResponse: ChatWithAdminResponse?) {
        self.view.stopActivityIndicator()
        if(chatDataResponse?.status != nil && chatDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            debugPrint(chatDataResponse)
            if let arrMessage = chatDataResponse?.messages {
                let reverseArray: [Message] = arrMessage.reversed()
                let arrayWithSection = chatViewModel.getChatWithSection(chatArray: reverseArray)
                messageArraySection = arrayWithSection
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        refreshControl.endRefreshing()
    }
    
    func disReceiveSendMessageResponse(profileUpdateResponse: ProfileUpdateResponse?) {
        self.view.stopActivityIndicator()
        if(profileUpdateResponse?.status != nil && profileUpdateResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            messageTV.text = ""
            self.getChatDetails()
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveMessagesDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
