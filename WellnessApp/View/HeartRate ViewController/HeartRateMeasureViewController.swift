//
//  HeartRateMeasureViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 02/12/21.
//

import UIKit
import AVFoundation

fileprivate struct BPMMessage {
    static let cover = "Cover the back camera until the BPM detection"    //"Cover the back camera until the image turns red 🟥"
    static let hold = "Hold your index finger ☝️ still."
}

class HeartRateMeasureViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var btnMeasure: UIBUtton_Designable!
    @IBOutlet var viewHeartMiddle: UIView_Designable!
    @IBOutlet var imgHeartMiddle: UIImageView!
    @IBOutlet var lblHeartRateLive: UILabel!
    @IBOutlet var lblHeartRateMin: UILabel!
    @IBOutlet var lblHeartRateMax: UILabel!
    @IBOutlet var lblHeartRateAvg: UILabel!
    
    @IBOutlet weak var progrssBar: UIProgressView!
    @IBOutlet var lblBpm: UILabel!
    @IBOutlet var lblMin: UILabel!
    @IBOutlet var lblMax: UILabel!
    @IBOutlet var lblAvg: UILabel!
    
    //Pulse SDK-----
    private var validFrameCounter = 0
    private var heartRateManager: HeartRateManager!
    private var hueFilter = Filter()
    private var pulseDetector = PulseDetector()
    private var inputs: [CGFloat] = []
    private var measurementStartedFlag = false
    private var timer = Timer()
    
    
    @IBOutlet weak var previewLayer: UIView!    //Show/hide done from storyboard
    @IBOutlet weak var thresholdLabel: UILabel!
    //----------------
    
//    private var timerDetect = Timer()
    private var timerAvg = Timer()
    private var arrayAvg = [Int]()
    private var progressValue: Float = 0.0
    private let bpmCountLimit = 10
    
    private var heartViewModel = HeartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        heartViewModel.delegateHeartPostData = self
        
//        setupGUI()
//        setupImgAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
//        DispatchQueue.main.async {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized

                UserDefaults.standard.set(false, forKey: "isDenied")
                print("already authorized -------->>>>>")
                self.setupGUI()
                self.setupPulse()



            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        UserDefaults.standard.set(false, forKey: "isDenied")
                       print("access allowed -------->>>>>")
                        self.setupGUI()
                        self.setupPulse()


                    } else {
//                        //access denied
//
                        print("access denied -------->>>>>se")
//                        self.alertCameraAccessNeeded()

                        let status = UserDefaults.standard.bool(forKey: "isFromBackfround")
                        print(status)

                        let statusLogout = UserDefaults.standard.bool(forKey: "isFromLogout")
                        print(statusLogout)

                        let staturRemember = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromBackGround)
                        print(staturRemember)




                        if staturRemember == true
                        {


                            let refreshAlert = UIAlertController(title: "Luvo", message: "You Need to change the Camera Permission to measure Heart Rate ", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                  print("Handle Ok logic here")

                                let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
                            }))

                            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                  print("Handle Cancel Logic here")
                            }))

                            self.present(refreshAlert, animated: true, completion: nil)
                        }
//
                        UserDefaults.standard.set(true, forKey: "isDenied")

                        self.timer.invalidate()
                       self.deinitCaptureSession()


                        self.resetAllData()



                    }
                })
            }
//           // self.setupPulse()
//        }
        
//        self.setupGUI()
//        self.setupPulse()
    }
    
    func alertCameraAccessNeeded() {
    //    let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!

//        let alert = UIAlertController(
//             title: "Need Camera Access",
//             message: "Camera access is required to make full use of this app.",
//             preferredStyle: UIAlertController.Style.alert
//         )
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
//            //UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
//        }))
//
//        present(alert, animated: true, completion: nil)
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imgHeartMiddle.layer.removeAllAnimations()
        self.timer.invalidate()
        deinitCaptureSession()
        
        //------
        self.resetAllData()
        
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
    
    //MARK: - Setup GUI
    fileprivate func setupGUI() {
        //Show initial alert for heart rate usage
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.HeartRateDetectionMsg)
        
        btnMeasure.backgroundColor = UIColor.colorSetup()
        viewHeartMiddle.backgroundColor = UIColor.colorSetup()
        imgHeartMiddle.tintColor = UIColor.white
        lblBpm.textColor = UIColor.colorSetup()
        lblMin.textColor = UIColor.colorSetup()
        lblMax.textColor = UIColor.colorSetup()
        lblAvg.textColor = UIColor.colorSetup()
        progrssBar.progressTintColor = UIColor.colorSetup()
        progrssBar.progress = 0.0
    }
    
//    fileprivate func setupImgAnimation() {
//        let pulse = CASpringAnimation(keyPath: "transform.scale")
//            pulse.duration = 0.4
//            pulse.fromValue = 1.0
//            pulse.toValue = 1.02
//            pulse.autoreverses = true
//            pulse.repeatCount = .infinity
//            pulse.initialVelocity = 0.5
//            pulse.damping = 0.8
//            imgHeartMiddle.layer.add(pulse, forKey: nil)
//    }
    //-----------------------------
    //MARK: - Setup Pulse
    fileprivate func setupPulse() {
        self.lblHeartRateLive.text = ""
        self.lblHeartRateAvg.attributedText = self.attributedText(myString: "")
        self.lblHeartRateMax.attributedText = self.attributedText(myString: "")
        self.lblHeartRateMin.attributedText = self.attributedText(myString: "")
        
        previewLayer.layer.cornerRadius = 5.0
        previewLayer.layer.masksToBounds = true
        
        initVideoCapture()
        thresholdLabel.text = BPMMessage.cover
    }
    // MARK: - Frames Capture Methods
    private func initVideoCapture() {
        let specs = VideoSpec(fps: 30, size: CGSize(width: 300, height: 300))
        heartRateManager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: previewLayer.layer)
        heartRateManager.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.handle(buffer: imageBuffer)
        }
        initCaptureSession()
    }
    // MARK: - AVCaptureSession Helpers
    private func initCaptureSession() {
        heartRateManager.startCapture()
    }
    private func deinitCaptureSession() {
        
        let status = UserDefaults.standard.bool(forKey: "isDenied")
        print(status)
        
        
        if status == true
        {
            
        }else
        {
            heartRateManager.stopCapture()
            toggleTorch(status: false)
        }
       
    }
    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
    
    // MARK: - Measurement
    private func startMeasurement() {
        print("------->HEART RATE")
//        //Timer detect 1 min heart rate record (Remove if not required)
//        let duration: Double = 60 //1 * 60   //1 min
//        timerDetect.invalidate() //cancels it if already running
//        timerDetect = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(saveHeartRateData), userInfo: nil, repeats: true)
        
        //-------------------------------
   //     DispatchQueue.main.async {
            self.toggleTorch(status: true)
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                guard let self = self else { return }
                let average = self.pulseDetector.getAverage()
                print("AVERAGE---->\(average)")
                let pulse = 60.0/average
                if pulse == -60 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.lblHeartRateLive.alpha = 0
                    }) { (finished) in
                        self.lblHeartRateLive.isHidden = finished
//                        if self.progressValue < 0.9 {
//                            self.progressValue += 0.1
//                            self.progrssBar.progress = self.progressValue
//                        }
                    }
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.lblHeartRateLive.alpha = 1.0
                    }) { (_) in
                        if self.progressValue < 1.0 {
                            self.progressValue += 0.1
                            self.progrssBar.progress = self.progressValue
                        }
                        
                        self.lblHeartRateLive.isHidden = false
//                        self.lblHeartRateLive.text = "\(lroundf(pulse))"
                    }
                    
                    //Get avg heart rate
                    ///Store all bpmCountLimit bpm value into an array
                    if self.arrayAvg.count < self.bpmCountLimit {    //15 values or you can say 15 sec
                        self.arrayAvg.append(Int(pulse))
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            //Clear
                            self.deinitCaptureSession()
                            self.progressValue = 1.0
                            self.progrssBar.progress = self.progressValue
                            
                            //Get Max & Min
                            self.getMaxMin()
                        })
                    }
                }
            })
        }
  //  }
    //----------------------------------------
    
    fileprivate func attributedText(myString: String?) -> NSMutableAttributedString {
        let myAttribute1 = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 20.0)!,
                            NSAttributedString.Key.foregroundColor: UIColor.gray]
        let myString1 = NSMutableAttributedString(string: "bpm", attributes: myAttribute1 )
        
        //Target Goal
        if let mystring = myString {
            let attrString1 = NSMutableAttributedString(string: "\(mystring)")
            attrString1.append(myString1)
            return attrString1
        }
        return myString1
    }
    
    //Get Max & Min
    private func getMaxMin() {
        ///Get the max value and min value from the array and also calculate average values from all the bpmCountLimit values
        guard let maxBpm = self.arrayAvg.max() else { return }
        guard let minBpm = self.arrayAvg.min() else { return }
        var totalAvg = 0
        
        for item in self.arrayAvg {
            totalAvg += item
        }
        totalAvg = totalAvg / self.arrayAvg.count
        
        self.lblHeartRateLive.text = "\(totalAvg)"
        self.lblHeartRateMin.attributedText = self.attributedText(myString: "\(minBpm)")
        self.lblHeartRateMax.attributedText = self.attributedText(myString: "\(maxBpm)")
        self.lblHeartRateAvg.attributedText = self.attributedText(myString: "\(totalAvg)")
        
        //API Call
        self.postHeartData(minVal: minBpm, maxVal: maxBpm, avgVal: totalAvg)
        //Reset
        self.resetAllData()
    }
    
    //Reset all data
    func resetAllData() {
        DispatchQueue.main.async {
            self.validFrameCounter = 0
            self.measurementStartedFlag = false
            self.pulseDetector.reset()
            self.timer.invalidate()
            self.progrssBar.progress = 0.0
            self.progressValue = 0.0
//            self.timerDetect.invalidate()
            self.timerAvg.invalidate()
            self.arrayAvg.removeAll()
            self.thresholdLabel.text = ""
        }
    }
    
    //MARK: - Button func
    @IBAction func btnStat(_ sender: Any) {
        let heartStatVC = ConstantStoryboard.heartRateStoryboard.instantiateViewController(withIdentifier: "HeartRateStatsViewController") as! HeartRateStatsViewController
        navigationController?.pushViewController(heartStatVC, animated: true)
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

//MARK: - Handle Image Buffer
extension HeartRateMeasureViewController {
    fileprivate func handle(buffer: CMSampleBuffer) {
        var redmean:CGFloat = 0.0;
        var greenmean:CGFloat = 0.0;
        var bluemean:CGFloat = 0.0;
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)

        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage",
                              parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!

        let ctx = CIContext(options:nil)
        let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!
        
        let rawData:NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
        var BGRA_index = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch BGRA_index {
            case 0:
                bluemean = CGFloat (pixel)
            case 1:
                greenmean = CGFloat (pixel)
            case 2:
                redmean = CGFloat (pixel)
            case 3:
                break
            default:
                break
            }
            BGRA_index += 1
        }
        
        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
        // Do a sanity check to see if a finger is placed over the camera
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            DispatchQueue.main.async {
                self.thresholdLabel.text = BPMMessage.hold
                self.toggleTorch(status: true)
                if !self.measurementStartedFlag {
                    self.startMeasurement()
                    self.measurementStartedFlag = true
                    
                }
            }
            validFrameCounter += 1
            inputs.append(hsv.0)
            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
            let filtered = hueFilter.processValue(value: Double(hsv.0))
            if validFrameCounter > 60 {
                self.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
            }
        } else {
            validFrameCounter = 0
            measurementStartedFlag = false
            pulseDetector.reset()
            self.timer.invalidate()
            
            self.resetAllData()
            
            DispatchQueue.main.async {
                self.thresholdLabel.text = BPMMessage.cover
            }
        }
    }
}

extension HeartRateMeasureViewController: HeartDataPostDelegate {
    private func postHeartData(minVal: Int, maxVal: Int, avgVal: Int) {
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
            ///If let to check min max avg  values here then call api
            let request = HeartRateRequest(min: "\(minVal)", max: "\(maxVal)", avg: "\(avgVal)")
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            heartViewModel.postHeartRateData(heartDataRequest: request, token: token)
        }
    }
    
    func didReceiveHeartPostDataResponse(heartPostDataResponse: HeartRateResponse?) {
        self.view.stopActivityIndicator()
        
        if(heartPostDataResponse?.status != nil && heartPostDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterGoalDataResponse)
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: heartPostDataResponse?.message ?? ConstantStatusAPI.success)
           
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: heartPostDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveHeartPostDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
