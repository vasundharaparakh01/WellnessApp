//
//  MeditationAudioListViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 29/10/21.
//

import UIKit

//fileprivate struct RewardPoint {
//    let isOpenBool: Bool
//}

class MeditationAudioListCell: UITableViewCell {
    
    @IBOutlet var imgBackgroundEQ: UIImageView_Designable!
    @IBOutlet var imgBackground: UIImageView_Designable!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var viewCompleted: UIView_Designable!
    @IBOutlet var lblCompleted: UILabel!
    @IBOutlet var viewLockScreen: UIView_Designable!
    @IBOutlet var imgLockScrren: UIImageView_Designable!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgBackgroundEQ.tintColor = UIColor.colorSetup()
        lblDuration.textColor = UIColor.colorSetup()
        viewCompleted.layer.borderColor = UIColor.colorSetup().cgColor
        lblCompleted.textColor = UIColor.colorSetup()
        viewLockScreen.layer.backgroundColor = UIColor.colorSetup().cgColor
        
        viewLockScreen.isHidden = true  //Overlay lock screen not needed for all 3 blocked chakra, manifestation, high performance as per client call
        
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               
               print(crownList)
               print("chakra level ...--->>>",chakraLevel)
               print("coloris ...--->>>",chakraColour)

        if chakraColour==0 {
        switch chakraLevel {
        case 1:
            imgLockScrren.image = UIImage(named: "lockred")
            break
            
        case 2:
            imgLockScrren.image = UIImage(named: "lockorange")
            break
            
        case 3:
            imgLockScrren.image = UIImage(named: "lockyellow")
            break
            
        case 4:
            imgLockScrren.image = UIImage(named: "lockgreen")
            break
        
        case 5:
            imgLockScrren.image = UIImage(named: "locksky")
            break
            
        case 6:
            imgLockScrren.image = UIImage(named: "lockviolet")
            break
            
        case 7:
            imgLockScrren.image = UIImage(named: "lockpurple")
            break
            
        default:
            imgLockScrren.image = UIImage(named: "lockred")
            break
        }
        }else if crownList == 1 {
            switch chakraColour {
                
            case 1:
                imgLockScrren.image = UIImage(named: "lockred")
                break
                
            case 2:
                imgLockScrren.image = UIImage(named: "lockorange")
                break
                
            case 3:
                imgLockScrren.image = UIImage(named: "lockyellow")
                break
                
            case 4:
                imgLockScrren.image = UIImage(named: "lockgreen")
                break
            
            case 5:
                imgLockScrren.image = UIImage(named: "locksky")
                break
                
            case 6:
                imgLockScrren.image = UIImage(named: "lockviolet")
                break
                
            case 7:
                imgLockScrren.image = UIImage(named: "lockpurple")
                break
                
            default:
                imgLockScrren.image = UIImage(named: "lockred")
                break
            }
            
    }else
        {
        switch chakraLevel {
        case 1:
            imgLockScrren.image = UIImage(named: "lockred")
            break
            
        case 2:
            imgLockScrren.image = UIImage(named: "lockorange")
            break
            
        case 3:
            imgLockScrren.image = UIImage(named: "lockyellow")
            break
            
        case 4:
            imgLockScrren.image = UIImage(named: "lockgreen")
            break
        
        case 5:
            imgLockScrren.image = UIImage(named: "locksky")
            break
            
        case 6:
            imgLockScrren.image = UIImage(named: "lockviolet")
            break
            
        case 7:
            imgLockScrren.image = UIImage(named: "lockpurple")
            break
            
        default:
            imgLockScrren.image = UIImage(named: "lockred")
            break
        }
    }
    
    }
    //create your closure here
    var btnFavClick : (() -> ()) = {}
    
    @IBAction func buttonAction(_ sender: UIButton) {
        //Call your closure here
        btnFavClick()
    }
}

class MeditationAudioListViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var lbl7DayMeditation: UILabel!
    @IBOutlet var tblMain: UITableView!
    
    var meditationMusicVewModel = MeditationAudioViewModel()
    var meditationAudioData: MeditationAudioResponse?
    var meditationAudioRequest: MeditationAudioRequest? //All Data coming from meditation first page and following
    var favViewModel = FavouritesViewModel()
    var arrayAudioList = [MeditationMusics]()
    
    
//    fileprivate var arrAudioOpen = [RewardPoint]()
    fileprivate var totalUserPoint = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        meditationMusicVewModel.delegate = self
        meditationMusicVewModel.delegateAudioUnlock = self
        favViewModel.delegate = self
        
        setupGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        //------------------------------
        
        getMeditationAudioList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
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
//        navigationController?.popViewController(animated: true)
//        navigationController?.popToCustomViewController(viewController: MeditationViewController.self)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    fileprivate func setupGUI() {
        if let chakraName = meditationAudioRequest?.chakraName {
            lbl7DayMeditation.text = "7 Day \(chakraName) Meditation"
        } else {
            //lbl7DayMeditation.text = "Meditation For \(meditationAudioRequest?.VCName ?? "")"
            
            let str = "Meditation For \(meditationAudioRequest?.VCName ?? "")"
            if str == "Meditation For Guided"
            {
                lbl7DayMeditation.text = "Guided Meditation"
            }
            else
            {
            lbl7DayMeditation.text = str
            }
        }
    }
    
    func getMeditationAudioList() {
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
            
            // ExerciseId will always be blank here-------------------***
//            let request = MeditationAPIRequest(meditationId: meditationAudioRequest?.meditationId, chakraId: meditationAudioRequest?.chakraId, exerciseId: meditationAudioRequest?.exerciseId)
            let request = MeditationAPIRequest(meditationId: meditationAudioRequest?.meditationId, chakraId: meditationAudioRequest?.chakraId, exerciseId: "")
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationMusicVewModel.getMeditationAudioList(meditationAudioRequest: request, token: token)
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

extension MeditationAudioListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAudioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeditationAudioListCell", for: indexPath) as! MeditationAudioListCell
        
//        //Compare date to check if the audio is listened yesterday or not then it will open the next audio
//        if indexPath.row > 0 {
//            if let seen = arrayAudioList[indexPath.row - 1].seen {
//                if seen.count > 0 {
//                    if let seendate = seen[0].listen_date {
//                        let DC = Date().dateCompare(date: seendate) //dateCompare(date: seendate)
//                        if DC == true {
//                            cell.viewLockScreen.isHidden = true
//                        } else {
//                            cell.viewLockScreen.isHidden = false
//                        }
//                    }
//                } else {
//                    cell.viewLockScreen.isHidden = false
//                }
//            }
//        } else {
//            cell.viewLockScreen.isHidden = true
//        }
        
        if let imgAlbum = arrayAudioList[indexPath.row].location {
            cell.imgBackground.sd_setImage(with: URL(string: imgAlbum), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
//        if let imgAlbum = arrayAudioList[indexPath.row].musicImg {
//            let finalImgPath = Common.WebserviceAPI.baseURL + imgAlbum
//            cell.imgBackground.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//        }
        cell.lblTitle.text = arrayAudioList[indexPath.row].musicName
        cell.lblDesc.text = arrayAudioList[indexPath.row].description
        cell.lblDuration.text = arrayAudioList[indexPath.row].duration
        
       // if let complete = arrayAudioList[indexPath.row].completed {
            //if complete.count > 0 {
                cell.viewCompleted.isHidden = true  //Completed will always be hidden - Client's call
//            } else {
//                cell.viewCompleted.isHidden = false
//            }
//        }
        
        if let fav = arrayAudioList[indexPath.row].favorites {
            if fav.count > 0 {
                cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
            } else {
                cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
            }
        }
        
        cell.btnFavClick = {
            if cell.btnFav.currentImage == UIImage(named:"heartOn") {
                cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                self.favouriteData(requestData: self.arrayAudioList[indexPath.row], addToFav: false)
            } else {
                cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                self.favouriteData(requestData: self.arrayAudioList[indexPath.row], addToFav: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ////Need to check Blocked chakra or Manifestation or High Performance
        ////Blocked chakra>>>> First audio will always be open
        ////                                > User must need to listen to the audio for atleast 5 minutes minimum
        ////                                > If 5 minutes completed then completed API will get called
        ////                                > If the previous is listened for 5 minutes then the next audio will be opened on next day
        ////
        ////Manifestation>>>>>> First 7 audios will be opened all the time
        ////                                > The user need reward points for each audio to unlock
        ////                                > Each audio point will be deducted from totalUserPoints and the balance will be carry forward to check next
        ////
        ////HighPerformance>>> First 4 audios will be opened all the time
        ////                                > The user need reward points for each audio to unlock
        ////                                > Each audio point will be deducted from totalUserPoints and the balance will be carry forward to check next
        
        if meditationAudioRequest?.VCName == ConstantMeditationStaticName.blocked { //For blocked chakra
            //Compare date to check if the audio is listened yesterday or not then it will open the next audio
            if indexPath.row > 0 {
                if let seen = arrayAudioList[indexPath.row - 1].seen {
                    if seen.count > 0 {
                        if let seendate = seen[0].listen_date {
                            let DC = Date().dateCompare(date: seendate) //dateCompare(date: seendate)
                            if DC == true {
                                PushToVc(indexPath: indexPath)
                            } else {
                                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "You can listen to this audio tomorrow")
                            }
                        }
                    } else {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Listen to the previous audio for at least 5 minutes to unlock")
                    }
                }
            } else {
                PushToVc(indexPath: indexPath)
            }
        } else {    //For manifestation & high performance
            if arrayAudioList[indexPath.row].unlock_points! > 0 && arrayAudioList[indexPath.row].open == 0 { //close
                openAlertWithButtonFunc(title: "Do you want to unlock using \(arrayAudioList[indexPath.row].unlock_points ?? 420) reward points?",
                                        message: "Reward Points Balance - \(totalUserPoint)",
                                        alertStyle: .alert,
                                        actionTitles: ["No","Yes"],
                                        actionStyles: [.default, .default],
                                        actions: [
                                            { _ in
                                                print("No selected")
                                            },
                                            { _ in
                                                if let musicID = self.arrayAudioList[indexPath.row].musicId, let points = self.arrayAudioList[indexPath.row].unlock_points {
                                                    self.postAudioUnlock(musicId: musicID, points: "\(points)")
                                                }
                                            }
                                        ])
            } else {    //open
                PushToVc(indexPath: indexPath)
            }
        }
    }
    
    func PushToVc(indexPath: IndexPath) {
        let playerVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "FullAudioPlayerViewController") as! FullAudioPlayerViewController
        playerVC.arrayAudioListData = arrayAudioList
        indexpath = indexPath
        playerVC.vcName = meditationAudioRequest?.VCName
        navigationController?.pushViewController(playerVC, animated: true)
    }
    
    fileprivate func postAudioUnlock(musicId: String, points: String) {
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
            
            let request = AudioUnlockRequest(musicId: musicId, points: points)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationMusicVewModel.postAudioUnlock(audioUnlockRequest: request, token: token)
        }
    }
    
    func favouriteData(requestData: MeditationMusics, addToFav: Bool) {
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
            //check if add to fav or delete from fav
            if addToFav == true {
                favViewModel.addToFavourite(favRequest: FavouritesRequest(musicId: requestData.musicId, musicType: requestData.musicType), token: token)
            } else {
                favViewModel.deleteFromFavourite(favRequest: FavouritesRequest(musicId: requestData.musicId, musicType: requestData.musicType), token: token)
            }
        }
    }
}

extension MeditationAudioListViewController: MeditationAudioViewModelDelegate {
    func didReceiveMeditationAudioDataResponse(meditationAudioDataResponse: MeditationAudioResponse?) {
        self.view.stopActivityIndicator()
        
        if(meditationAudioDataResponse?.status != nil && meditationAudioDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(meditationAudioDataResponse)
            
            meditationAudioData = meditationAudioDataResponse
            
            if let userPoint = meditationAudioData?.userPoints {
                totalUserPoint = userPoint
//                arrAudioOpen.removeAll()
            }
            
            //Setup UI
            if let arrMusic = meditationAudioData?.musics {
                if arrMusic.count == 0 {
                    if let message = meditationAudioDataResponse?.message {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
                    }
                } else {
                    arrayAudioList = arrMusic
                    tblMain.reloadData()
                    
                    ////Need to check Blocked chakra or Manifestation or High Performance
                    ////Blocked chakra>>>> First audio will always be open
                    ////                                > User must need to listen to the audio for atleast 5 minutes minimum
                    ////                                > If 5 minutes completed then completed API will get called
                    ////                                > If the previous is listened for 5 minutes then the next audio will be opened on next day
                    ////
                    ////Manifestation>>>>>> First 7 audios will be opened all the time
                    ////                                > The user need reward points for each audio to unlock
                    ////                                > Each audio point will be deducted from totalUserPoints and the balance will be carry forward to check next
                    ////
                    ////HighPerformance>>> First 4 audios will be opened all the time
                    ////                                > The user need reward points for each audio to unlock
                    ////                                > Each audio point will be deducted from totalUserPoints and the balance will be carry forward to check next
                    ///
//                    for item in arrayAudioList {
//                        if let unlockPoint = item.unlock_points {
//                            if unlockPoint > 0 {
//                                if unlockPoint > totalUserPoint {
//                                    totalUserPoint = totalUserPoint - unlockPoint
//                                    arrAudioOpen.append(RewardPoint(isOpenBool: true))
//                                } else {
//                                    arrAudioOpen.append(RewardPoint(isOpenBool: false))
//                                }
//                            } else {
//                                arrAudioOpen.append(RewardPoint(isOpenBool: true))
//                            }
//                        }
//                    }
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveMeditationAudioDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension MeditationAudioListViewController: MeditationAudioUnlockViewModelDelegate {
    func didReceiveAudioUnlockDataResponse(audioUnlockDataResponse: AudioUnlockResponse?) {
        self.view.stopActivityIndicator()
        
        if(audioUnlockDataResponse?.status != nil && audioUnlockDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(audioUnlockDataResponse)
            
            guard let message = audioUnlockDataResponse?.message else { return }
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
            
            getMeditationAudioList()
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveAudioUnlockDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension MeditationAudioListViewController: FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
        self.view.stopActivityIndicator()
        
        if(favouriteDataResponse?.status != nil && favouriteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(favouriteDataResponse)
            
            guard let message = favouriteDataResponse?.message else { return }
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
            
            getMeditationAudioList()
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveFavouriteDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
