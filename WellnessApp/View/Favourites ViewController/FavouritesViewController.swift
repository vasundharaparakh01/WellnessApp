//
//  FavouritesViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-20.
//

import UIKit

class FavouritesViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var tblMain: UITableView!
    
    var favViewModel = FavouritesViewModel()
    var meditationAudioData: MeditationAudioResponse?
    var arrayAudioList = [MeditationMusics]()
    var arrayVideoList = [SoothingVideosList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        favViewModel.delegate = self
        favViewModel.favListDelegate = self
        
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        getFavList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fromSideMenu = false
        
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
    
    fileprivate func setupTableView() {
        tblMain.delegate = self
        tblMain.dataSource = self
        
        tblMain.separatorStyle = .none
//        tblMain.register(BadgeTableViewCell.self, forCellReuseIdentifier: "BadgeTableViewCell")
        tblMain.register(UINib.init(nibName: "FavVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "FavVideoTableViewCell")
        tblMain.register(UINib.init(nibName: "FavAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "FavAudioTableViewCell")
    }
    
    fileprivate func getFavList() {
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
            favViewModel.getFavouriteList(token: token)
        }
    }
    
    //MARK: ----- Notification Setup -------------------------
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

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayAudioList.count
        } else {
            return arrayVideoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavAudioTableViewCell", for: indexPath) as! FavAudioTableViewCell
            
            cell.updateFavAudioTableData(cellData: arrayAudioList[indexPath.row])
            
            cell.btnFavClick = {
                if cell.btnFav.currentImage == UIImage(named:"heartOn") {
                    cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                    self.favouriteData(musicId: self.arrayAudioList[indexPath.row].musicId! ,musicType: self.arrayAudioList[indexPath.row].musicType!, addToFav: false)
                }
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavVideoTableViewCell", for: indexPath) as! FavVideoTableViewCell
            
            cell.updateFavVideoTableData(cellData: arrayVideoList[indexPath.row])
            
            cell.btnFavClick = {
                if cell.btnFav.currentImage == UIImage(named:"heartOn") {
                    cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                    self.favouriteData(musicId: self.arrayVideoList[indexPath.row].musicId! ,musicType: self.arrayVideoList[indexPath.row].musicType!, addToFav: false)
                }
            }
            return cell
        }
        //            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        //
        //            if( !(cell != nil)) {
        //                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        //            }
        //
        //            cell!.textLabel?.text = "No data Found"
        //            return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PushToVc(indexPath: indexPath)
    }
    
    func PushToVc(indexPath: IndexPath) {
        if indexPath.section == 0 {
            let meditationMusic = MeditationMusics(add_date: arrayAudioList[indexPath.row].add_date,
                                                   chakraId: arrayAudioList[indexPath.row].chakraId,
                                                   completed: arrayAudioList[indexPath.row].completed,
                                                   description: arrayAudioList[indexPath.row].description,
                                                   duration: arrayAudioList[indexPath.row].duration,
                                                   exerciseId: arrayAudioList[indexPath.row].exerciseId,
                                                   favorites: arrayAudioList[indexPath.row].favorites,
                                                   meditationId: arrayAudioList[indexPath.row].meditationId,
                                                   musicFile: arrayAudioList[indexPath.row].musicFile,
                                                   musicId: arrayAudioList[indexPath.row].musicId,
                                                   musicImg: arrayAudioList[indexPath.row].musicImg,
                                                   musicName: arrayAudioList[indexPath.row].musicName,
                                                   musicType: arrayAudioList[indexPath.row].musicType,
                                                   pointDuration: arrayAudioList[indexPath.row].pointDuration,
                                                   seen: arrayAudioList[indexPath.row].seen,
                                                   step1: arrayAudioList[indexPath.row].step1,
                                                   step2: arrayAudioList[indexPath.row].step2,
                                                   step3: arrayAudioList[indexPath.row].step3,
                                                   step4: arrayAudioList[indexPath.row].step4,
                                                   unlock_points: arrayAudioList[indexPath.row].unlock_points,
                                                   open: arrayAudioList[indexPath.row].open,
                                                   musicLocation: arrayAudioList[indexPath.row].musicLocation,
                                                   location: arrayAudioList[indexPath.row].location)
            
            var arrOfSingleObjectToSend = [MeditationMusics]()
            arrOfSingleObjectToSend.append(meditationMusic)
            
            let playerVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "FullAudioPlayerViewController") as! FullAudioPlayerViewController
            playerVC.arrayAudioListData = arrOfSingleObjectToSend
            indexpath = IndexPath(row: 0, section: 0)
            playerVC.fromFavourite = true
            if let meditationId = arrayAudioList[indexPath.row].meditationId {
                if meditationId == ConstantMeditationID.blockedChakras {
                    playerVC.vcName = ConstantMeditationStaticName.blocked
                } else if meditationId == ConstantMeditationID.manifestation {
                    playerVC.vcName = ConstantMeditationStaticName.manifestation
                } else if meditationId == ConstantMeditationID.highPerformance {
                    playerVC.vcName = ConstantMeditationStaticName.performance
                }
            }
            navigationController?.pushViewController(playerVC, animated: true)
            
        } else {
            let videoData = SoothingVideosList(musicId: arrayVideoList[indexPath.row].musicId,
                                               musicType: arrayVideoList[indexPath.row].musicType,
                                               musicName: arrayVideoList[indexPath.row].musicName,
                                               musicFile: arrayVideoList[indexPath.row].musicFile,
                                               musicImg: arrayVideoList[indexPath.row].musicImg,
                                               description: arrayVideoList[indexPath.row].description,
                                               duration: arrayVideoList[indexPath.row].duration,
                                               add_date: arrayVideoList[indexPath.row].add_date,
                                               favorites: arrayVideoList[indexPath.row].favorites,
                                               musicLocation: arrayVideoList[indexPath.row].musicLocation,
                                               location: arrayVideoList[indexPath.row].location)
            
            let soothingVideoPlayerVC = ConstantStoryboard.soothingMusicVideo.instantiateViewController(withIdentifier: "SoothingVideoPlayerViewController") as! SoothingVideoPlayerViewController
            soothingVideoPlayerVC.soothingVideoData = videoData
            navigationController?.pushViewController(soothingVideoPlayerVC, animated: false)
        }
    }
    
    fileprivate func favouriteData(musicId: String, musicType: String, addToFav: Bool) {
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
            favViewModel.deleteFromFavourite(favRequest: FavouritesRequest(musicId: musicId, musicType: musicType), token: token)
        }
    }
}

extension FavouritesViewController: FavouritesListViewModelDelegate {
    func didReceiveFavouriteListDataResponse(favouriteListDataResponse: MeditationAudioResponse?) {
        self.view.stopActivityIndicator()
        
        if(favouriteListDataResponse?.status != nil && favouriteListDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            meditationAudioData = favouriteListDataResponse
//            if let arrMusic = meditationAudioData?.musics {
//                let videoMusic = meditationAudioData?.videos
//                arrayAudioList.removeAll()
//                arrayVideoList.removeAll()
//                if arrMusic.count == 0 && videoMusic?.count == 0 {
//                    if let message = favouriteListDataResponse?.message {
//                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
//                    }
//                } else if arrMusic.count > 0{
//                    arrayAudioList = arrMusic
//                } else if videoMusic?.count > 0 {
//                    arrayVideoList = videoMusic ?? []
//                }
//                tblMain.reloadData()
//            }
            
            ///EDITED BY PK FOR  LOGIC
            if let arrMusic = meditationAudioData?.musics {
                arrayAudioList.removeAll()
                if arrMusic.count == 0 {
                    if let message = favouriteListDataResponse?.message {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
                    }
                } else if arrMusic.count > 0{
                    arrayAudioList = arrMusic
                } else {
                    arrayAudioList = []
                }
            }

            if let videoMusic = meditationAudioData?.videos {
                arrayVideoList.removeAll()
                if videoMusic.count == 0 {
                    if let message = favouriteListDataResponse?.message {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
                    }
                } else if videoMusic.count > 0 {
                    arrayVideoList = videoMusic
                } else {
                    arrayVideoList = []
                }
            }
            tblMain.reloadData()
            

            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveFavouriteListDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension FavouritesViewController: FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
        self.view.stopActivityIndicator()
        
        if(favouriteDataResponse?.status != nil && favouriteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(favouriteDataResponse)
            
            guard let message = favouriteDataResponse?.message else { return }
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
            
            getFavList()
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveFavouriteDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
