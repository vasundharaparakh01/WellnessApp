//
//  SleepTrackViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 02/02/22.
//
import HealthKit
import UIKit
import AVFoundation
import CoreMotion

fileprivate enum formParameterName: String {
    case duration   = "sleep"
    case start_time = "start_time"
    case end_time   = "end_time"
}

class SleepTrackViewController: UIViewController{
    //Custom Navbar
   
    
    var arraySleepData: [sleepWatchData]?
    var SleepData: sleepWatchData?
    
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    private var countdownTimer: Timer?
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var btnSleep: UIBUtton_Designable!
    @IBOutlet var imgRipple: UIImageView!
    @IBOutlet var lblClock: UILabel!
    @IBOutlet var lblAMPM: UILabel!
    @IBOutlet var btnAlarm: UIButton!
    @IBOutlet var lblAudioTitle: UILabel!
    @IBOutlet var btnStartStop: UIButton!
    @IBOutlet var viewAudioPlayer: UIView!
    
    let strLblTitlePlaceholder = "Listen to a sleep music.   "
    
    //Accelerometer
    let motion = CMMotionManager()
//    var accelTimer: Timer?
    
    //AVAudioRecorder
    var audioRecorder : AVAudioRecorder!
    
    //AVPlayer
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var btnPlay: UIButton!
    var player:AVPlayer?
    var timeObserver: Any?
    var datapoint = [String]()
    var healthStore = HKHealthStore()
    var arrAsssleep = [Int]()
    var arrInBed = [Int]()
    
    //var stepWatchViewModel = SleepViewModel()
   
    
    //Clock
    private var clockTimer: Timer?
    private var boolColon = true
    
    //SleepData
//    private var arrayAccelData = [AccelData]()
    
    //Time Track
    private var startTrackTime: Date? //Timer to keep track of time spent on this page
    
    private var boolStartStop = true
    private var sleepVM = SleepViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        sleepVM.delegate = self
        sleepVM.sleepDataDeleteDelegate = self
        sleepVM.sleepWatchStatDelegate = self
        
        setupTapGesture()
        setupGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
// close by nilanjan, as sanjib want to stick with phase one sleep tracking
        /*
        let status = UserDefaults.standard.bool(forKey: "isFromWatch")
        print(status)
        if status==true
        {
        btnStartStop.setTitle("SLEEP TRACKING", for: .normal)
        }
        else
        {*/
            
            btnStartStop.setTitle("START SLEEP", for: .normal)
       // }
        setupClock()
        checkSyncData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
        
        print("Sleep viewWillDisappear------>")
        //---------------------------------------------------
//        accelTimer?.invalidate()
        clockTimer?.invalidate()

//        //Microphone recording
//        if let record = self.audioRecorder {
//            record.stop()
//        }
//        //Accelerometer
//        if self.motion.isAccelerometerActive {
//            self.motion.stopAccelerometerUpdates()
//        }
        
//        self.btnPlay.isHidden = true
//        self.lblAudioTitle.text = strLblTitlePlaceholder
//
//        //Audio Player
//        if let player = player {
//            player.pause()
//            self.player = nil
//        }
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
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
        self.btnPlay.isHidden = true
        self.loadingView.isHidden = true
        self.lblAudioTitle.text = strLblTitlePlaceholder
        
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        imgBackground.image = UIImage(named: "sleep_bg\(chakraLevel)")
        
        btnSleep.backgroundColor = UIColor.colorSetup()
        imgRipple.tintColor = UIColor.colorSetup()
        btnPlay.tintColor = UIColor.colorSetup()
        btnStartStop.backgroundColor = UIColor.colorSetup()
        btnStartStop.layer.cornerRadius = 10.0
    }
    
    //MARK: ----- Setup Tap Gesture
    private func setupTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector (singleTap))  //Tap function will call when user tap on button
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))  //Long function will call when user long press on button.
        singleTapGesture.numberOfTapsRequired = 1
        btnStartStop.addGestureRecognizer(singleTapGesture)
        btnStartStop.addGestureRecognizer(longTapGesture)
    }
    
    //MARK: ---- Clock Setup
    fileprivate func setupClock() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clockTikTok), userInfo: nil, repeats: true)
    }
    
    @objc private func clockTikTok() {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        if boolColon {
            boolColon = false
            formatter.dateFormat = "hh mm"
            lblClock.text = formatter.string(from: Date())
        } else {
            boolColon = true
            formatter.dateFormat = "hh:mm"
            lblClock.text = formatter.string(from: Date())
        }
        formatter.dateFormat = "aa"
        lblAMPM.text = formatter.string(from: Date())
    }
    
    private func checkSyncData() {
        do {
            if let data = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udSleepData) {
                let storedData = try JSONDecoder().decode(SleepAssetPath.self, from: data as! Data)
                
                if let sleepData = storedData.sleepPath {
                    if !sleepData.path.isEmpty {
                        syncSleepData(storedData: storedData)
                    }
                }
            }
        } catch let error {
            print("checkSyncData()--->\(error.localizedDescription)")
        }
    }
    
    //MARK: ---- Button Func
    @IBAction func btnRecords(_ sender: Any) {
        //Accelerometer
//        if self.motion.isAccelerometerActive {
//            self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
//                                         message: "Do you want to stop ongoing sleep tracking",
//                                         alertStyle: .alert,
//                                         actionTitles: ["OK","Cancel"],
//                                         actionStyles: [.default,.default],
//                                         actions: [
//                                            { _ in
//                                                let sleepRecordVC = ConstantStoryboard.sleepStoryboard.instantiateViewController(withIdentifier: "SleepRecordsViewController") as! SleepRecordsViewController
//                                                self.navigationController?.pushViewController(sleepRecordVC, animated: true)
//                                            },
//                                            {_ in
//
//                                            }])
//        } else {  SleepRecordsAndroidViewController
            let sleepRecordVC = ConstantStoryboard.sleepStoryboard.instantiateViewController(withIdentifier: "SleepRecordsViewController") as! SleepRecordsViewController
            self.navigationController?.pushViewController(sleepRecordVC, animated: true)
        
//        let sleepRecordVC = ConstantStoryboard.sleepStoryboard.instantiateViewController(withIdentifier: "SleepRecordsAndroidViewController") as! SleepRecordsAndroidViewController
//        self.navigationController?.pushViewController(sleepRecordVC, animated: true)
        
        
//        }
        
    }
    //Alarm
    @IBAction func btnAlarm(_ sender: Any) {
    }
    //Audio Selection from list
    @IBAction func btnAudioSelection(_ sender: Any) {
        let sleepAudioListVC = ConstantStoryboard.sleepStoryboard.instantiateViewController(withIdentifier: "SleepMusicListViewController") as! SleepMusicListViewController
        sleepAudioListVC.completion = {sleepAudioData in
            print("Sleep music got------> \(sleepAudioData)")
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            DispatchQueue.main.async {
                self.btnPlay.isHidden = false
                self.btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
                if let musicTitle = sleepAudioData.musicName {
                    self.lblAudioTitle.text = String(format: "%@", musicTitle)
                }
            }
            
            ///Audio Player-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=
            guard let audioPath = sleepAudioData.musicLocation else {
                self.lblAudioTitle.text = self.strLblTitlePlaceholder
                
                //Audio Player
                if let player = self.player {
                    player.pause()
                    self.player = nil
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.setupPlayer(withMediaPath: audioPath)
            }
        }
        self.navigationController?.pushViewController(sleepAudioListVC, animated: true)
    }
    
//    @IBAction func btnStartStop(_ sender: Any) {
//        if boolStartStop {
//            boolStartStop = false
//            btnStartStop.setImage(UIImage.init(named: "Icon material-stop"), for: UIControl.State.normal)
//            btnStartStop.setTitle("STOP SLEEP", for: .normal)
//        } else {
//            boolStartStop = true
//            btnStartStop.setImage(UIImage.init(named: "Path 8433"), for: UIControl.State.normal)
//            btnStartStop.setTitle("START SLEEP", for: .normal)
//        }
//    }
    
    //MARK: ---- Tap Gesture Function
    @objc private func singleTap() {
        // close by nilanjan, as sanjib want to stick with phase one sleep tracking
                /*
        let status = UserDefaults.standard.bool(forKey: "isFromWatch")
        print(status)
        if status==true
        {
            print("second phase")
            retrieveSleepAnalysis()
        }
        else
        {
            print("first phase")*/
        if boolStartStop {
            openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                    message: "Sleep monitor takes at least 30 minutes to measure your sleep behavior. The ideal way is to keep the phone next to the bed, preferably on the nightstand.",
                                    alertStyle: .alert,
                                    actionTitles: ["Cancel","OK"], actionStyles: [.default,.default],
                                    actions: [
                                        { _ in
                                            //Cancel clicked
                                        },
                                        { _ in
                                            //Stop audio playback if playing
                                            //Audio Player
//                                            if let player = self.player {
//                                                player.pause()
//                                                self.player = nil
//                                            }
//                                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//
//                                            self.btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
                                            
                                            self.btnPlay.isHidden = false
                                            self.viewAudioPlayer.isHidden = false
                                            //=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                            
                                            //Check if accelerometer is available or not
                                            if (self.motion.isAccelerometerAvailable) {
                                                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                                                
                                                let opBlockForDeleteRecord = BlockOperation()
                                                opBlockForDeleteRecord.addExecutionBlock {
                                                    //Delete existing data API call. If success response then start sleep rack else alert.
                                                    self.DeleteExistingRecordAPICall()
                                                    print("block operation----Delete")
                                                }
                                                
                                                let opBlockForStartSleepTrack = BlockOperation()
                                                opBlockForStartSleepTrack.addExecutionBlock {
                                                    //Start sleep track
                                                    self.StartSleepTrack()
                                                    print("block operation----Start sleep")
                                                }
                                                
                                                opBlockForStartSleepTrack.addDependency(opBlockForDeleteRecord)
                                                
                                                let opQueue = OperationQueue()
                                                opQueue.qualityOfService = .utility
                                                opQueue.addOperations([opBlockForDeleteRecord, opBlockForStartSleepTrack], waitUntilFinished: false)
                                                
                                                
                                            } else {
                                                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Your device doesn't support sleep tracking")
                                            }
                                        }])
        }
    }
//}
    @objc private func longTap() {
        if !boolStartStop {
            boolStartStop = true
            btnStartStop.setImage(UIImage.init(named: "Path 8433"), for: UIControl.State.normal)
            btnStartStop.setTitle("START SLEEP", for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.StopSleepTrack()
            })
            
            // Show audio player view
//            self.lblAudioTitle.text = self.strLblTitlePlaceholder
            self.viewAudioPlayer.isHidden = false
        }
    }
    
    
    func retrieveSleepAnalysis() {
        var startdatee : String!
        var endDatee : String!
        var sleepAt : String!
      
        // startDate and endDate are NSDate objects
        
       // ...
        
        // first, we define the object type we want
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {

            // You may want to use a predicate to filter the data... startDate and endDate are NSDate objects corresponding to the time range that you want to retrieve

            //let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,endDate: endDate ,options: .None)

            // Get the recent data first

            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

            // the block completion to execute

//            let querryy = HKStatisticsCollectionQuery(quantityType: smaplequery, quantitySamplePredicate: predicate, options:[ .cumulativeSum], anchorDate: startdate, intervalComponents: interval)
            
            var startdate = Calendar.current.startOfDay(for: Date())
            let predicate = HKQuery.predicateForSamples(withStart: startdate, end: Date(), options: .strictEndDate)

            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 100000, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in

                if error != nil {

                    // Handle the error in your app gracefully
                    return

                }

                if let result = tmpResult {

                    for item in result {
                        if let sample = item as? HKCategorySample {

                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                           
//
//                            if let result = tmpResult {
//                                            for item in result {
//                                                if let sample = item as? HKCategorySample {
//                                                    switch sample.value {
//                                                    case 0:
//                                                        // inBed, write logic here
//                                                        print("inBedddd")
//                                                    case 1:
//                                                        // asleep, write logic here
//                                                        print("asleeppppp")
//                                                    default:
//                                                        // awake, write logic here
//                                                        print("awakeeeee")
//                                                    }
//                                                }
//                                            }
//                                        }

                           

                               
                            print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                          
                           
                            if value == "InBed"
                            {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                                print(formatter.string(from: sample.startDate))
                                
                                startdatee = (formatter.string(from: sample.startDate))
                                endDatee = (formatter.string(from: sample.endDate))
                                let calendar = Calendar.current
                                let dateComponents = calendar.dateComponents([Calendar.Component.second], from: sample.startDate, to: sample.endDate)
                                let seconds = dateComponents.second
                                self.arrInBed.append(seconds!)
                            }
                            else
                            {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                                print(formatter.string(from: sample.startDate))
                                print(formatter.string(from: sample.endDate))
                                
                                sleepAt = (formatter.string(from: sample.startDate))
                                let calendar = Calendar.current
                                let dateComponents = calendar.dateComponents([Calendar.Component.second], from: sample.startDate, to: sample.endDate)
                                let seconds = dateComponents.second
                                self.arrAsssleep.append(seconds!)
                            }
                            
                            //print(self.arrAsssleep.count)
                        }
                    }
                    let sumInBed = self.arrInBed.reduce(0, +)
                   print("Sum of InBed is : ", sumInBed)
                    
                    let sumAsleep = self.arrAsssleep.reduce(0, +)
                    print("Sum of Asleep is : ", sumAsleep)
                    
                   
                    
                    let sumAwake = sumInBed-sumAsleep
                    print("awake time is : ", sumAwake)
                    
                    let awakePercentage : Double = ((100/Double(sumInBed)) * Double(sumAwake))
                    debugPrint(awakePercentage)
                    
                    let asleepPercentage = Double(100 - awakePercentage)
                    
                    let randomInt = Double.random(in: 15..<30)
                    
                    let lightPercentageval = Double(100 - randomInt)
                    
                    
                    
                    let DeepPercentagegenarate : Double = ((asleepPercentage * randomInt)/100)
                    
                    let deepSleepDuration : Double = ((Double(sumAsleep)/100) * DeepPercentagegenarate)
                    
                    let lightPercentagegenarate : Double = (100-(DeepPercentagegenarate + awakePercentage))
                    
                   // let lightSleepDuration : Double = ((Double(sumAsleep)/100) * lightPercentagegenarate)
                    let lightSleepDuration : Double = (Double(sumInBed)-(Double(sumAwake) + Double(deepSleepDuration)))
                    let deeppercetage : Double = ((Double(sumAsleep) * Double(randomInt))/100)
                    debugPrint(deeppercetage)
                    
                    let lightPercentage : Double = ((Double(sumAsleep) * Double(lightPercentageval))/100)
                    debugPrint(lightPercentage)
                    
                    self.datapoint.append(String(awakePercentage))
                    self.datapoint.append(String(lightPercentagegenarate))
                    self.datapoint.append(String(DeepPercentagegenarate))
                   
                    
                    DispatchQueue.main.async {
                    
                        if startdatee != nil
                        {
                      
                    
                    self.getStatData(Date: startdatee, SleepAt: startdatee, WakeAt: endDatee, Sessionduration: Int(sumInBed), Sleepduration: Int(sumAsleep), Deeppercentage: String(DeepPercentagegenarate), Lightpercentage: String(lightPercentagegenarate), Awakepercentage: String(awakePercentage), Undetectedduration: "0", Undetectedpercentage: "0", REMpercentage: "0", Deepduration: Int(deepSleepDuration), Lightduration: Int(lightSleepDuration), Awakeduration: Int(sumAwake), REMduration: Int(0), devicetype: "Apple watch", devicecat: "watch")
                        }
                        
                        else
                        {
                        debugPrint("hello")
                            
                            let refreshAlert = UIAlertController(title: "Luvo", message: "No sleep record found from Apple Watch", preferredStyle: UIAlertController.Style.alert)

                                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                              print("Handle Ok logic here")
                                            
                                            
                                        }))

                            self.present(refreshAlert, animated: true, completion: nil)
                        }
                    
                    }
                }
            }


            healthStore.execute(query)
        }
    
    }
    
    //MARK: Get Stat Data --------------------
    private func getStatData(Date: String, SleepAt: String, WakeAt: String, Sessionduration: Int, Sleepduration: Int, Deeppercentage: String, Lightpercentage: String, Awakepercentage: String, Undetectedduration: String, Undetectedpercentage: String, REMpercentage: String, Deepduration: Int, Lightduration: Int, Awakeduration: Int, REMduration: Int, devicetype: String, devicecat: String) {
        
        //print("Start date--->\(startDate) End date--->\(endDate)")
        
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
            if arraySleepData == nil {
                arraySleepData = [sleepWatchData]()//Storing selected answer
                print(arraySleepData!)
                
                let arrstartdate : [String] = ["2022-08-11 01:45:00","2022-08-11 03:45:00","2022-08-11 04:45:00" ]
                debugPrint(arrstartdate[1])
                
                let summary : [String] = ["Awake","Light_sleep","Deep_sleep"]
                debugPrint(summary[1])
                
               // let datapoint : [String] = ["80.0","70.0","60.0"]
                debugPrint(datapoint[1])
                
                var val: Int = 0
            for _ in 1...3 {
             
                debugPrint(val)
                
                self.SleepData = sleepWatchData(start: arrstartdate[val], summary: summary[val], datapoint: Float(datapoint[val]))
                self.arraySleepData?.append(self.SleepData!)
                
                val+=1
                
            }
                
            }
            
            debugPrint(self.arraySleepData!)
            
            let request = SleepWatchStatRequest(Date: Date, Sleep_At: SleepAt, Wake_At: WakeAt, Session_duration: Sessionduration, Sleep_duration: Sleepduration, Deep_percentage: Deeppercentage, Light_percentage: Lightpercentage, Awake_percentage: Awakepercentage, Undetected_duration: Undetectedduration, Undetected_percentage: Undetectedpercentage, REM_percentage: REMpercentage, Deep_duration: Deepduration, Light_duration: Lightduration, Awake_duration: Awakeduration, REM_duration: REMduration, device_type: devicetype, device_cat: devicecat, result: self.arraySleepData)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            sleepVM.postSleepWatchData(sleepWatchStatRequest: request, token: token)
        
    }
    }
    
//    //MARK: Notification Setup -------------------------
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



extension SleepTrackViewController {
    func setupPlayer(withMediaPath: String) {
        // "http://beas.in:5000/music-1647320218414.mp3"
        // "http://beas.in:5000/music-1647310363635.mp3"
        // "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"
        // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3"
        // "https://luvo.s3.us-east-2.amazonaws.com/uploads/musics/music-1638000779365.mp3"
        //let finalPath = "http%3A%2F%2Fbeas.in%3A5000%2Fmusic-1647320218414.mp3"
        
//        let finalPath = Common.WebserviceAPI.baseURL+withMediaPath
        
        guard let url = withMediaPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = URL(string: url)!
        print("Audio DATA------\(url)")
        
        if AVURLAsset.init(url: urlString).isPlayable {
            print("Audio DATA------Playable")
            
            let playerItem:AVPlayerItem = AVPlayerItem(url: urlString)
            player = AVPlayer(playerItem: playerItem)
//            player?.volume = 1.0

            NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        } else {
            print("Audio not playable------------------------>")
        }
        
        self.view.stopActivityIndicator()
    }
    
    @IBAction func ButtonPlay(_ sender: Any) {
        print("play Button")
        if player == nil { return }
        if player?.rate == 0 {
            player!.play()
            btnPlay.setImage(UIImage(named: "ic_orchadio_stop"), for: UIControl.State.normal)

        } else {
            player!.pause()
            player?.seek(to: CMTime.zero)
            btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        player?.seek(to: CMTime.zero)
        btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
    }
}

extension SleepTrackViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    private func StartSleepTrack() {
        //Microphone recording
        self.StartMicrophone()
        
        self.startTimer()
    }
    func startTimer() {
        DispatchQueue.main.async {
            self.countdownTimer?.invalidate() //cancels it if already running
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.stopAudio), userInfo: nil, repeats: true) //1hr call
    }
    }
    
    @objc func stopAudio()
    {
                //Microphone recording
               if let record = self.audioRecorder {
                   record.stop()
                }
    }
    private func StopSleepTrack() {
        //Audio Player
        if let player = player {
            player.pause()
        }
        btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        
        //Microphone recording
        if let record = self.audioRecorder {
            record.stop()
        }
        //Accelerometer
        self.StopAccelerometer()
        //API call
        self.ReadyForAPICall()
    }
    
    //Recording
    private func StartMicrophone() {
        let session = AVAudioSession.sharedInstance()
        
        do{
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, policy: AVAudioSession.RouteSharingPolicy.default, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
            try session.setActive(true)
            session.requestRecordPermission({ (allowed : Bool) -> Void in
                if allowed {
                    DispatchQueue.main.async {
                        //Change button UI
                        self.boolStartStop = false
                        self.btnStartStop.setImage(UIImage.init(named: "Icon material-stop"), for: UIControl.State.normal)
                        self.btnStartStop.setTitle("HOLD TO STOP", for: .normal)
                    }
                    
                    //Microphone
                    self.startRecording()
                    //Accelerometer
                    self.StartAccelerometers()
                    //Time Track
                    self.startTrackTime = Date()
                } else {
                    self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                                 message: "Please turn on microphone access from your device settings and try again",
                                                 alertStyle: .alert,
                                                 actionTitles: ["Open Settings", "Cancel"],
                                                 actionStyles: [.default,.default],
                                                 actions: [
                                                    { _ in
                                                        //Open settings
                                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                                    },
                                                    { _ in
                                                        //Cancel
                                                    }])
                    
//                    self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Turn on microphone access from your device settings and try again")
                }
            })
        }
        catch{
            print("\(error)")
        }
    }
    private func startRecording(){
        do{
//            guard let audioURL = URL(string: NSTemporaryDirectory()) else { return }
            let audioURL = getRecordURL(fileName: ConstantUploadAudio.fileName)
            print(audioURL)
            
            self.audioRecorder = try AVAudioRecorder(url: audioURL, settings: self.audioRecorderSettings() as [String : AnyObject])
            
            if let recorder = self.audioRecorder{
                recorder.delegate = self
                recorder.isMeteringEnabled = true
                
                if recorder.record() && recorder.prepareToRecord(){
                    print("Audio recording started successfully")
                }
            }
        }
        catch{
            print("\(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
//        do {
//            let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            return documentsDirectory
//        } catch let error {
//            print("getDocumentDirectory-----> \(error.localizedDescription)")
//            return nil
//        }
        //--------
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func getRecordURL(fileName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }

    private func audioRecorderSettings() -> Dictionary<String, Any> {
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                      AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
//                  AVEncoderBitRateKey: 16,
             AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue]
        
        return settings
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true{
            print("Recording stops successfully")
        } else{
            print("Stopping recording failed")
        }
    }
    
    //Accelerometer
    private func StartAccelerometers() {
//        self.arrayAccelData.removeAll()
        let pathDirectory = getRecordURL(fileName: ConstantUploadSleep.fileName)
        
        //Create file
        if (FileManager.default.createFile(atPath: pathDirectory.path, contents: nil, attributes: nil)) {
            print("File created successfully.")
        } else {
            print("File not created.")
        }
        
        let fileQueue = OperationQueue()
        let accelQueue = OperationQueue()
        
        fileQueue.maxConcurrentOperationCount = 1
        accelQueue.maxConcurrentOperationCount = 1
        
        
        if FileManager.default.fileExists(atPath: pathDirectory.path) {
            do {
                // Header first (optional)
                let header = "Time,X,Y,Z\n" // note no spaces, comma is the operator
                if let headerUTF8 = header.data(using: .utf8) {
                    let fileHandle = try FileHandle(forWritingTo: pathDirectory)
                    fileHandle.write(headerUTF8)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
       // Make sure the accelerometer hardware is available.
        if (self.motion.isAccelerometerAvailable) {
            // Assign the update interval to the motion manager.
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0
            
            self.motion.startAccelerometerUpdates(to: accelQueue, withHandler: { [weak self] (sample: CMLogItem?, error: Error?) in
                guard let self = self else { return }
                
//                //For sound decible(dB) value
//                self.audioRecorder.updateMeters()
//                print("DECIBEL--------> \(self.audioRecorder.averagePower(forChannel: 0))")
                //----------------------------------
                
                if let accelerometerData = sample as? CMAccelerometerData {
//                    debugPrint("X: \(accelerometerData!.acceleration.x) Y: \(accelerometerData!.acceleration.y) Z: \(accelerometerData!.acceleration.z) Time: \(Date())")
//                    let now = Date().timeIntervalSince1970
//                    let sampleComponents: [Double] = [
//                        now,
//                        accelerometerData.timestamp,
//                        accelerometerData.acceleration.x,
//                        accelerometerData.acceleration.y,
//                        accelerometerData.acceleration.z
//                    ]
//                    let row = sampleComponents.map({ String(format: "%.5f", $0) })
//                    let sampleString = row.joined(separator: ",") + "\n"
                    if FileManager.default.fileExists(atPath: pathDirectory.path) {
                        let writeOperation = BlockOperation(block: {
                            do {
//                                // Format for each line of data
                                let sampleString = String(format: "%@,%f,%f,%f\n", self.SleepFormatDate(date: Date()) ,accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z)
                                if let utf8Sample = sampleString.data(using: .utf8) {
                                    let fileHandle = try FileHandle(forWritingTo: pathDirectory)
                                    fileHandle.seekToEndOfFile()
                                    fileHandle.write(utf8Sample)
                                    fileHandle.closeFile()
//                                    //---------------
//                                    try utf8Sample.write(to: pathDirectory)
                                }
                            } catch let error as NSError {
                                print("There was an error while writing to file --- \(error.localizedDescription)")
                            }
                        })
                        if let lastOperation = fileQueue.operations.last {
                            writeOperation.addDependency(lastOperation)
                        }
                        fileQueue.addOperation(writeOperation)
//                        print("Num OPs in AccelQueue Queue: \(accelQueue.operations.count)")
//                        print("Num OPs in I/O File Queue: \(fileQueue.operations.count)")
                    }
                }
            })
            
            
            
            //------------------------------------------
//            self.motion.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (accelerometerData, error) in
//                debugPrint("X: \(accelerometerData!.acceleration.x) Y: \(accelerometerData!.acceleration.y) Z: \(accelerometerData!.acceleration.z) Time: \(Date())")
////                let accelData = AccelData(x: accelerometerData!.acceleration.x,
////                                          y: accelerometerData!.acceleration.y,
////                                          z: accelerometerData!.acceleration.z,
////                                          time: "\(Date())")
//
//                self.arrayAccelData.append(AccelData(x: accelerometerData!.acceleration.x,
//                                                     y: accelerometerData!.acceleration.y,
//                                                     z: accelerometerData!.acceleration.z,
//                                                     time: "\(Date())"))
//
////                let data_points = [accelerometerData?.acceleration.x,
////                                   accelerometerData?.acceleration.y,
////                                   accelerometerData?.acceleration.z,
////                                   accelerometerData?.timestamp]
////
////                print(accelerometerData?.acceleration.x)
////
////                let line = ",".joined(data_points.map { $0.description }) + "\n"
////                let encoded = line.dataUsingEncoding(NSUTF8StringEncoding)!
////
//                let json = try? JSONEncoder().encode(self.arrayAccelData)
////                print("array.json------->",String(data: json!, encoding: .utf8)!)
//                do {
//                    try json!.write(to: pathDirectory)
//                } catch {
//                    print("Failed to write JSON data: \(error.localizedDescription)")
//                }
//            })
        }
    }
    
    private func StopAccelerometer() {
        if self.motion.isAccelerometerActive {
//            self.accelTimer?.invalidate()
            self.motion.stopAccelerometerUpdates()
        }
        
//        self.storeSleepDataIntoJSONFile(arrayToStore: self.arrayAccelData)
    }
}

/*
extension SleepTrackViewController {
    func setupPlayer(indexpath: Int) {
        let arrayAudioListData = [Any]()
        //Audio Title---
        //lblAudioTitle.text = arrayAudioListData[indexpath].musicName
        //------------------------
        //guard let url = arrayAudioListData[indexpath].musicFile else { return }

        let finalPath = Common.WebserviceAPI.baseURL //+ url
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: finalPath)!)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        //Track playback status
        self.timeObserver = player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) {[weak self] (CMTime) -> Void in
            guard let self = self else { return }
            if self.player!.currentItem?.status == .readyToPlay {
                //Do your time duration text, playback slider setup here
            }
            
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
//                print("IsBuffering")
                self.btnPlay.isHidden = true
                self.loadingView.isHidden = false
            } else {
//                print("Buffering completed")
                self.btnPlay.isHidden = false
                self.loadingView.isHidden = true
            }
        }
        
        //Autoplay at initial
        player?.play()
        self.btnPlay.isHidden = true
        btnPlay.setImage(UIImage(named: "ic_orchadio_pause"), for: UIControl.State.normal)
    }
    
    @IBAction func ButtonPlay(_ sender: Any) {
        print("play Button")
        if player == nil { return }
        if player?.rate == 0 {
            player!.play()
            self.btnPlay.isHidden = true
            self.loadingView.isHidden = false
            btnPlay.setImage(UIImage(named: "ic_orchadio_pause"), for: UIControl.State.normal)
            
        } else {
            player!.pause()
            btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        player?.seek(to: CMTime.zero)
        btnPlay.setImage(UIImage(named: "ic_orchadio_play"), fr: UIControl.State.normal)
    }
}
*/

extension SleepTrackViewController: SleepWatchStatDelegate
{
    func didReceiveSleepWatchStatDataResponse(sleepWatchStatDataResponse: SleepWatchStatResponse?) {
        print("tring tring")
        self.view.stopActivityIndicator()
    }
    
    func didReceiveSleepWatchStatDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
   
    
    
}

extension SleepTrackViewController: SleepViewModelDelegate {
    func ReadyForAPICall() {
        let audioURL = getRecordURL(fileName: ConstantUploadAudio.fileName)
        let sleepDataURL = getRecordURL(fileName: ConstantUploadSleep.fileName)
        do {
            if let audioData = try? Data(contentsOf: audioURL) {
                if let sleepData = try? Data(contentsOf: sleepDataURL) {
//                    print("Array data------\(arrayAccelData)")
//                    print("Audio data------\(audioData)")
                    
                    guard let startTime = self.startTrackTime else { return }
                    let durationString = Date().timeDifference(startTime: startTime, endTime: Date())
                    let startTimeString = self.SleepFormatDate(date: startTime)
                    let endTimeString = self.SleepFormatDate(date: Date())
                    
                    let startTimeStringToData = Data(startTimeString.utf8)
                    let endTimeStringToData = Data(endTimeString.utf8)
                    let durationToData = Data(durationString.utf8)
                    //-----------------------------------
                    
//                    let trackInSecond = Int(Date().timeDifference(startTime: startTime, endTime: Date()))
                    ///Convert time difference String to Int (Type casting) otherwise API call will not work when using JSONEncoder
                    //------------------------------------
                    //Convert to Data
                    /////Not required as sleepData is large and backend serialize. So store sleep data on a .json file and send via multipart/form-data
//                    let sleepData = try JSONEncoder().encode(arrayAccelData)
//                    let duration = try JSONEncoder().encode(durationString)
//                    let start_time = try JSONEncoder().encode(self.SleepFormatDate(date: startTime))
//                    let end_time = try JSONEncoder().encode(self.SleepFormatDate(date: Date()))
                    //------------------------------------
                    
                    //Store data for later
//                    let request = SleepRequest(music: AudioUploadRequest(audio: audioData,
//                                                                         fileName: ConstantUploadAudio.fileName,
//                                                                         fileType: ConstantUploadAudio.fileType,
//                                                                         parameterName: ConstantUploadAudio.parameterName),
//                                               sleep_data: SleepUploadRequest(sleepData: sleepData,
//                                                                              fileName: ConstantUploadSleep.fileName,
//                                                                              fileType: ConstantUploadSleep.fileType,
//                                                                              parameterName: ConstantUploadSleep.parameterName),
//                                               duration: durationToData,
//                                               start_time: startTimeStringToData,
//                                               end_time: endTimeStringToData)
                    //Dont store the whole data, just store the audio & sleep file path
                    let data = SleepAssetPath(audioPath: audioURL,
                                              sleepPath: sleepDataURL,
                                              duration: durationToData,
                                              start_time: startTimeStringToData,
                                              end_time: endTimeStringToData)
                    let storeSleepDataPath = try JSONEncoder().encode(data)
                    UserDefaults.standard.set(storeSleepDataPath, forKey: ConstantUserDefaultTag.udSleepData)
//                    storeSleepDataPath.printJSON() //*** Memory Leak - Trying to print JSON log while setting UserDefault ***
                    
                    //------------------------------------
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
                        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                        
                        let audioData = AudioUploadRequest(audio: audioData, fileName: ConstantUploadAudio.fileName, fileType: ConstantUploadAudio.fileType, parameterName: ConstantUploadAudio.parameterName)
                        
                        let sleep = SleepUploadRequest(sleepData: sleepData, fileName: ConstantUploadSleep.fileName, fileType: ConstantUploadSleep.fileType, parameterName: ConstantUploadSleep.parameterName)
                        
                        let formParameters = [formParameterName.duration.rawValue: durationToData,
                                              formParameterName.start_time.rawValue: startTimeStringToData,
                                              formParameterName.end_time.rawValue: endTimeStringToData]
                     //   let formParameters = [formParameterName.duration.rawValue: durationToData]
                        
                        //API call device_type: "Apple watch" device_cat: "mobile"
                       // sleepVM.uploadSleepData(mediaData: audioData, sleepData: sleep, formParam: formParameters, token: token)
                        sleepVM.uploadSleepData(mediaData: audioData, sleepData: sleep, formParam: formParameters, token: token)
                        
//                        //temp
//                        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.arrayAccelData), forKey: ConstantUserDefaultTag.udSleepData)
//                        if let tempUD = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udSleepData) as? Data {
//                            let tempSleepData: [SleepData] = try! PropertyListDecoder().decode([SleepData].self, from: tempUD)
//                            print("SLEEP DATA-----> \(tempSleepData)")
//                        }
                    }
                }
            }
        } catch let error {
            print("Sleep Error--->\(error.localizedDescription)")
        }
    }
    
    private func syncSleepData(storedData: SleepAssetPath) {
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        
        do {
            guard let audioPath = storedData.audioPath,
                  let sleepPath = storedData.sleepPath,
                  let duration = storedData.duration,
                  let start_time = storedData.start_time,
                  let end_time = storedData.end_time else { return }
                    
            let audioData = try Data(contentsOf: audioPath)
            let sleepData = try Data(contentsOf: sleepPath)
            
            let audioRequest = AudioUploadRequest(audio: audioData,
                                               fileName: ConstantUploadAudio.fileName,
                                               fileType: ConstantUploadAudio.fileType,
                                               parameterName: ConstantUploadAudio.parameterName)
            
            let sleepRequest = SleepUploadRequest(sleepData: sleepData,
                                               fileName: ConstantUploadSleep.fileName,
                                               fileType: ConstantUploadSleep.fileType,
                                               parameterName: ConstantUploadSleep.parameterName)
            
            let formParameters = [formParameterName.duration.rawValue: duration,
                                  formParameterName.start_time.rawValue: start_time,
                                  formParameterName.end_time.rawValue: end_time]
            
            //API call
            sleepVM.uploadSleepData(mediaData: audioRequest, sleepData: sleepRequest, formParam: formParameters, token: token)
            
        } catch let error {
            print("Sync error---->\(error.localizedDescription)")
        }
    }
    
    //SleepVM Delegate
    func didReceiveSleepDataUploadResponse(sleepDataUploadResponse: SleepResponse?) {
        self.view.stopActivityIndicator()
        if(sleepDataUploadResponse?.status != nil && sleepDataUploadResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            if let message = sleepDataUploadResponse?.message {
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
            }
            
            //Remove stored sleep data
            UserDefaults.standard.removeObject(forKey: ConstantUserDefaultTag.udSleepData)
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: sleepDataUploadResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveSleepDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension SleepTrackViewController: SleepDeleteDataDelegate {
    private func DeleteExistingRecordAPICall() {
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
            //API call
            sleepVM.deleteSleepData(token: token)
        }
    }
    
    func didReceiveSleepDeleteDataResponse(sleepDeleteDataResponse: SleepDataDeleteResponse?) {
        self.view.stopActivityIndicator()
        if(sleepDeleteDataResponse?.status != nil && sleepDeleteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            debugPrint("Sleep Data Deletion Success")
        } else {
            debugPrint("Sleep Data Deletion Failed")
            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Sleep track failed to start. Please try again.")
        }
    }
    
    func didReceiveSleepDeleteDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension SleepTrackViewController {
//    func storeSleepDataIntoJSONFile(arrayToStore: [AccelData]?) {
//        let pathDirectory = getRecordURL(fileName: ConstantUploadSleep.fileName)
//        ///It will create all the nested directories if they don't exist. Same as adding the -p flag to the mkdir command
////        try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
////        let filePath = pathDirectory.appendingPathComponent(ConstantUploadSleep.fileName)
//
//        let json = try? JSONEncoder().encode(arrayToStore)
//
////        print("array.json------->",String(data: json!, encoding: .utf8)!)
//
//        do {
//            try json!.write(to: pathDirectory)
//        } catch {
//            print("Failed to write JSON data: \(error.localizedDescription)")
//        }
//    }
    
    fileprivate func SleepFormatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatDate = dateFormatter.string(from: date)
//        debugPrint("Format Date--->",formatDate)
        return formatDate
    }
}
