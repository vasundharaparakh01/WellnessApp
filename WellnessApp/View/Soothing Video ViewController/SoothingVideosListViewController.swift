//
//  SoothingVideosListViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 26/10/21.
//

import UIKit

class SoothingListCell: UITableViewCell {
    
    @IBOutlet var imgBackground: UIImageView_Designable!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var viewDuration: UIView_Designable!
    @IBOutlet var lblDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblDesc.textColor = UIColor.white
        viewDuration.backgroundColor = UIColor.colorSetup()
    }
    
    //create your closure here
    var btnFavClick : (() -> ()) = {}
    
    @IBAction func buttonAction(_ sender: UIButton) {
        //Call your closure here
        btnFavClick()
    }
}

class SoothingVideosListViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var tblMain: UITableView!
    
    var soothingViewModel = SoothingVideoViewModel()
    var favViewModel = FavouritesViewModel()
    var arrayVideoList = [SoothingVideosList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        soothingViewModel.delegate = self
        favViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        getSoothingVideoData()
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    func getSoothingVideoData() {
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
            soothingViewModel.getSoothingVideoList(token: token)
        }
    }
    
    //MARK: - Button Func
//    @IBAction func btnFav(_ sender: UIButton) {
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblMain)
//        let indexPath = self.tblMain.indexPathForRow(at: buttonPosition)
//        if indexPath != nil {
//            
//        }
//    }
    
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

extension SoothingVideosListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayVideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoothingListCell", for: indexPath) as! SoothingListCell
        
        if let imgVideo = arrayVideoList[indexPath.row].location {
            cell.imgBackground.sd_setImage(with: URL(string: imgVideo), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
//        if let imgVideo = arrayVideoList[indexPath.row].musicImg {
//            let finalImgPath = Common.WebserviceAPI.baseURL + imgVideo
//            cell.imgBackground.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//        }
        cell.lblTitle.text = arrayVideoList[indexPath.row].musicName
        if let desc = arrayVideoList[indexPath.row].description {
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let atrText = NSMutableAttributedString(string:desc.htmlToString, attributes:attrs)
            cell.lblDesc.attributedText = atrText
        }
        cell.lblDuration.text = arrayVideoList[indexPath.row].duration
        
        if let fav = arrayVideoList[indexPath.row].favorites {
            if fav.count > 0 {
                cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
            } else {
                cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
            }
        }
        
        cell.btnFavClick = {
            if cell.btnFav.currentImage == UIImage(named:"heartOn") {
                cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                self.favouriteData(requestData: self.arrayVideoList[indexPath.row], addToFav: false)
            } else {
                cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                self.favouriteData(requestData: self.arrayVideoList[indexPath.row], addToFav: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soothingVideoPlayerVC = ConstantStoryboard.soothingMusicVideo.instantiateViewController(withIdentifier: "SoothingVideoPlayerViewController") as! SoothingVideoPlayerViewController
        soothingVideoPlayerVC.soothingVideoData = arrayVideoList[indexPath.row]
        navigationController?.pushViewController(soothingVideoPlayerVC, animated: false)
    }
    
    func favouriteData(requestData: SoothingVideosList, addToFav: Bool) {
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

extension SoothingVideosListViewController: SoothingVideoViewModelDelegate {
    func didReceiveSoothingVideoListDataResponse(soothingVideoListDataResponse: SoothingVideosListResponse?) {
        self.view.stopActivityIndicator()
        
        if(soothingVideoListDataResponse?.status != nil && soothingVideoListDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(soothingVideoListDataResponse)
            
            //Setup UI
            if let arrMusic = soothingVideoListDataResponse?.musics {
                if arrMusic.count > 0 {
                    arrayVideoList = arrMusic
                    tblMain.reloadData()
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveSoothingVideoDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension SoothingVideosListViewController: FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
        self.view.stopActivityIndicator()
        
        if(favouriteDataResponse?.status != nil && favouriteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(favouriteDataResponse)
            
            guard let message = favouriteDataResponse?.message else { return }
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveFavouriteDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }    
}
