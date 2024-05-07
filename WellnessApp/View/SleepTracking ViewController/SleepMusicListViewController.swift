//
//  SleepMusicListViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 14/02/22.
//

import UIKit

class SleepAudioListCell: UITableViewCell {
    
    @IBOutlet var imgBackgroundEQ: UIImageView_Designable!
    @IBOutlet var imgBackground: UIImageView_Designable!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgBackgroundEQ.tintColor = UIColor.colorSetup()
        lblDuration.textColor = UIColor.colorSetup()
    }
}

class SleepMusicListViewController: UIViewController {

    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var lbl7DayMeditation: UILabel!
    @IBOutlet var tblMain: UITableView!
    
    var sleepVM = SleepViewModel()
    var meditationAudioData: MeditationAudioResponse?
    var arrayAudioList = [MeditationMusics]()
    
    typealias completionHandler = (MeditationMusics) -> Void
    var completion: completionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        sleepVM.sleepAudioListDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(FAQViewController.setupNotificationBadge),
//                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
//                                               object: nil)
//
//        setupNotificationBadge()
        
        getSleepAudioList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
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
    @IBAction func btnBack(_ sender: Any) {
        //Pop to custom view controller
        self.navigationController?.popViewController(animated: true)
//        navigationController?.popToCustomViewController(viewController: MeditationViewController.self)
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
        
    func getSleepAudioList() {
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
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            sleepVM.getSleepAudioList(token: token)
        }
    }
    
//    //MARK: -----Notification Setup
//    @objc func setupNotificationBadge() {
//        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }
//        
//        if badgeCount != 0 {
//            viewNotificationCount.isHidden = false
//            lblNotificationLabel.text = "\(badgeCount)"
//        } else {
//            viewNotificationCount.isHidden = true
//            lblNotificationLabel.text = "0"
//        }
//        print("BADGE COUNT-----\(badgeCount)")
//    }
}

extension SleepMusicListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAudioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepAudioListCell", for: indexPath) as! SleepAudioListCell
        
        if let imgAlbum = arrayAudioList[indexPath.row].location {
            cell.imgBackground.sd_setImage(with: URL(string: imgAlbum), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
        
        cell.lblTitle.text = arrayAudioList[indexPath.row].musicName
        cell.lblDesc.attributedText = arrayAudioList[indexPath.row].description?.htmlToAttributedString
        cell.lblDuration.text = arrayAudioList[indexPath.row].duration
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.PopToVc(indexPath: indexPath)
    }
    
    private func PopToVc(indexPath: IndexPath) {
        guard let completionBlock = self.completion else { return }
        completionBlock(self.arrayAudioList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension SleepMusicListViewController: SleepAudioListDelegate {
    func didReceiveSleepAudioListResponse(sleepAudioListResponse: MeditationAudioResponse?) {
        self.view.stopActivityIndicator()
        
        if(sleepAudioListResponse?.status != nil && sleepAudioListResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            
            meditationAudioData = sleepAudioListResponse
            
            //Setup UI
            if let arrMusic = meditationAudioData?.musics {
                if arrMusic.count == 0 {
                    if let message = sleepAudioListResponse?.message {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
                    }
                } else {
                    arrayAudioList = arrMusic
                    tblMain.reloadData()
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveSleepAudioListError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
