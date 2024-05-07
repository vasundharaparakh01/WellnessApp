//
//  VideoPlay.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 21/06/22.
//
import HealthKit
import UIKit
import AVKit
import AVFoundation
class VideoPlay: UIViewController, FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
        
    }
    
    func didReceiveFavouriteDataError(statusCode: String?) {
        
    }
    
    
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet weak var coachImgVw: UIImageView!
    @IBOutlet weak var SessionNameNew: UILabel!
    @IBOutlet weak var ImagVwheart: UIImageView!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var lblDonate: UILabel!
    @IBOutlet weak var ImgVwDonate: UIImageView!
    @IBOutlet weak var coachName: UILabel!
    @IBOutlet weak var imgVwCal: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblSessionDescription: UILabel!
    @IBOutlet weak var imgVwIcon: UIImageView!
    //AVPlayer
    var healthStore = HKHealthStore()
    var player:AVPlayer?
    var timeObserver: Any?
    var RecordedUrl: String = ""
    var SessionName: String = ""
    var CoachName: String = ""
    var Description: String = ""
    var NoofUsers: String = ""
    var Durstion: String = ""
    var coachImage: String = ""
    var dateE: String = ""
    var isPayMent: String = ""

    fileprivate let seekDuration: Float64 = 10
    
    @IBOutlet var viewVideoPlayer: UIView!
    @IBOutlet weak var lblOverallDuration: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnFullscreen: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSkip: UIButton!

    //------------------
    
    @IBOutlet var imgSemiCircleBack: UIImageView!
    @IBOutlet var btnFav: UIButton!
    
    var soothingVideoData: SoothingVideosList?
    var favViewModel = FavouritesViewModel()
   
    var boolFav = false
    
    let startTrackTime = Date() //Timer to keep track of time spent on this page
    var timeTrackViewModel = TimeTrackingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomNavBar()
        
        favViewModel.delegate = self
        timeTrackViewModel.delegate = self
        
        setupVideoControlButton()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

        debugPrint(SessionNameNew)
        debugPrint(Durstion)
        debugPrint(NoofUsers)
        debugPrint(CoachName)
        debugPrint(isPayMent)
        
        let staturSettings = UserDefaults.standard.bool(forKey:"FromSettings")
        print(staturSettings)
        if staturSettings == true
        {
            let status = UserDefaults.standard.bool(forKey: "isFromRecordedSession")
                            print(status)
                if status == true
            {
            
            btnBack.isHidden=false
            btnSkip.isHidden=true
            self.view.backgroundColor = .white
                    
                    let status = UserDefaults.standard.bool(forKey: "isFromCoachRecordedSession")
                                    print(status)
                        if status == true
                    {

                            print(Durstion)

                            coachImgVw.isHidden=false
                            SessionNameNew.isHidden=false
                            ImagVwheart.isHidden=true
                            btnDonate.isHidden=true
                            lblDonate.isHidden=true
                             ImgVwDonate.isHidden=true
                             coachName.isHidden=false
                             imgVwCal.isHidden=false
                             lblDate.isHidden=false
                             lblDuration.isHidden=false
                             imgVwIcon.isHidden=false
                            lblSessionDescription.isHidden=false
                            
                            lblDate.text = dateE
                           lblDuration.text = Durstion
                            coachName.text = CoachName
                            SessionNameNew.text = SessionName
                            lblSessionDescription.text = Description
//                            lblSessionDescription.text = "Gratitude meditation is a mindfulness practice that involves focusing your attention on the things you feel grateful for in your life"
                            ImgVwDonate.layer.cornerRadius = 10
                            coachImgVw.layer.cornerRadius = coachImgVw.bounds.width / 2
                            coachImgVw.clipsToBounds = true
                            coachImgVw.sd_setImage(with: URL(string: coachImage), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                    }
                    
                    else
                    {
                        print(Durstion)

                        coachImgVw.isHidden=false
                        SessionNameNew.isHidden=false
                        if isPayMent == "false"
                        {
                            ImagVwheart.isHidden=true
                            btnDonate.isHidden=true
                            lblDonate.isHidden=true
                            ImgVwDonate.isHidden=true
                        }
                        else
                        {
                            ImagVwheart.isHidden=false
                            btnDonate.isHidden=false
                            lblDonate.isHidden=false
                            ImgVwDonate.isHidden=false
                        }
                        
                         coachName.isHidden=false
                         imgVwCal.isHidden=false
                         lblDate.isHidden=false
                         lblDuration.isHidden=false
                         imgVwIcon.isHidden=false
                        lblSessionDescription.isHidden=false
                        // coachImgVw.img
                         lblDate.text = dateE
                         lblDuration.text = Durstion
                         coachName.text = CoachName
                         SessionNameNew.text = SessionName
                        lblSessionDescription.text = Description
//                        lblSessionDescription.text = "Gratitude meditation is a mindfulness practice that involves focusing your attention on the things you feel grateful for in your life"
                         ImgVwDonate.layer.cornerRadius = 10
                         coachImgVw.layer.cornerRadius = coachImgVw.bounds.width / 2
                         coachImgVw.clipsToBounds = true
                         coachImgVw.sd_setImage(with: URL(string: coachImage), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                    }
                    
                   
                    
                   
            }
            
            else{
                
                btnBack.isHidden=false
                btnSkip.isHidden=true
               // self.view.backgroundColor = .black
                coachImgVw.isHidden=true
                SessionNameNew.isHidden=true
                ImagVwheart.isHidden=true
                btnDonate.isHidden=true
                lblDonate.isHidden=true
                 ImgVwDonate.isHidden=true
                 coachName.isHidden=true
                 imgVwCal.isHidden=true
                 lblDate.isHidden=true
                 lblDuration.isHidden=true
                 imgVwIcon.isHidden=true
                lblSessionDescription.isHidden=true
                        
                      
            }
        }
        else
        {
            btnBack.isHidden=true
            btnSkip.isHidden=false
            
            coachImgVw.isHidden=true
            SessionNameNew.isHidden=true
            ImagVwheart.isHidden=true
            btnDonate.isHidden=true
            lblDonate.isHidden=true
             ImgVwDonate.isHidden=true
             coachName.isHidden=true
             imgVwCal.isHidden=true
             lblDate.isHidden=true
             lblDuration.isHidden=true
             imgVwIcon.isHidden=true
            lblSessionDescription.isHidden=true
            
           
        }
        
       
        
        super.viewWillAppear(animated)
        //NotificationCenter.default.addObserver(self,
        //                                       selector: #selector(FAQViewController.setupNotificationBadge),
        //                                       name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
        //                                       object: nil)
        
       // setupNotificationBadge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let status = UserDefaults.standard.bool(forKey: "IsfromDonation")
                                print(status)

        if status==true
        {
            UserDefaults.standard.set(false, forKey: "IsfromDonation")
            player?.play()
        }

        else
        {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.setupVideoPlayer()
        }
        }
    }

    fileprivate func removePeriodicTimeObserver() {
        // If a time observer exists, remove it
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    @objc func setupNotificationBadge() {
        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }

        if badgeCount != 0 {
            viewNotificationCount.isHidden = false
            lblNotificationLabel.text = "\(badgeCount)"
        } else {
           // viewNotificationCount.isHidden = true
           // lblNotificationLabel.text = "0"
        }
        print("BADGE COUNT-----\(badgeCount)")
    }
    
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }

    @IBAction func btnDonation(_ sender: Any) {
        player?.pause()
        UserDefaults.standard.set(false, forKey: "IsfromHome")
        UserDefaults.standard.set(true, forKey: "IsfromRecord")
        UserDefaults.standard.set(false, forKey: "IsfromSession")
              let callVC = ConstantStoryboard.Payment.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
              self.navigationController?.pushViewController(callVC, animated: false)



    }
    
    @IBAction func btnBack(_ sender: Any) {
 //       updateTimeTrack()
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        UserDefaults.standard.set(false, forKey: "isFromRecordedSession")

        player?.replaceCurrentItem(with: nil)
        self.view.stopActivityIndicator()
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
//        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
//        navigationController?.pushViewController(notifyVC, animated: true)
        
        
        let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to measure your regular activities through", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "iPhone", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
            
            self.player?.replaceCurrentItem(with: nil)
            
            UserDefaults.standard.set(false, forKey: "isFromWatch")
            UserDefaults.standard.set(false, forKey: "isPermissiongranted")
                    let baseTabVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                    self.navigationController?.pushViewController(baseTabVC, animated: true)
            
        }))

        refreshAlert.addAction(UIAlertAction(title: "Apple Watch", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
            
            self.player?.replaceCurrentItem(with: nil)
            self.autorizeHealthKit()
            // Do any additional
        }))

        present(refreshAlert, animated: true, completion: nil)
        
//        player?.replaceCurrentItem(with: nil)
//
//
//        let baseTabVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
//        self.navigationController?.pushViewController(baseTabVC, animated: true)
    }
    //-----------------------------
    
    func setupVideoControlButton() {
        btnRewind.tintColor = UIColor.colorSetup()
        ButtonPlay.tintColor = UIColor.colorSetup()
        btnForward.tintColor = UIColor.colorSetup()
        playbackSlider.tintColor = UIColor.colorSetup()
        btnFullscreen.tintColor = UIColor.colorSetup()
    }
    
    func autorizeHealthKit()
        {
            let read = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!,HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning)!])
//            let share = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!,HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning)!])
            healthStore.requestAuthorization(toShare: read, read: read) { (chk, err) in
                
                if chk
                {
                    print("Permission granted")
                   // self.LatestHeartRate()
                   //  self.stepcount()
                   // self.retrieveSleepAnalysis()
                  //  self.readSleep(from: Date.yesterday, to: Date.tomorrow )
                    
                    DispatchQueue.main.async {
                    
                    self.player?.replaceCurrentItem(with: nil)
                        
                        UserDefaults.standard.set(true, forKey: "isFromWatch")
                        UserDefaults.standard.set(true, forKey: "isPermissiongranted")
                        
                            let baseTabVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                            self.navigationController?.pushViewController(baseTabVC, animated: true)
                    }
                }
            }
        }

    
    
}
    
extension VideoPlay: TimeTrackingDelegate {
    fileprivate func updateTimeTrack() {
        ///api call here
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
            
            let trackInSecond = Date().timeDifference(startTime: startTrackTime, endTime: Date())
            let request = TimeTrackingRequest(type: ConstantTimeTrackType.video, musicId: ConstantAlertTitle.LuvoAlertTitle, listenMin: trackInSecond)
            print("--------\(request)")
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            timeTrackViewModel.postTimeTracking(token: token, trackingRequest: request)
        }
    }
    
    func didReceiveTrackingResponse(trackingResponse: TimeTrackingResponse?) {
        self.view.stopActivityIndicator()
        
        if(trackingResponse?.status != nil && trackingResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(trackingResponse)
            
            guard let message = trackingResponse?.message else { return }
            print("Time Tracking Upadted---\(message)")
            
        } else {
            print("Time Tracking Upadted---\(ConstantStatusAPI.failed)")
//            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func didReceiveTrackingError(statusCode: String?) {
        self.view.stopActivityIndicator()
        print("Time Tracking Error---\(String(describing: statusCode))")
//        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
        navigationController?.popViewController(animated: true)
    }
    
}

extension VideoPlay {
    func setupVideoPlayer() {
        //        guard let videoUrl = soothingVideoData?.musicFile else { return }
        //        let finalPath = Common.WebserviceAPI.baseURL + videoUrl
        
     //   guard let videoUrl = soothingVideoData?.musicLocation else { return }
        
        var videoUrl = String ()
        debugPrint(RecordedUrl)
        
        let status = UserDefaults.standard.bool(forKey: "isFromRecordedSession")
                        print(status)
                        
        if status==true
        {
            videoUrl = RecordedUrl
        }
        else
        {
              // let videoUrl = "https://luvo.s3.us-east-2.amazonaws.com/uploads/luvo-video.mp4"
        videoUrl = "https://luvo.s3.us-east-2.amazonaws.com/uploads/luvo-video.mp4"
        }
        
        guard let urlString = videoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        print("VIDEO DATA------\(urlString)")
        
        if AVAsset(url: URL(string: urlString)!).isPlayable {
            print("VIDEO DATA------Playable")
            
            let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: urlString)!)
            self.player = AVPlayer(playerItem: playerItem)
            
            //Use AVPlayerLayer for Video
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = self.viewVideoPlayer.bounds;
            self.viewVideoPlayer.layer.addSublayer(playerLayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            
            // Add playback slider
            self.playbackSlider.minimumValue = 0
            self.playbackSlider.addTarget(self, action: #selector(SoothingVideoPlayerViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
            
            let duration : CMTime = playerItem.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            self.lblOverallDuration.text = Date().stringFromTimeInterval(interval: seconds)
            
            self.playbackSlider.maximumValue = Float(seconds)
            self.playbackSlider.isContinuous = true
            
            //Track playback status
            self.timeObserver = self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) {[weak self] (CMTime) -> Void in
                guard let self = self else { return }
                if self.player!.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    self.playbackSlider.value = Float ( time );
                    
                    let newTime = seconds - time
                    self.lblOverallDuration.text = Date().stringFromTimeInterval(interval: newTime)
                }
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    print("IsBuffering")
                    self.ButtonPlay.isHidden = true
                    self.loadingView.isHidden = false
                } else {
                    //stop the activity indicator
                    print("Buffering completed")
                    self.ButtonPlay.isHidden = false
                    self.loadingView.isHidden = true
                }
            }
            
            //Autoplay video at initial
            self.player?.play()
            self.ButtonPlay.isHidden = true
            self.ButtonPlay.setImage(UIImage(named: "ic_orchadio_pause"), for: UIControl.State.normal)
        } else {
            print("VIDEO DATA------Not Playable")
        }
    }
    
    @IBAction func ButtonGoToBackSec(_ sender: Any) {
        if player == nil { return }
        let playerCurrenTime = CMTimeGetSeconds(player!.currentTime())
        var newTime = playerCurrenTime - seekDuration
        if newTime < 0 { newTime = 0 }
        player?.pause()
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player?.seek(to: selectedTime)
        player?.play()
    }
    
    @IBAction func ButtonPlay(_ sender: Any) {
        print("play Button")
        if player == nil { return }
        if player?.rate == 0 {
            player!.play()
            self.ButtonPlay.isHidden = true
            self.loadingView.isHidden = false
            ButtonPlay.setImage(UIImage(named: "ic_orchadio_pause"), for: UIControl.State.normal)
        } else {
            player!.pause()
            ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func ButtonForwardSec(_ sender: Any) {
        if player == nil { return }
        if let duration  = player!.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
            let newTime = playerCurrentTime + seekDuration
            if newTime < CMTimeGetSeconds(duration) {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player!.seek(to: selectedTime)
            }
            player?.pause()
            player?.play()
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        if player == nil { return }
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0 {
            player?.play()
        }
    }
    
    @IBAction func btnFullscreen(_ sender: Any) {
        ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.allowsPictureInPicturePlayback = false
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        playbackSlider.value = 0.0
        player?.seek(to: CMTime.zero)
        ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
//            self.autorizeHealthKit()
//
//            self.player?.replaceCurrentItem(with: nil)
//
//
//            let baseTabVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
//            self.navigationController?.pushViewController(baseTabVC, animated: true)
            
            let status = UserDefaults.standard.bool(forKey: "isFromRecordedSession")
                            print(status)
                            
            if status==true
            {
                
            }
            
            else
            {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to measure your regular activities through", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "iPhone", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                
                self.player?.replaceCurrentItem(with: nil)
                
                UserDefaults.standard.set(false, forKey: "isFromWatch")
                        let baseTabVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                        self.navigationController?.pushViewController(baseTabVC, animated: true)
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "Apple Watch", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                
                self.player?.replaceCurrentItem(with: nil)
                self.autorizeHealthKit()
                // Do any additional
            }))

            self.present(refreshAlert, animated: true, completion: nil)
         }
        }
    }
}

//extension SoothingVideoPlayerViewController: FavouritesViewModelDelegate {
//    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
//        self.view.stopActivityIndicator()
//
//        if(favouriteDataResponse?.status != nil && favouriteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
////            dump(favouriteDataResponse)
//            if boolFav == false {
//                boolFav = true
//                btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
//            } else {
//                boolFav = false
//                btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
//            }
//
//            guard let message = favouriteDataResponse?.message else { return }
//            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
//
//        } else {
//            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
//        }
//    }
//
//    func didReceiveFavouriteDataError(statusCode: String?) {
//        self.view.stopActivityIndicator()
//        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
//    }
//}
