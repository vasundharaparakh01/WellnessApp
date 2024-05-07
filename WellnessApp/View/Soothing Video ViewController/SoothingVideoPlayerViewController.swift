//
//  SoothingVideoPlayerViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 27/10/21.
//

import UIKit
import AVKit
import AVFoundation

class SoothingVideoPlayerViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    //AVPlayer
    var player:AVPlayer?
    var timeObserver: Any?
    fileprivate let seekDuration: Float64 = 10
    
    @IBOutlet var viewVideoPlayer: UIView!
    @IBOutlet weak var lblOverallDuration: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnFullscreen: UIButton!
    //----------------------------
    
    @IBOutlet var imgSemiCircleBack: UIImageView!
    @IBOutlet var btnFav: UIButton!
    
    var soothingVideoData: SoothingVideosList?
    var favViewModel = FavouritesViewModel()
    
    var boolFav = false
    
    let startTrackTime = Date() //Timer to keep track of time spent on this page
    var timeTrackViewModel = TimeTrackingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        favViewModel.delegate = self
        timeTrackViewModel.delegate = self
        
        setupVideoControlButton()
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.setupVideoPlayer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.pause()
            removePeriodicTimeObserver()
            self.player = nil
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
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
        updateTimeTrack()
//        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    func setupVideoControlButton() {
        btnRewind.tintColor = UIColor.colorSetup()
        ButtonPlay.tintColor = UIColor.colorSetup()
        btnForward.tintColor = UIColor.colorSetup()
        playbackSlider.tintColor = UIColor.colorSetup()
        btnFullscreen.tintColor = UIColor.colorSetup()
    }
    
    //MARK: - Button Func
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
                favViewModel.addToFavourite(favRequest: FavouritesRequest(musicId: soothingVideoData?.musicId, musicType: soothingVideoData?.musicType), token: token)
            } else {
                favViewModel.deleteFromFavourite(favRequest: FavouritesRequest(musicId: soothingVideoData?.musicId, musicType: soothingVideoData?.musicType), token: token)
            }
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

extension SoothingVideoPlayerViewController {
    func setupVideoPlayer() {
        //        guard let videoUrl = soothingVideoData?.musicFile else { return }
        //        let finalPath = Common.WebserviceAPI.baseURL + videoUrl
        
        guard let videoUrl = soothingVideoData?.musicLocation else { return }
        
         //       let videoUrl = "https://luvo.s3.us-east-2.amazonaws.com/uploads/luvo-video.mp4"
        
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
    }
}

extension SoothingVideoPlayerViewController: FavouritesViewModelDelegate {
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

extension SoothingVideoPlayerViewController: TimeTrackingDelegate {
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


///
/*
var mediaJSON = { "categories" : [ { "name" : "Movies",
"videos" : [
    { "description" : "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" ],
      "subtitle" : "By Blender Foundation",
      "thumb" : "images/BigBuckBunny.jpg",
      "title" : "Big Buck Bunny"
    },
    { "description" : "The first Blender Open Movie from 2006",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4" ],
      "subtitle" : "By Blender Foundation",
      "thumb" : "images/ElephantsDream.jpg",
      "title" : "Elephant Dream"
    },
    { "description" : "HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For $35.\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast.",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4" ],
      "subtitle" : "By Google",
      "thumb" : "images/ForBiggerBlazes.jpg",
      "title" : "For Bigger Blazes"
    },
    { "description" : "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when Batman's escapes aren't quite big enough. For $35. Learn how to use Chromecast with Google Play Movies and more at google.com/chromecast.",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4" ],
      "subtitle" : "By Google",
      "thumb" : "images/ForBiggerEscapes.jpg",
      "title" : "For Bigger Escape"
    },
    { "description" : "Introducing Chromecast. The easiest way to enjoy online video and music on your TV. For $35.  Find out more at google.com/chromecast.",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4" ],
      "subtitle" : "By Google",
      "thumb" : "images/ForBiggerFun.jpg",
      "title" : "For Bigger Fun"
    },
    { "description" : "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for the times that call for bigger joyrides. For $35. Learn how to use Chromecast with YouTube and more at google.com/chromecast.",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4" ],
      "subtitle" : "By Google",
      "thumb" : "images/ForBiggerJoyrides.jpg",
      "title" : "For Bigger Joyrides"
    },
    { "description" :"Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when you want to make Buster's big meltdowns even bigger. For $35. Learn how to use Chromecast with Netflix and more at google.com/chromecast.",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4" ],
      "subtitle" : "By Google",
      "thumb" : "images/ForBiggerMeltdowns.jpg",
      "title" : "For Bigger Meltdowns"
    },
    { "description" : "Sintel is an independently produced short film, initiated by the Blender Foundation as a means to further improve and validate the free/open source 3D creation suite Blender. With initial funding provided by 1000s of donations via the internet community, it has again proven to be a viable development model for both open 3D technology as for independent animation film.\nThis 15 minute film has been realized in the studio of the Amsterdam Blender Institute, by an international team of artists and developers. In addition to that, several crucial technical and creative targets have been realized online, by developers and artists and teams all over the world.\nwww.sintel.org",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4" ],
      "subtitle" : "By Blender Foundation",
      "thumb" : "images/Sintel.jpg",
      "title" : "Sintel"
    },
    { "description" : "Smoking Tire takes the all-new Subaru Outback to the highest point we can find in hopes our customer-appreciation Balloon Launch will get some free T-shirts into the hands of our viewers.",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4" ],
      "subtitle" : "By Garage419",
      "thumb" : "images/SubaruOutbackOnStreetAndDirt.jpg",
      "title" : "Subaru Outback On Street And Dirt"
    },
    { "description" : "Tears of Steel was realized with crowd-funding by users of the open source 3D creation tool Blender. Target was to improve and test a complete open and free pipeline for visual effects in film - and to make a compelling sci-fi film in Amsterdam, the Netherlands.  The film itself, and all raw material used for making it, have been released under the Creatieve Commons 3.0 Attribution license. Visit the tearsofsteel.org website to find out more about this, or to purchase the 4-DVD box with a lot of extras.  (CC) Blender Foundation - http://www.tearsofsteel.org",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4" ],
      "subtitle" : "By Blender Foundation",
      "thumb" : "images/TearsOfSteel.jpg",
      "title" : "Tears of Steel"
    },
    { "description" : "The Smoking Tire heads out to Adams Motorsports Park in Riverside, CA to test the most requested car of 2010, the Volkswagen GTI. Will it beat the Mazdaspeed3's standard-setting lap time? Watch and see...",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4" ],
      "subtitle" : "By Garage419",
      "thumb" : "images/VolkswagenGTIReview.jpg",
      "title" : "Volkswagen GTI Review"
    },
    { "description" : "The Smoking Tire is going on the 2010 Bullrun Live Rally in a 2011 Shelby GT500, and posting a video from the road every single day! The only place to watch them is by subscribing to The Smoking Tire or watching at BlackMagicShine.com",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4" ],
      "subtitle" : "By Garage419",
      "thumb" : "images/WeAreGoingOnBullrun.jpg",
      "title" : "We Are Going On Bullrun"
    },
    { "description" : "The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car.The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car.",
      "sources" : [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4" ],
      "subtitle" : "By Garage419",
      "thumb" : "images/WhatCarCanYouGetForAGrand.jpg",
      "title" : "What care can you get for a grand?"
    }
]}]};
*/
