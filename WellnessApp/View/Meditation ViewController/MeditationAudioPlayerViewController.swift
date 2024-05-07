
//
//  MeditationAudioPlayerViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 23/10/21.
//
//Note: - Check if completed array is blank or not. If blank then select that array index and play, add to fav also. If all item have completed array count > 0 then play the first index and also for add to fav. (didReceiveMeditationAudioDataResponse)

import UIKit
import AVFoundation

fileprivate struct StoreMusicData {
    let musicId: String?
    let musicType: String?
}

class MeditationAudioPlayerViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var viewHiddenPopup: UIView!    //Excluded from this page. Client's call. Implemented on Full Audio Player page. Don't remove.
    
    //----------------------
    var highlightTimer = Timer()
    var playbackTimer = Timer()
//    var vibrateTimer = Timer()    //Excluded from this page. Client's call. Implemented on Full Audio Player page. Don't remove.
    var counter = 0
    var storeCounter = 0
    var stepCounter = 0
    var arrRelax = [4,7,8]
    var relaxCounter = 0
    var valueBool: Bool?
    
    
    
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var lblExerciseTitle: UILabel!
    @IBOutlet var lblInhale: UILabel!
    @IBOutlet var lblFourSec1: UILabel!
    @IBOutlet var lblFourSec2: UILabel!
    @IBOutlet var lblFourSec3: UILabel!
    @IBOutlet var lblFourSec4: UILabel!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var viewCircleProgress: UIView_Designable!
    @IBOutlet var imgProgressCircle: UIImageView!
    @IBOutlet var lblAudioName: UILabel!
    @IBOutlet var sliderVibrate: UISlider!{ //Excluded from this page. Client's call. Implemented on Full Audio Player page. Don't remove. Unchecked install from storyboard
        didSet{
            sliderVibrate.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    @IBOutlet var btnQuestionInfo: UIButton!    //Excluded from this page. Client's call. Implemented on Full Audio Player page. Don't remove. Unchecked install from storyboard
    
    
  //  let urlStringNew:String
    
    
    //-------Audio Player
    var player:AVPlayer?
    var timeObserver: Any?
    fileprivate let seekDuration: Float64 = 10
    
    @IBOutlet weak var lblOverallDuration: UILabel!
    @IBOutlet weak var lblcurrentText: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var ButtonPlay: UIButton!
    
    var boolFav = false
    var arrayInhale = [String]()
    
    var meditationMusicVewModel = MeditationAudioViewModel()
    var meditationAudioData: MeditationAudioResponse?
    var meditationAudioRequest: MeditationAudioRequest? //Data coming from meditation first page
    var favViewModel = FavouritesViewModel()
    fileprivate var storeMusicData: StoreMusicData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        favViewModel.delegate = self
        meditationMusicVewModel.delegateAudioComplete = self
        meditationMusicVewModel.delegate = self
        
//        setupPopupUI()
        setupUI()
        
        dump(meditationAudioRequest)
       // getMeditationMusicData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
      //  setupUI()
        arrayInhale.removeAll()
        getMeditationMusicData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
        
        highlightTimer.invalidate()
        playbackTimer.invalidate()
//        vibrateTimer.invalidate()
        if let player = player {
            player.pause()
            removePeriodicTimeObserver()
            self.player = nil
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        playbackSlider.value = 0.0
        player?.seek(to: CMTime.zero)
        ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        
        if let relaxID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) as? String {
            if relaxID == ConstantBreathExerciseID.relaxBreath {
                relaxCounter = 0
                setupRelaxStepLabel()
            } else {
                setupStepLabel()
            }
        } else {
            setupStepLabel()
        }
    }
    
    fileprivate func removePeriodicTimeObserver() {
        // If a time observer exists, remove it
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
//    //MARK: - Setup UI
//    func setupPopupUI() {
//        viewHiddenPopup.isHidden = true
//        viewHiddenPopup.alpha = 0.0
//    }
//
//    func showPopup() {
//        viewHiddenPopup.isHidden = false
//        viewHiddenPopup.alpha = 1.0
//    }
    
    func setupUI() {
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        print("coloris ...--->>>",chakraColour)
        if chakraColour==0 {
            imgBackground.image  = UIImage.init(named: "music_bg\(chakraLevel)")
        } else {
            imgBackground.image  = UIImage.init(named: "music_bg\(chakraColour)")
        }
        
       
        
        loadingView.isHidden = true
        
        if let exerciseName = meditationAudioRequest?.exerciseName {
            lblExerciseTitle.text = exerciseName
        }
        
        lblAudioName.textColor = UIColor.colorSetup()
                
//        sliderVibrate.addTarget(self, action: #selector(sliderVibrateTime), for: .valueChanged)
//        sliderVibrate.tintColor = UIColor.colorSetup()
//
//        btnQuestionInfo.layer.cornerRadius = btnQuestionInfo.frame.size.width / 2
//        btnQuestionInfo.tintColor = UIColor.colorSetup()
        
        imgProgressCircle.tintColor = UIColor.colorSetup()
        ButtonPlay.tintColor = UIColor.colorSetup()
        
        //hide if breath with music selected
        if let musicBreathID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) as? String {
            if musicBreathID == ConstantBreathExerciseID.musicBreath {
                lblInhale.isHidden = true
                lblFourSec1.isHidden = true
                lblFourSec2.isHidden = true
                lblFourSec3.isHidden = true
                lblFourSec4.isHidden = true
                imgProgressCircle.isHidden = true
                //viewCircleProgress.isHidden = true
            }
        }
    }
    
    func getMeditationMusicData() {
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
            
            let request = MeditationAPIRequest(meditationId: meditationAudioRequest?.meditationId, chakraId: meditationAudioRequest?.chakraId, exerciseId: meditationAudioRequest?.exerciseId)
            
            
            print(request)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationMusicVewModel.getMeditationAudioList(meditationAudioRequest: request, token: token)
        }
    }
    
    func setupStepLabel() {
        //default Circle progress
        let arrayCount = arrayInhale.count
        switch arrayCount {
        case 1:
            lblFourSec1.text = "Step 1: \(arrayInhale[0]) for \(counter) seconds"
            lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
            
            lblFourSec2.isHidden = true
            lblFourSec3.isHidden = true
            lblFourSec4.isHidden = true
            break
        case 2:
            lblFourSec1.text = "Step 1: \(arrayInhale[0]) for \(counter) seconds"
            lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
            
            lblFourSec2.text = "Step 2: \(arrayInhale[1]) for \(counter) seconds"
            lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
            
            lblFourSec3.isHidden = true
            lblFourSec4.isHidden = true
            break
        case 3:
            lblFourSec1.text = "Step 1: \(arrayInhale[0]) for \(counter) seconds"
            lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
            
            lblFourSec2.text = "Step 2: \(arrayInhale[1]) for \(counter) seconds"
            lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
            
            lblFourSec3.text = "Step 3: \(arrayInhale[2]) for \(counter) seconds"
            lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
            
            lblFourSec4.isHidden = true
            break
        case 4:
            lblFourSec1.text = "Step 1: \(arrayInhale[0]) for \(counter) seconds"
            lblFourSec2.text = "Step 2: \(arrayInhale[1]) for \(counter) seconds"
            lblFourSec3.text = "Step 3: \(arrayInhale[2]) for \(counter) seconds"
            lblFourSec4.text = "Step 4: \(arrayInhale[3]) for \(counter) seconds"
            
            lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
            lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
            lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
            lblFourSec4.font = UIFont(name: "Nunito-Regular", size: 12.0)
            
            break
        default:
            break
        }
        

        let angle: CGFloat = 0
        UIView.animate(withDuration: TimeInterval(1)) {
            self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
        }

        if arrayInhale.count > 0 {
            lblInhale.text = arrayInhale[0]
        }

//        counter = 4
        stepCounter = 1
    }
    
    //MARK: - Button Func
//    @IBAction func btnQuestionInfo(_ sender: Any) {
//        showPopup()
//    }
//
//    @IBAction func btnDone(_ sender: Any) {
//        viewHiddenPopup.isHidden = true
//        viewHiddenPopup.alpha = 0.0
//    }
    
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
            if let arrMusic = meditationAudioData?.musics {
                if arrMusic.count > 0 {
                    //check if add to fav or delete from fav
                    if boolFav == false {
                        favViewModel.addToFavourite(favRequest: FavouritesRequest(musicId: storeMusicData?.musicId, musicType: storeMusicData?.musicType), token: token)
                    } else {
                        favViewModel.deleteFromFavourite(favRequest: FavouritesRequest(musicId: storeMusicData?.musicId, musicType: storeMusicData?.musicType), token: token)
                    }
                } else {
                    self.view.stopActivityIndicator()
                    debugPrint("No music to add to favourite")
                }
            }
        }
    }
    
//    @objc func sliderVibrateTime(slider: UISlider) {
//        let value = sliderVibrate.minimumValue + sliderVibrate.maximumValue - slider.value
//        debugPrint(roundf(value))
//        if player?.rate != 0 {
//            startVibrateTimer(timeInterval: Double(value))
//        }
//    }
    
    //MARK: - Timer
    func startHighlightTimer(timerCount: Int) {
        highlightTimer.invalidate() //cancels it if already running
        
        print(timerCount)
        
        if timerCount > 0 {
            highlightTimer = Timer.scheduledTimer(timeInterval: Double(timerCount), target: self, selector: #selector(updateTextHighlight), userInfo: nil, repeats: true)
            
            let angle: CGFloat = (Double.pi * 2) / CGFloat(arrayInhale.count)
            UIView.animate(withDuration: TimeInterval(timerCount)) {
                self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
    }
    
    @objc func updateTextHighlight() {
        if arrayInhale.count == 1 { ///Array count = 1
            //Don't know what to do
        } else if arrayInhale.count == 2 {  ///Array count = 2
            if stepCounter == 1 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Bold", size: 12.0)

                lblInhale.text = arrayInhale[1]

                let angle: CGFloat = ((Double.pi * 2) / 2) * 2
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }

            } else {
                stepCounter -= 1
                lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[0]

                let angle: CGFloat = ((Double.pi * 2) / 2) * 1
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }
            }

        } else if arrayInhale.count == 3 {  ///Array count = 3
            if stepCounter == 1 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[1]
                
                let angle: CGFloat = ((Double.pi * 2) / 3) * 2
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }

            } else if stepCounter == 2 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Bold", size: 12.0)

                lblInhale.text = arrayInhale[2]

                let angle: CGFloat = ((Double.pi * 2) / 3) * 3
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }
            }else {
                stepCounter -= 2
                lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[0]

                let angle: CGFloat = ((Double.pi * 2) / 3) * 1
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }
            }

        } else if arrayInhale.count == 4 {  ///Array count = 4
            if stepCounter == 1 {
                stepCounter += 1
                
                print(stepCounter)

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[1]

                let angle: CGFloat = ((Double.pi * 2) / 4) * 2
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }

            } else if stepCounter == 2 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[2]

                let angle: CGFloat = ((Double.pi * 2) / 4) * 3
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }

            } else if stepCounter == 3 {
                stepCounter += 1
                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Bold", size: 12.0)

                lblInhale.text = arrayInhale[3]

                let angle: CGFloat = ((Double.pi * 2) / 4) * 4
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }

            } else {
                stepCounter -= 3
                lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[0]

                let angle: CGFloat = ((Double.pi * 2) / 4) * 1
                UIView.animate(withDuration: TimeInterval(counter)) {
                    self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
                }
            }
        }
        
        storeCounter = stepCounter
        print("STORE COUNTER---->\(storeCounter)")
    }
    
    func startPlaybackTimer(timeInterval: Double) {
        playbackTimer.invalidate() //cancels it if already running
        playbackTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(stopPlaybackTimer), userInfo: nil, repeats: true)
    }
    
    @objc func stopPlaybackTimer() {
        highlightTimer.invalidate()
        playbackTimer.invalidate()
//        vibrateTimer.invalidate()
        player?.pause()
        playbackSlider.value = 0.0
        player?.seek(to: CMTime.zero)
        ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        
        //Reset the player(Working as stop button)----***
        if let relaxID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) as? String {
            if relaxID == ConstantBreathExerciseID.relaxBreath {
                relaxCounter = 0
                setupRelaxStepLabel()
            } else {
                setupStepLabel()
            }
        } else {
            setupStepLabel()
        }
        
        //Post completed API
        print("------------>COMPLETED")
        postAudioListenComplete()   //if full audio playback is completed then call the API
    }
    
//    func startVibrateTimer(timeInterval: Double) {
//        vibrateTimer.invalidate()   //cancel previous timer
//        vibrateTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(vibrateOnTime), userInfo: nil, repeats: true)
//    }
    
    @objc func vibrateOnTime() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    //MARK: - API call for audio listen complete
    func postAudioListenComplete() {
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
            
//           let request = AudioListenCompletedRequest(musicId: meditationAudioData?.musics?[0].musicId, listenMin: meditationAudioRequest?.time)
            let request = AudioListenCompletedRequest(musicId: storeMusicData?.musicId, listenMin: meditationAudioRequest?.time)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationMusicVewModel.postAudioComplete(audioCompleteRequest: request, token: token)
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

extension MeditationAudioPlayerViewController: MeditationAudioViewModelDelegate {
    func didReceiveMeditationAudioDataResponse(meditationAudioDataResponse: MeditationAudioResponse?) {
        self.view.stopActivityIndicator()
        
        if(meditationAudioDataResponse?.status != nil && meditationAudioDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(meditationAudioDataResponse)
            
            meditationAudioData = meditationAudioDataResponse
            //Setup UI
            
            if let arrMusic = meditationAudioData?.musics {
                if arrMusic.count == 0 {
                    if let message = meditationAudioData?.message {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
                    }
                } else {
                    //play the music from the array which has 'completed' array blank
                    var boolEmptyCheck = false
                    for item in arrMusic {
                        if (item.completed!.isEmpty) {
                            if let audioUrl = item.musicLocation {
//                                let finalAudioPath = Common.WebserviceAPI.baseURL + audioUrl
                                //Setup music player
                                setupMusicPlayer(audioURL: audioUrl)
                                
                                if let fav = item.favorites {
                                    if fav.isEmpty {
                                        boolFav = false
                                        btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                                    } else {
                                        boolFav = true
                                        btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                                    }
                                }
                                
                                lblAudioName.text = item.musicName
                                
                                //Second difference for label show
                                if let pointDuration = item.pointDuration {
                                    counter = pointDuration
                                }
                                
                                //setup Steps label array
                                if let step1 = item.step1 {
                                    if step1 != "" && step1.count > 0 {
                                        arrayInhale.append(step1)
                                    }
                                }
                                if let step2 = item.step2 {
                                    if step2 != "" && step2.count > 0 {
                                        arrayInhale.append(step2)
                                    }
                                }
                                if let step3 = item.step3 {
                                    if step3 != "" && step3.count > 0 {
                                        arrayInhale.append(step3)
                                    }
                                }
                                if let step4 = item.step4 {
                                    if step4 != "" && step4.count > 0 {
                                        arrayInhale.append(step4)
                                    }
                                }
                                print("ARRAY STEPS LABEL(boolEmptyCheck = True)--->\(arrayInhale)")
                            }
                            boolEmptyCheck = true
                            storeMusicData = StoreMusicData(musicId: item.musicId, musicType: item.musicType)
                            break
                        }
                    }
                    
                    if boolEmptyCheck == false {
                        storeMusicData = StoreMusicData(musicId: arrMusic[0].musicId, musicType: arrMusic[0].musicType)
                        if let audioUrl = arrMusic[0].musicLocation {
//                            let finalAudioPath = Common.WebserviceAPI.baseURL + audioUrl
                            //Setup music player
                            setupMusicPlayer(audioURL: audioUrl)
                        }
                        
                        if let fav = arrMusic[0].favorites {
                            if fav.isEmpty {
                                boolFav = false
                                btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                            } else {
                                boolFav = true
                                btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                            }
                        }
                        lblAudioName.text = arrMusic[0].musicName
                        
                        //Second difference for label show
                        if let pointDuration = arrMusic[0].pointDuration {
                            counter = pointDuration
                        }
                        
                        //setup Steps label array
                        if let step1 = arrMusic[0].step1 {
                            if step1 != "" && step1.count > 0 {
                                arrayInhale.append(step1)
                            }
                        }
                        if let step2 = arrMusic[0].step2 {
                            if step2 != "" && step2.count > 0 {
                                arrayInhale.append(step2)
                            }
                        }
                        if let step3 = arrMusic[0].step3 {
                            if step3 != "" && step3.count > 0 {
                                arrayInhale.append(step3)
                            }
                        }
                        if let step4 = arrMusic[0].step4 {
                            if step4 != "" && step4.count > 0 {
                                arrayInhale.append(step4)
                            }
                        }
                        print("ARRAY STEPS LABEL(boolEmptyCheck = False)--->\(arrayInhale)")
                    }
                }
                
                //Setup label UI
                if let relaxID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) as? String {
                    if relaxID == ConstantBreathExerciseID.relaxBreath {
                        relaxCounter = 0
                        setupRelaxStepLabel()
                    } else {
                        setupStepLabel()
                    }
                } else {
                    setupStepLabel()
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

extension MeditationAudioPlayerViewController: FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
        self.view.stopActivityIndicator()
        
        if(favouriteDataResponse?.status != nil && favouriteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(favouriteDataResponse)
            
            if boolFav == false {
                boolFav = true
                btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
            } else {
                boolFav = false
                btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
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

extension MeditationAudioPlayerViewController {
    func setupMusicPlayer(audioURL: String) {
        let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: audioURL)!)
        player = AVPlayer(playerItem: playerItem)
        
        
        guard let url = audioURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = URL(string: url)!
        
        print("Audio DATA------\(url)")
        
        if AVURLAsset.init(url: urlString).isPlayable {
            print("Audio DATA------Playable")
        }
            else {
                print("Audio not playable------------------------>")
            }
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Add playback slider
        playbackSlider.minimumValue = 0
                
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
//        lblOverallDuration.text = Dtae().stringFromTimeInterval(interval: seconds)  //Showing total duration for the audio
        if let time = meditationAudioRequest?.time {
            lblOverallDuration.text = "00:\(time):00"
            
//        playbackSlider.maximumValue = Float(seconds)
            let intToMinute = Int(time)! * 60
            playbackSlider.maximumValue = Float(intToMinute)
        }
        
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor.colorSetup()
        
        let duration1 : CMTime = playerItem.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        lblcurrentText.text = Date().stringFromTimeInterval(interval: seconds1)
        
        
        self.timeObserver = player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) {[weak self] (CMTime) -> Void in
            guard let self = self else {
                return
                
            }
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider.value = Float ( time );
                
                self.lblcurrentText.text = Date().stringFromTimeInterval(interval: time)
            }
            
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            
            let status = self.player?.currentItem?.isPlaybackBufferFull
           
        
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
                self.ButtonPlay.isHidden = true
                self.loadingView.isHidden = false
            } else {
                //stop the activity indicator
                print("Buffering completed")
                self.ButtonPlay.isHidden = false
                self.loadingView.isHidden = true
                
              //  self.valueBool=true
                
                
            }
        }
//
//        if valueBool==true
//        {
 //       self.ButtonPlay(true)
//            return
//        }
//
        //Autoplay at initial
//        player?.play()
//        self.ButtonPlay.isHidden = false
//        self.loadingView.isHidden = true
//        self.ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
    }
    
    @IBAction func ButtonPlay(_ sender: Any) {
        
//        guard let url = audioURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//        let urlString = URL(string: url)!
//        print("Audio DATA------\(url)")
//
//        if AVURLAsset.init(url: urlString).isPlayable {
//            print("Audio DATA------Playable")
//        }
//            else {
//                print("Audio not playable------------------------>")
//            }
////
        print("play Button")
        if player == nil {
           
           return
            
            
        }
        if player?.rate == 0 {
//            sliderVibrate.value = 1
//            startVibrateTimer(timeInterval: 5.0)
            
            player!.play()
//            self.ButtonPlay.isHidden = false
//            self.ButtonPlay.isHidden = true
//            self.loadingView.isHidden = false
            ButtonPlay.setImage(UIImage(named: "ic_orchadio_stop"), for: UIControl.State.normal)
            
            //Check wether the plaayer is playing then execute the block
//            if player?.timeControlStatus == .playing {
//                if let time = meditationAudioRequest?.time {
                    
//                    print("hello")
//                    guard var timeDouble = Double(time) else { return }
//                    timeDouble = timeDouble * 60
//                    startPlaybackTimer(timeInterval: timeDouble)    //Play audio for selected time selected on previous page
//                }
//
//                if let relaxID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) as? String {
//                    if relaxID == ConstantBreathExerciseID.relaxBreath {
//                        startRelaxHighlightTimer(timerCount: arrRelax[relaxCounter])
//                    } else {
//                        startHighlightTimer(timerCount: counter)
//                    }
//                } else {
//                    startHighlightTimer(timerCount: counter)
//                }
//            }
        } else {
//            stepCounter = storeCounter  //Resume the counter value. Used for Play & Resume funtionality
            
            highlightTimer.invalidate()
            playbackTimer.invalidate()
//            vibrateTimer.invalidate()
            player!.pause()
            ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
            
            //Reset the player(Working as stop button)----***
            if let relaxID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) as? String {
                if relaxID == ConstantBreathExerciseID.relaxBreath {
                    relaxCounter = 0
                    setupRelaxStepLabel()
                } else {
                    setupStepLabel()
                }
            } else {
                setupStepLabel()
            }
            
            playbackSlider.value = 0.0
            player?.seek(to: CMTime.zero)
        }
        
        //Check wether the player is playing then execute the block
        if player?.rate != 0 {
            if let time = meditationAudioRequest?.time {
                guard var timeDouble = Double(time) else { return }
               // timeDouble = timeDouble * 20
                timeDouble = timeDouble * 60
                startPlaybackTimer(timeInterval: timeDouble)    //Play audio for selected time selected on previous page
            }

            if let relaxID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) as? String {
                if relaxID == ConstantBreathExerciseID.relaxBreath {
                    startRelaxHighlightTimer(timerCount: arrRelax[relaxCounter])
                } else {
                    print(counter)
                    startHighlightTimer(timerCount: counter)
                }
            } else {
                print(counter)
                startHighlightTimer(timerCount: counter)
            }
        }
    }
    
    //Finished playing is not required as we are not letting the full audio to complete
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        highlightTimer.invalidate()
        playbackTimer.invalidate()
//        vibrateTimer.invalidate()
        playbackSlider.value = 0.0
        player?.seek(to: CMTime.zero)
        ButtonPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        
        //Reset the player(Working as stop button)----***
        if let relaxID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) as? String {
            if relaxID == ConstantBreathExerciseID.relaxBreath {
                relaxCounter = 0
                setupRelaxStepLabel()
            } else {
                setupStepLabel()
            }
        } else {
            setupStepLabel()
        }
    }
}

extension MeditationAudioPlayerViewController: MeditationAudioCompleteViewModelDelegate {
    func didReceiveAudioCompleteDataResponse(audioCompleteDataResponse: AudioListenCompletedResponse?) {
        self.view.stopActivityIndicator()
        
        if(audioCompleteDataResponse?.status != nil && audioCompleteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(audioCompleteDataResponse)
            
            guard let message = audioCompleteDataResponse?.message else { return }
            debugPrint(message)
//            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
            openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle, message: "Your audio playback is completed", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [
                { _ in
//                    let audioListVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationAudioListViewController") as! MeditationAudioListViewController
//                    audioListVC.meditationAudioRequest = self.meditationAudioRequest
//                    self.navigationController?.pushViewController(audioListVC, animated: true)
                    
                  
                    let status = UserDefaults.standard.bool(forKey: "isFromMeditation")
                    print(status)
                    
                     if status == false
                    {
                    
                    let introVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(introVC, animated: false)
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: "isFromMeditation")
                                            let audioListVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationAudioListViewController") as! MeditationAudioListViewController
                                            audioListVC.meditationAudioRequest = self.meditationAudioRequest
                                            self.navigationController?.pushViewController(audioListVC, animated: true)
                    }
                }
            ])
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveAudioCompleteDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension MeditationAudioPlayerViewController {
    func setupRelaxStepLabel() {
        //default Circle progress
        let arrayCount = arrayInhale.count
        switch arrayCount {
        case 1:
            lblFourSec1.text = "Step 1: \(arrayInhale[0]) for \(arrRelax[relaxCounter]) seconds"
            lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
            
            lblFourSec2.isHidden = true
            lblFourSec3.isHidden = true
            lblFourSec4.isHidden = true
            break
        case 2:
            lblFourSec1.text = "Step 1: \(arrayInhale[0]) for \(arrRelax[relaxCounter]) seconds"
            lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
            
            lblFourSec2.text = "Step 2: \(arrayInhale[1]) for \(arrRelax[relaxCounter + 1]) seconds"
            lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
            
            lblFourSec3.isHidden = true
            lblFourSec4.isHidden = true
            break
        case 3:
            lblFourSec1.text = "Step 1: \(arrayInhale[0]) for \(arrRelax[relaxCounter]) seconds"
            lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
            
            lblFourSec2.text = "Step 2: \(arrayInhale[1]) for \(arrRelax[relaxCounter + 1]) seconds"
            lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
            
            lblFourSec3.text = "Step 3: \(arrayInhale[2]) for \(arrRelax[relaxCounter + 2]) seconds"
            lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
            
            lblFourSec4.isHidden = true
            break
            
        default:
            break
        }

        let angle: CGFloat = 0
        UIView.animate(withDuration: TimeInterval(1)) {
            self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
        }

        if arrayInhale.count > 0 {
            lblInhale.text = arrayInhale[0]
        }

        stepCounter = 1
    }
    
    // Timer
    func startRelaxHighlightTimer(timerCount: Int) {
        highlightTimer.invalidate() //cancels it if already running
        
        if timerCount > 0 {
            highlightTimer = Timer.scheduledTimer(timeInterval: Double(timerCount), target: self, selector: #selector(updateTextHighlightForRelax), userInfo: nil, repeats: false)
        }
        
        let angle: CGFloat = ((Double.pi * 2) / 3) * Double(relaxCounter+1)
        print("RADIAN------\(angle)")
        UIView.animate(withDuration: TimeInterval(timerCount)) {
            self.imgProgressCircle.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    @objc func updateTextHighlightForRelax() {
        if relaxCounter < 2 {
            relaxCounter = relaxCounter + 1
        } else {
            relaxCounter = 0
        }
        print("Relax counter---->\(relaxCounter)")
        
        if arrayInhale.count == 1 { ///Array count = 1
            //Don't know what to do
        } else if arrayInhale.count == 2 {  ///Array count = 2
            if stepCounter == 1 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Bold", size: 12.0)

                lblInhale.text = arrayInhale[1]

            } else {
                stepCounter -= 1
                lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[0]

            }
        } else if arrayInhale.count == 3 {  ///Array count = 3
            if stepCounter == 1 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[1]

            } else if stepCounter == 2 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Bold", size: 12.0)

                lblInhale.text = arrayInhale[2]

            }else {
                stepCounter -= 2
                lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[0]

            }
        } else if arrayInhale.count == 4 {  ///Array count = 4
            if stepCounter == 1 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[1]

            } else if stepCounter == 2 {
                stepCounter += 1

                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[2]

            } else if stepCounter == 3 {
                stepCounter += 1
                lblFourSec1.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Bold", size: 12.0)

                lblInhale.text = arrayInhale[3]

            } else {
                stepCounter -= 3
                lblFourSec1.font = UIFont(name: "Nunito-Bold", size: 12.0)
                lblFourSec2.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec3.font = UIFont(name: "Nunito-Regular", size: 12.0)
                lblFourSec4.font = UIFont(name: "Nunito-Regular", size: 12.0)

                lblInhale.text = arrayInhale[0]
            }
        }
        
        storeCounter = stepCounter
        print("STORE COUNTER---->\(storeCounter)")
        
        //Reset timer
        highlightTimer.invalidate()
        startRelaxHighlightTimer(timerCount: arrRelax[relaxCounter])
    }
}
