//
//  FullAudioPlayerViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 30/10/21.
//

import UIKit
import AVFoundation

var indexpath: IndexPath?

fileprivate struct ConstantHeaderTitle {
    static let titleForBlocked          = "Meditation - Audio"
    static let titleForManifestation    = "Meditation for Manifestation- Audio"
    static let titleForHighPerformance  = "High performance - Audio"
    static let titleForGuidedMeditation  = "Guided Meditation - Audio"
}

class FullAudioPlayerViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    //AVPlayer
    var player:AVPlayer?
    var timeObserver: Any?
    fileprivate let seekDuration: Float64 = 10
    
    @IBOutlet weak var lblOverallDuration: UILabel!
    @IBOutlet weak var lblCurrentDuration: UILabel!
    @IBOutlet weak var lblAudioTitle: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    //----------------------------
    
    @IBOutlet var lblHeaderTitle: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var imgCircle: UIImageView!
    @IBOutlet var viewCompleted: UIView_Designable!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var sliderVibrate: MarkSlider!{
        didSet{
            sliderVibrate.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    @IBOutlet var btnQuestionInfo: UIButton!
    @IBOutlet var viewHiddenPopup: UIView!
    @IBOutlet var btnDoneHiddenPopup: UIBUtton_Designable!
    
    var favViewModel = FavouritesViewModel()
    var meditationAudioViewModel = MeditationAudioViewModel()
    var boolFav = false
    var arrayAudioListData = [MeditationMusics]()
   // var indexpath: IndexPath?
    var vcName: String?
    var mediaCounter = 0
    var boolCompleted = false
    fileprivate var vibrateTimer = Timer()
    fileprivate var storeVibrateValue: Double = 7.0 //default
    fileprivate var storeSliderValue: Float = 0.0   //default
    
    var fromFavourite = false
    
    let startTrackTime = Date() //Timer to keep track of time spent on this page
    var timeTrackViewModel = TimeTrackingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        //Setup navbar
        setupCustomNavBar()
        
        favViewModel.delegate = self
        meditationAudioViewModel.delegateAudioComplete5min = self
        timeTrackViewModel.delegate = self
        
        setupPopupUI()
        setupUI()
        setupSlider()
        setupPlayerControlButton()
        
        if fromFavourite {
            btnNext.isUserInteractionEnabled = false
            btnPrevious.isUserInteractionEnabled = false
        } else {
            btnNext.isUserInteractionEnabled = true
            btnPrevious.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        
        
        setupNotificationBadge()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //postCompletedListen5min()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [weak self] in
            if let indexpathRow = indexpath {
                self?.mediaCounter = indexpathRow.row
                self?.setupPlayer(indexpath: indexpathRow.row)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
        
        vibrateTimer.invalidate()
        if let player = player {
            player.pause()
            removePeriodicTimeObserver()
            //self.player = nil
        }
        ///Make indexPath = nil because when playing music and going to Sleep Track from bottom bar and coming back to Meditation from bottom bar will view this controller first and execute viewWillAppear or viewDidAppear
        ///Whatever is inside it will get executed
        ///Thus making indexPath = nil will not make the execution enter the block
       // self.indexpath = nil
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    //    btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        self.loadingView.isHidden = false
    }
    
    fileprivate func removePeriodicTimeObserver() {
        // If a time observer exists, remove it
        if let observer = timeObserver {
            self.player?.removeTimeObserver(observer)
            timeObserver = nil
        }
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
        updateTimeTrack()
//        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    //MARK: - Setup UI
    fileprivate func setupPopupUI() {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
    }
    
    fileprivate func showPopup() {
        viewHiddenPopup.isHidden = false
        viewHiddenPopup.alpha = 1.0
    }
    
    func setupUI() {
        imgCircle.layer.cornerRadius = imgCircle.frame.size.width/2
        ///Circle image for blocked chakra is 'normalCircle', but for manifestation & high performance circle image will be the thgunbnail image from audio list array
        ///Check setupPlayer Function
        if let VC = vcName {
            switch VC {
            case ConstantMeditationStaticName.blocked:
                lblHeaderTitle.text = ConstantHeaderTitle.titleForBlocked
                
                //imgBackground.image = UIImage(named: "normalBackground")
                imgCircle.image = UIImage(named:"normalCircle")
                
                lblTitle.font = UIFont(name: "Nunito-ExtraBold", size: 24.0)
                lblDesc.font = UIFont(name: "Nunito-Regular", size: 12.0)
                
                lblTitle.text = "Find a quiet place, free from any distractions."
                lblDesc.text = "Choose a comfortable position, either sitting or lying down. Keep your back straight, do not lean backward or forward. When done, close your eyes and relax to soothing music."
                
                break
            case ConstantMeditationStaticName.manifestation:
                lblHeaderTitle.text = ConstantHeaderTitle.titleForManifestation
                
                //imgBackground.image = UIImage(named: "manifestationBackground")
                imgCircle.image = UIImage(named:"manifestationCircle")
                
                lblTitle.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblDesc.font = UIFont(name: "Nunito-Bold", size: 12.0)
                
                lblTitle.text = "Manifest your greatest and most sincere desires using our unique Manifestation technique. This easy-to-use method includes tools for enhancing,"
                lblDesc.text = "1. Visualization \n2. Focus and Attention \n3. Putting you in touch with your feelings and energy \n4. Making positive, Lasting changes by taking action."
                break
            case ConstantMeditationStaticName.performance:
                lblHeaderTitle.text = ConstantHeaderTitle.titleForHighPerformance
                
                //imgBackground.image = UIImage(named: "performanceBackground")
                imgCircle.image = UIImage(named:"performanceCircle")
                
                lblTitle.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblDesc.font = UIFont(name: "Nunito-Regular", size: 12.0)
                
                lblTitle.text = ""
                lblDesc.text = "Igniting your enthusiasm through our meditation will release the champion, leader, artist and a performer within. The key ingredient is your \"why\". Let us connect you with your deepest reason for being, then prepare to enter the \"zone\", your true state of flow."
                break
            case ConstantMeditationStaticName.guided:
                lblHeaderTitle.text = ConstantHeaderTitle.titleForGuidedMeditation
                
                //imgBackground.image = UIImage(named: "performanceBackground")
                imgCircle.image = UIImage(named:"performanceCircle")
                
                lblTitle.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblDesc.font = UIFont(name: "Nunito-Regular", size: 12.0)
                
                lblTitle.text = "Find a quiet place, free from any distractions."
                lblDesc.text = "Choose a comfortable position, either sitting or lying down. Keep your back straight, do not lean backward or forward. When done, close your eyes and relax to soothing music."
                break
            default:
                break
            }
        }
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
               let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               
               print(crownList)
               print("chakra level ...--->>>",chakraLevel)
               print("coloris ...--->>>",chakraColour)

        imgBackground.image = UIImage(named: "chakra_bg\(chakraLevel)")
        viewCompleted.layer.backgroundColor = UIColor.colorSetup().cgColor
        viewCompleted.isHidden = true   //Completed will always be hidden - Client's call
        
        if let indexpathRow = indexpath {
            if let fav = arrayAudioListData[indexpathRow.row].favorites {
                if fav.count > 0 {
                    btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                } else {
                    btnFav.setImage(UIImage(named: "heartOffDark"), for: .normal)
                }
            }
        }
        
        ///Audio Slider Disable
        playbackSlider.isUserInteractionEnabled = false
        
//        //Vibrator
//        sliderVibrate.addTarget(self, action: #selector(sliderVibrateTime), for: .valueChanged)
//        sliderVibrate.tintColor = UIColor.colorSetup()
        
        btnQuestionInfo.layer.cornerRadius = btnQuestionInfo.frame.size.width / 2
        btnQuestionInfo.tintColor = UIColor.colorSetup()
        
        btnDoneHiddenPopup.backgroundColor = UIColor.colorSetup()
    }
    
    //MARK: Setup Slider-----------
    func setupSlider() {
        sliderVibrate.minimumValue = 0
        sliderVibrate.maximumValue = 7
        sliderVibrate.value = 0
        sliderVibrate.minimumTrackTintColor = UIColor.colorSetup()
        sliderVibrate.minimumMarkTintColor = UIColor.colorSetup()
        sliderVibrate.markValues = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
        sliderVibrate.addTarget(self, action: #selector(sliderVibrateTimeDidChange), for: .valueChanged)
        sliderVibrate.addTarget(self, action: #selector(sliderVibrateTimeDidEndDrag), for: .touchUpInside)
        sliderVibrate.addTarget(self, action: #selector(sliderVibrateTimeDidEndDrag), for: .touchUpOutside)
//        label1.text = "\(slider1.value)"
    }
    
    @objc func sliderVibrateTimeDidChange(slider: UISlider) {
//        let value = sliderVibrate.minimumValue + sliderVibrate.maximumValue - slider.value
//        debugPrint(roundf(value))
//        storeSliderValue = roundf(slider.value)
//        if player?.rate != 0 {
//            if value == 0 {
//                startVibrateTimer(timeInterval: 0.5)
//                storeVibrateValue = 0.5
//            } else if value == 7 {
//                vibrateTimer.invalidate()
//            } else {
//                startVibrateTimer(timeInterval: Double(value))
//                storeVibrateValue = Double(value)
//            }
//        }
        //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
        storeSliderValue = roundf(slider.value)
        if self.player?.rate != 0 {
            switch roundf(slider.value) {
            case 0:
                vibrateTimer.invalidate()
                break
                
            case 1:
                startVibrateTimer(timeInterval: 7.0)
                storeVibrateValue = 7.0
                break
                
            case 2:
                startVibrateTimer(timeInterval: 6.0)
                storeVibrateValue = 6.0
                break
                
            case 3:
                startVibrateTimer(timeInterval: 5.0)
                storeVibrateValue = 5.0
                break
                
            case 4:
                startVibrateTimer(timeInterval: 4.0)
                storeVibrateValue = 4.0
                break
                
            case 5:
                startVibrateTimer(timeInterval: 3.0)
                storeVibrateValue = 3.0
                break
                
            case 6:
                startVibrateTimer(timeInterval: 2.0)
                storeVibrateValue = 2.0
                break
                
            case 7:
                startVibrateTimer(timeInterval: 1.0)
                storeVibrateValue = 1.0
                break
                
            default:
                break
            }
//            if value == 0 {
//                startVibrateTimer(timeInterval: 0.5)
//                storeVibrateValue = 0.5
//            } else if value == 7 {
//                vibrateTimer.invalidate()
//            } else {
//                startVibrateTimer(timeInterval: Double(value))
//                storeVibrateValue = Double(value)
//            }
        }
//        label1.text = "\(slider1.value)"
    }
    
    @objc func sliderVibrateTimeDidEndDrag() {
        print("slider1DidEndDrag: \(sliderVibrate.value)")
    }
    
    func startVibrateTimer(timeInterval: Double) {
        vibrateTimer.invalidate()   //cancel previous timer  ABcdee3158
        vibrateTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(vibrateOnTime), userInfo: nil, repeats: true)
    }
    
    @objc func vibrateOnTime() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    //MARK: Setup Player Controls---------------------
    func setupPlayerControlButton() {
        lblCurrentDuration.textColor = UIColor.colorSetup()
        lblOverallDuration.textColor = UIColor.colorSetup()
        btnPrevious.tintColor = UIColor.colorSetup()
        btnPlay.tintColor = UIColor.colorSetup()
        btnNext.tintColor = UIColor.colorSetup()
        playbackSlider.tintColor = UIColor.colorSetup()
    }
    
    //MARK: - Button Func
    @IBAction func btnQuestionInfo(_ sender: Any) {
        showPopup()
    }
    
    @IBAction func btnDoneHiddenPopup(_ sender: Any) {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
    }
    
    @IBAction func btnFav(_ sender: Any) {
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
            if boolFav == false {
                favViewModel.addToFavourite(favRequest: FavouritesRequest(musicId: arrayAudioListData[mediaCounter].musicId, musicType: arrayAudioListData[mediaCounter].musicType), token: token)
            } else {
                favViewModel.deleteFromFavourite(favRequest: FavouritesRequest(musicId: arrayAudioListData[mediaCounter].musicId, musicType: arrayAudioListData[mediaCounter].musicType), token: token)
            }
        }
    }
    
    @IBAction func btnDone(_ sender: Any) {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
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

extension FullAudioPlayerViewController {
    func setupPlayer(indexpath: Int) {
        //Audio Title---
        lblAudioTitle.text = arrayAudioListData[indexpath].musicName
        //Thumbnail Image---
        if vcName != ConstantMeditationStaticName.blocked {
            if let imgAlbum = arrayAudioListData[indexpath].location {
                imgCircle.sd_setImage(with: URL(string: imgAlbum), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgAlbum = arrayAudioListData[indexpath].musicImg {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgAlbum
//                imgCircle.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
        }
        
        //------------------------
        guard let url = arrayAudioListData[indexpath].musicLocation else { return }
//        let finalPath = Common.WebserviceAPI.baseURL + url
        
//        let videoURL = URL.init(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
        let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: url)!)
        self.player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Add playback slider
        playbackSlider.minimumValue = 0
        playbackSlider.addTarget(self, action: #selector(FullAudioPlayerViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        lblOverallDuration.text = Date().stringFromTimeInterval(interval: seconds)
        
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        
        //Track playback status
        self.timeObserver = self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) {[weak self] (CMTime) -> Void in
            guard let self = self else { return }
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
                self.playbackSlider.value = Float ( time )
                
                self.lblCurrentDuration.text = Date().stringFromTimeInterval(interval: time)
                
                let newTime = seconds - time
                self.lblOverallDuration.text = Date().stringFromTimeInterval(interval: newTime)
                
                ///Listen to audio for 5 min to unlock next audio is applicable for blocked chakra only
                if let VC = self.vcName {
                    if VC == ConstantMeditationStaticName.blocked {
                        //Set bool for limiting api call else it will call continuously
                        if self.boolCompleted == false {
                            //Completed listening to the audio for 5 min (5 x 60sec = 300sec)
                            //debugPrint(Int(time))
                            if time > 1 && time < 2 {
                                self.boolCompleted = true
                                self.postCompletedListen5min()
                            }
                        }
                    }
                }
            }
            
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
//                print("IsBuffering")
                self.btnPlay.isHidden = true
                self.loadingView.isHidden = false
            } else {
                //stop the activity indicator
//                print("Buffering completed")
                self.btnPlay.isHidden = false
                self.loadingView.isHidden = true
            }
        }
        
        //Autoplay at initial
        self.player?.play()
        self.btnPlay.isHidden = true
        btnPlay.setImage(UIImage(named: "ic_orchadio_pause"), for: UIControl.State.normal)
        
        //Vibrator
        sliderVibrate.value = storeSliderValue
//        startVibrateTimer(timeInterval: storeVibrateValue)
    }
    
    @IBAction func btnPrevious(_ sender: Any) {
        boolCompleted = false
        
        if self.player == nil { return }
        
        if mediaCounter > 0 && mediaCounter < arrayAudioListData.count { //if mediaCounter > 0 && mediaCounter <= arrTemp.count - 1 {
           if let vcname = vcName {
                if vcname == ConstantMeditationStaticName.blocked { //For blocked chakra
                    removePeriodicTimeObserver()
                    mediaCounter -= 1
                    setupPlayer(indexpath: mediaCounter)
                    
                } else {    //For manifestation & high performance
                    ///Select the previous index by making mediaCounter -=1 and check unlock_points & open == 0
                    ///If yes then rest the mediaCounter +=1 and music will not go to the previous location
                    ///Else it will play the previous music
                    mediaCounter -= 1
                    if arrayAudioListData[mediaCounter].unlock_points! > 0 && arrayAudioListData[mediaCounter].open == 0 { //close
                        ///The music is locked
                        mediaCounter += 1   //Reset here
                    } else {
                        removePeriodicTimeObserver()
//                        mediaCounter -= 1
                        setupPlayer(indexpath: mediaCounter)
                    }
                }
            }
        }
        
        
//        ///Check if next object at index seen has data and date greater than previous date then setup player else mediacounter will be reset
//        if mediaCounter > 0 && mediaCounter < arrayAudioListData.count { //if mediaCounter > 0 && mediaCounter <= arrTemp.count - 1 {
////            removePeriodicTimeObserver()
////            mediaCounter -= 1
//
//            if let vcname = vcName {
//                if vcname == ConstantMeditationStaticName.blocked { //For blocked chakra
//                    if let seen = arrayAudioListData[mediaCounter].seen {
//                        if seen.count > 0 {
//                            if let seendate = seen[0].listen_date {
//                                let DC = Date().dateCompare(date: seendate) //dateCompare(date: seendate)
//                                if DC == true {
//                                    removePeriodicTimeObserver()
//                                    mediaCounter -= 1
//                                    setupPlayer(indexpath: mediaCounter)
//                                }
//                            } else {
////                                mediaCounter += 1   //Reset here
//                            }
//                        } else {
////                            mediaCounter += 1   //Reset here
//                        }
//                    }
//                } else {    //For manifestation & high performance
//                    if arrayAudioListData[mediaCounter].unlock_points! > 0 && arrayAudioListData[mediaCounter].open == 0 { //close
//                        ///The music is locked
////                        mediaCounter += 1   //Reset here
//                    } else {
//                        removePeriodicTimeObserver()
//                        mediaCounter -= 1
//                        setupPlayer(indexpath: mediaCounter)
//                    }
//                }
//            }
//        }
    }
    
    @IBAction func ButtonPlay(_ sender: Any) {
        print("play Button")
        if self.player == nil {
           
            return
            
            
        }
        if self.player?.rate == 0 {
            self.player!.play()
            self.btnPlay.isHidden = true
            self.loadingView.isHidden = false
            btnPlay.setImage(UIImage(named: "ic_orchadio_pause"), for: UIControl.State.normal)
            
            sliderVibrate.value = storeSliderValue
            startVibrateTimer(timeInterval: storeVibrateValue)
        } else {
            self.player!.pause()
            btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
            
            vibrateTimer.invalidate()
        }
    }
    
    @IBAction func btnNext(_ sender: Any) {
        boolCompleted = false
        
        //Check if next object at index seen has data and date greater than previous date then setup player else mediacounter will be reset
        if self.player == nil { return }
        
        if mediaCounter >= 0 && mediaCounter <= arrayAudioListData.count - 1 {   //if mediaCounter >= 0 && mediaCounter < arrayAudioListData.count - 1
//            removePeriodicTimeObserver()
//            mediaCounter += 1
            
            if let vcname = vcName {
                if vcname == ConstantMeditationStaticName.blocked { //For blocked chakra
                    if let seen = arrayAudioListData[mediaCounter].seen {
                        if seen.count > 0 {
                            if let seendate = seen[0].listen_date {
                                let DC = Date().dateCompare(date: seendate) //dateCompare(date: seendate)
                                if DC == true {
                                    removePeriodicTimeObserver()
                                    mediaCounter += 1
                                    setupPlayer(indexpath: mediaCounter)
                                }
                            } else {
//                                mediaCounter -= 1   //Reset here
                            }
                        } else {
//                            mediaCounter -= 1   //Reset here
                        }
                    }
                } else {    //For manifestation & high performance
                    ///Select the previous index by making mediaCounter +=1 and check unlock_points & open == 0
                    ///If yes then rest the mediaCounter -=1 and music will not go to the previous location
                    ///Else it will play the previous music
                    mediaCounter += 1
                    if arrayAudioListData[mediaCounter].unlock_points! > 0 && arrayAudioListData[mediaCounter].open == 0 { //close
                        ///The music is locked
                        mediaCounter -= 1   //Reset here
                    } else {
                        removePeriodicTimeObserver()
//                        mediaCounter += 1
                        setupPlayer(indexpath: mediaCounter)
                    }
                }
            }
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        if self.player == nil { return }
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        self.player!.seek(to: targetTime)
        
        if self.player!.rate == 0 {
            self.player?.play()
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        playbackSlider.value = 0.0
        self.player?.seek(to: CMTime.zero)
        btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        
        vibrateTimer.invalidate()
    }
    
    func postCompletedListen5min() {
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
            
            let request = AudioListen5minRequest(musicId: arrayAudioListData[mediaCounter].musicId, listenMin: "5")
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationAudioViewModel.postAudioComplete5min(audioCompleteRequest: request, token: token)
        }
    }
}

extension FullAudioPlayerViewController: MeditationAudioComplete5minViewModelDelegate {
    func didReceiveAudioComplete5minDataResponse(audioComplete5minDataResponse: AudioListen5minResponse?) {
        self.view.stopActivityIndicator()
        
        if(audioComplete5minDataResponse?.status != nil && audioComplete5minDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(audioComplete5minDataResponse)
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.UnlockMusic)
        } else {
//            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
            debugPrint(ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveAudioComplete5minDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension FullAudioPlayerViewController: FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
        self.view.stopActivityIndicator()
        
        if(favouriteDataResponse?.status != nil && favouriteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(favouriteDataResponse)
            
            if boolFav == false {
                boolFav = true
                btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
            } else {
                boolFav = false
                btnFav.setImage(UIImage(named: "heartOffDark"), for: .normal)
            }
            
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

extension FullAudioPlayerViewController: TimeTrackingDelegate {
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
            let request = TimeTrackingRequest(type: ConstantTimeTrackType.audio, musicId: ConstantAlertTitle.LuvoAlertTitle, listenMin: trackInSecond)
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
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func didReceiveTrackingError(statusCode: String?) {
        self.view.stopActivityIndicator()
        print("Time Tracking Error---\(String(describing: statusCode))")
//        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
        navigationController?.popViewController(animated: true)
    }
    
    
}
