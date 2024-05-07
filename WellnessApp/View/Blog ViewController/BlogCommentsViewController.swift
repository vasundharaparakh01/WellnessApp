//
//  BlogCommentsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/12/21.
//

import UIKit

class BlogCommentCell: UITableViewCell {
    @IBOutlet var imgLeft: UIImageView!
    @IBOutlet var lblChatReceive: UILabel!
    @IBOutlet var lblDateReceive: UILabel!
    @IBOutlet var lblHeaderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgLeft.layer.cornerRadius = imgLeft.frame.size.width / 2
        imgLeft.backgroundColor = UIColor.colorSetup()
        lblChatReceive.layer.cornerRadius = 10.0
        lblChatReceive.layer.masksToBounds = true
    }
}

class BlogCommentsViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var txtViewChatEntry: UITextView!
    @IBOutlet var btnSend: UIButton!
    
    var blogViewModel = BlogViewModel()
    var commentsArray = [BlogComment]()
    var blogID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        blogViewModel.blogCommentDelegate = self
        
        setupGUI()
        getChatData()
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
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }

    //MARK: Setup Custom Navbar--------------
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: Nav Button Func-------------------
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    //MARK: Setup GUI-------------
    func setupGUI() {
        txtViewChatEntry.textContainer.heightTracksTextView = true
        txtViewChatEntry.isScrollEnabled = false
        txtViewChatEntry.layer.cornerRadius = 10.0
        
        txtViewChatEntry.text = "Comments"
        txtViewChatEntry.textColor = UIColor.lightGray
        
        btnSend.layer.cornerRadius = btnSend.frame.size.width/2
        btnSend.backgroundColor = UIColor.colorSetup()
    }
    
    //MARK: Get API Data----------------
    func getChatData() {
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
            guard let blogID = blogID else { return }
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            blogViewModel.getBlogComments(token: token, blogId: blogID)   //"707269"
        }
    }
    
    //MARK: Button Func-------------
    @IBAction func btnSend(_ sender: Any) {
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard !(txtViewChatEntry.text!.trimmingCharacters(in: .whitespaces).isEmpty) else { return }
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            self.view.endEditing(true)
            
            guard let blogID = blogID else { return }
            let request = BlogCommentSendRequest(blogId: blogID, comments: txtViewChatEntry.text)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            blogViewModel.sendBlogComment(token: token, commentRequest: request)
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

extension BlogCommentsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comments"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension BlogCommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCommentCell", for: indexPath) as! BlogCommentCell
                
        if let usr = commentsArray[indexPath.row].user {
            if usr.count > 0 {
                if let usrName = usr[0].userName {
                    cell.lblHeaderName.text = usrName
                }
            }
        }
        
        if let msg = commentsArray[indexPath.row].comments {
            cell.lblChatReceive.text = msg
        }
        
        if let usr = commentsArray[indexPath.row].user {
            if usr.count > 0 {
                if let profileImg = usr[0].location {
                    cell.imgLeft.sd_setImage(with: URL(string: profileImg), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                }
//                if let profileImg = usr[0].profileImg {
//                    let imagePath = Common.WebserviceAPI.baseURL + profileImg
//                    cell.imgLeft.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//                }
            }
        }
        
        if let dateTime = commentsArray[indexPath.row].add_date {
            cell.lblDateReceive.text = formatUnixDate(date: dateTime)
        }
        
        return cell
    }
    
    //MARK: Date Formatter--------------------
    func formatUnixDate(date: String) -> String {
        let dateFromString = Date().UTCFormatter(date: date)

        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        dateFormatter2.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter2.amSymbol = "AM"
        dateFormatter2.pmSymbol = "PM"
        dateFormatter2.timeZone = .current
        let stringFromDate = dateFormatter2.string(from: dateFromString)
        debugPrint("formatDate--->",stringFromDate)
        return stringFromDate
    }
    
}

extension BlogCommentsViewController: BlogCommentsViewModelDelegate {
    func didReceiveBlogCommentSendDataResponse(blogCommentSendDataResponse: BlogCommentSendResponse?) {
        self.view.stopActivityIndicator()
        
        if(blogCommentSendDataResponse?.status != nil && blogCommentSendDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(blogCommentSendDataResponse)
            
            txtViewChatEntry.text = "Comments"
            txtViewChatEntry.textColor = UIColor.lightGray
            getChatData()
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveBlogGetCommentDataResponse(blogGetCommentDataResponse: BlogCommentGetResponse?) {
        self.view.stopActivityIndicator()
        
        if(blogGetCommentDataResponse?.status != nil && blogGetCommentDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(blogGetCommentDataResponse)
            
            if let commentArr = blogGetCommentDataResponse?.comments {
                commentsArray = commentArr
            }
            tblMain.reloadData()
            self.view.layoutIfNeeded()
            scrollToBottom()
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveBlogGetCommentDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func scrollToBottom()  {
        let point = CGPoint(x: 0, y: self.tblMain.contentSize.height + self.tblMain.contentInset.bottom - self.tblMain.frame.height)
        if point.y >= 0{
            self.tblMain.setContentOffset(point, animated: true)
        }
    }
}
