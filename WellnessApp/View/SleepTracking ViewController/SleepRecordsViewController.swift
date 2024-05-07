//
//  SleepRecordsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/02/22.
//

import UIKit
import Charts
import AVFoundation

class SleepRecordsViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var btnCalender: UIButton!
    @IBOutlet var lblDateToday: UILabel!
    @IBOutlet var btnRecords: UIBUtton_Designable!
    @IBOutlet var btnToday: UIBUtton_Designable!
    @IBOutlet var btnWeekly: UIBUtton_Designable!
    @IBOutlet var btnMonthly: UIBUtton_Designable!
    @IBOutlet var btnYearly: UIBUtton_Designable!
    
    @IBOutlet var lblChart: UILabel!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var circularProgressAwake: CircularProgressView!
    @IBOutlet var circularProgressLight: CircularProgressView!
    @IBOutlet var circularProgressDeep: CircularProgressView!
    @IBOutlet var circularProgressREM: CircularProgressView!
    @IBOutlet var circularProgressUndetected: CircularProgressView!
    @IBOutlet var lblPercentAwake: UILabel!
    @IBOutlet var lblPercentLight: UILabel!
    @IBOutlet var lblPercentDeep: UILabel!
    @IBOutlet var lblPercentREM: UILabel!
    @IBOutlet var lblPercentUndetected: UILabel!
    @IBOutlet var lblDurationAwake: UILabel!
    @IBOutlet var lblDurationLight: UILabel!
    @IBOutlet var lblDurationDeep: UILabel!
    @IBOutlet var lblDurationREM: UILabel!
    @IBOutlet var lblDurationUndetected: UILabel!
    @IBOutlet var viewDurationBottom: UIView_Designable!
    @IBOutlet var lblDurationTotal: UILabel!
    @IBOutlet var lblSleepAt: UILabel!
    @IBOutlet var lblWakeAt: UILabel!
    @IBOutlet var viewChart: UIView!
    @IBOutlet var viewAudioPlayer: UIView!
    @IBOutlet var lblAudioTitle: UILabel!
    @IBOutlet var imgAudioLogo: UIImageView!
    
    var barChartView: BarChartView = BarChartView()
    
    //AVPlayer
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var playbackSlider: UISlider!
    var player:AVPlayer?
//    var timeObserver: Any?
    
    //Hidden View
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnDateDone: UIButton!
    
    var sleepVM = SleepViewModel()
    var statData: SleepReport?
    
    var startDate = ""
    var endDate = ""
    
    //Chart
    var yValue: [BarChartDataEntry]?
    var yBarColor: [UIColor]?
    var labelValue:[String]?
    
    //Sleep Type Color
    private enum SleepTypeColor: String {
        case awake      = "#E4D509"
        case light      = "#2299E8"
        case deep       = "#8A57F2"
        case REM        = "#ED6CED"
        case undetected = "#EB7171"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()

        sleepVM.sleepStatDelegate = self
        
        datePicker.timeZone = TimeZone.current
        datePicker.date = Date()
        hideViewHidden()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SleepRecordsViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)

        setupNotificationBadge()
        //------------------------
        
        setupGUI()
                
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())

        getStatData(startDate: startDate, endDate: endDate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
        
        //-------------------------------------------
        //Date
        datePicker.date = Date()
        
        //Audio Player
        if let player = player {
            player.pause()
//            removePeriodicTimeObserver()
            self.player = nil
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
//    fileprivate func removePeriodicTimeObserver() {
//        // If a time observer exists, remove it
//        if let observer = timeObserver {
//            player?.removeTimeObserver(observer)
//            timeObserver = nil
//        }
//    }
    
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
    
    //MARK: - Nav Button Func -----------------
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    //MARK: Setup GUI -----------------------------------
    private func setupGUI() {
        btnRecords.backgroundColor = UIColor.colorSetup()
        
        btnCalender.tintColor = UIColor.colorSetup()
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        
        //Initial button setup
        btnToday.backgroundColor = UIColor.colorSetup()
        btnToday.setTitleColor(UIColor.white, for: .normal)

        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)

        btnMonthly.backgroundColor = UIColor.white
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)

        btnYearly.backgroundColor = UIColor.white
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        //Circular Progress Bar Setup
        circularProgressAwake.trackClr = UIColor.darkGray
        circularProgressAwake.progressClr = UIColor(hexString: SleepTypeColor.awake.rawValue)
        
        //Circular Progress Bar Setup
        circularProgressLight.trackClr = UIColor.darkGray
        circularProgressLight.progressClr = UIColor(hexString: SleepTypeColor.light.rawValue)
        
        //Circular Progress Bar Setup
        circularProgressDeep.trackClr = UIColor.darkGray
        circularProgressDeep.progressClr = UIColor(hexString: SleepTypeColor.deep.rawValue)
        
        //Circular Progress Bar Setup
        circularProgressREM.trackClr = UIColor.darkGray
        circularProgressREM.progressClr = UIColor(hexString: SleepTypeColor.REM.rawValue)
        
        //Circular Progress Bar Setup
        circularProgressUndetected.trackClr = UIColor.darkGray
        circularProgressUndetected.progressClr = UIColor(hexString: SleepTypeColor.undetected.rawValue)
        
        //
        self.viewDurationBottom.backgroundColor = UIColor.colorSetup()
        
      //  self.imgAudioLogo.tintColor = UIColor.colorSetup()
        
        //Audio Player
     //   self.viewAudioPlayer.layer.cornerRadius = 10.0
    //    self.viewAudioPlayer.layer.borderWidth = 2
    //    self.viewAudioPlayer.layer.borderColor = UIColor.colorSetup().cgColor
    //    self.lblAudioTitle.textColor = UIColor.colorSetup()
     //   self.btnPlay.tintColor = UIColor.colorSetup()
     //   self.loadingView.isHidden = true
        ///Audio Slider Disable
//        playbackSlider.isUserInteractionEnabled = false
//        playbackSlider.tintColor = UIColor.colorSetup()
        
        setupChart()
    }
    
    private func setupChart() {
        //Chart View Setup
        viewChart.addSubview(barChartView)
        
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.widthAnchor.constraint(equalToConstant: viewChart.frame.width).isActive = true
        barChartView.heightAnchor.constraint(equalToConstant: viewChart.frame.height).isActive = true
        barChartView.centerXAnchor.constraint(equalTo: viewChart.centerXAnchor).isActive = true
        barChartView.centerYAnchor.constraint(equalTo: viewChart.centerYAnchor).isActive = true
        
        barChartView.backgroundColor = .white
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.animate(xAxisDuration: 3, yAxisDuration: 3)
        
//        //XYMarkerView Daniel Gindi Charts - Charts/ChartsDemo-iOS/Objective-C/Components/
//        let marker = BalloonMarker(color: UIColor.colorSetup(),
//                                   font: .systemFont(ofSize: 12),
//                                   textColor: .white,
//                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
//        marker.chartView = lineChartView
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        lineChartView.marker = marker
        
        barChartView.xAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
//        barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
//        barChartView.xAxis.setLabelCount(5, force: false)
//        barChartView.xAxis.labelTextColor = UIColor.colorSetup()
        barChartView.xAxis.drawGridLinesEnabled = false
//        barChartView.chartDescription.enabled = false
        barChartView.dragEnabled = true
        barChartView.setScaleEnabled(true)
        barChartView.pinchZoomEnabled = true
        
        barChartView.delegate = self
        
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.maxVisibleCount = 60
        barChartView.legend.enabled = false
        barChartView.zoom(scaleX: 15, scaleY: 0, x: 0, y: 0)
        
//        let l = barChartView.legend
//        l.horizontalAlignment = .left
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
//        l.form = .circle
//        l.formSize = 9
//        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
//        l.xEntrySpace = 4
////        barChartView.legend = l
    }
    
    //MARK: Button Func --------------------------
    @IBAction func btnCalender(_ sender: Any) {
        showViewHidden()
    }
    
    @IBAction func btnDatePrev(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatdate = dateFormatter.date(from: endDate)
        
        var dayComponent = DateComponents()
        dayComponent.day = -1 // For adding one day (tomorrow): 1
        let theCalendar = Calendar.current.date(byAdding: dayComponent, to: formatdate!)
        
        let prevDateString = dateFormatter.string(from: theCalendar!)
        let prevDate = dateFormatter.date(from: prevDateString)
        print("prevDate : \(prevDate)")
        
        lblDateToday.text = "\(setupDateLabel(date: prevDate!))"
        
        startDate = prevDateString
        endDate = prevDateString
        
        getStatData(startDate: startDate, endDate: endDate)
        
        //Clear button selection color
        ClearButtonColor()
    }
    
    @IBAction func btnDateNext(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatdate = dateFormatter.date(from: endDate)
        
        var dayComponent = DateComponents()
        dayComponent.day = 1 // For adding one day (tomorrow): 1
        let theCalendar = Calendar.current.date(byAdding: dayComponent, to: formatdate!)
        
        let nextDateString = dateFormatter.string(from: theCalendar!)
        let nextDate = dateFormatter.date(from: nextDateString)
        print("nextDate : \(nextDate)")
        
        lblDateToday.text = "\(setupDateLabel(date: nextDate!))"
        
        startDate = nextDateString
        endDate = nextDateString
        
        getStatData(startDate: startDate, endDate: endDate)
        
        //Clear button selection color
        ClearButtonColor()
    }
    
    @IBAction func btnDateDone(_ sender: Any) {
        hideViewHidden()
        
        print(Date().formatDate(date: self.datePicker.date))
        lblDateToday.text = "\(setupDateLabel(date: datePicker.date))"
        self.viewDurationBottom.isHidden = false
        self.viewAudioPlayer.isHidden = false
        
        ClearButtonColor()
        
        startDate = Date().formatDate(date: self.datePicker.date)
        endDate = Date().formatDate(date: self.datePicker.date)
        
        getStatData(startDate: startDate, endDate: endDate)
    }
    
    func ClearButtonColor() {
        //Clear button selection color
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
    }
    
    @IBAction func btnSleep(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnToday(_ sender: Any) {
        btnToday.backgroundColor = UIColor.colorSetup()
        btnToday.setTitleColor(.white, for: .normal)
        
        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.white
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.white
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        self.viewDurationBottom.isHidden = false
        self.viewAudioPlayer.isHidden = false
        datePicker.date = Date()
        
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
    }
    
    @IBAction func btnWeekly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.white
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.colorSetup()
        btnWeekly.setTitleColor(.white, for: .normal)
        
        btnMonthly.backgroundColor = UIColor.white
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.white
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        self.viewDurationBottom.isHidden = true
        self.viewAudioPlayer.isHidden = true
        datePicker.date = Date()
        
        startDate = Date().formatDate(date: Date.sevenDayPrevious)
        endDate = Date().formatDate(date: Date())

        getStatData(startDate: startDate, endDate: endDate)
    }
    
    @IBAction func btnMonthly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.white
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.colorSetup()
        btnMonthly.setTitleColor(.white, for: .normal)
        
        btnYearly.backgroundColor = UIColor.white
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        self.viewDurationBottom.isHidden = true
        self.viewAudioPlayer.isHidden = true
        datePicker.date = Date()
        
        startDate = Date().formatDate(date: Date.oneMonthPrevious)
        endDate = Date().formatDate(date: Date())

        getStatData(startDate: startDate, endDate: endDate)
    }
    
    @IBAction func btnYearly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.white
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.white
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.colorSetup()
        btnYearly.setTitleColor(.white, for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        self.viewDurationBottom.isHidden = true
        self.viewAudioPlayer.isHidden = true
        datePicker.date = Date()
        
        startDate = Date().formatDate(date: Date.oneYearPrevious)
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
    }
    
    //MARK: Hidden View ----------------------
    func hideViewHidden() {
        viewHidden.isHidden = true
        viewHidden.alpha = 0.0
    }
    
    func showViewHidden() {
        viewHidden.isHidden = false
        viewHidden.alpha = 1.0
    }
    
    //MARK: Get Stat Data --------------------
    private func getStatData(startDate: String, endDate: String) {
        print("Start date--->\(startDate) End date--->\(endDate)")
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
            
            //, device_cat: "watch"
           // let requestt = SleepStatRequest(startDate: startDate, endDate: endDate)
            let requestt = SleepStatRequest(startDate: startDate, endDate: endDate, device_cat: "mobile")
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            sleepVM.postGetSleepStat(sleepStatRequest: requestt, token: token)
        }
    }
    
    //MARK: - Refresh Data
    fileprivate func refreshData() {
        guard let sleepAt       = statData?.Sleep_At,
        let wakeAt              = statData?.Wake_At else { return }
        
        if self.viewDurationBottom.isHidden {
            self.lblStartTime.text  = "\(self.startDate)"
            self.lblEndTime.text    = "\(self.endDate)"
        } else {
            self.lblStartTime.text  = dateTimeToTime(sleepAt)
            self.lblEndTime.text    = dateTimeToTime(wakeAt)
        }
        
        //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        guard let awakeValue        = statData?.Awake_percentage,
              let lightValue        = statData?.Light_percentage,
              let deepValue         = statData?.Deep_percentage,
              let remValue          = statData?.REM_percentage,
              let undetectedValue   = statData?.Undetected_percentage else { return }
        
        let stringToFloatAwake      = Float(awakeValue)
        let stringToFloatLight      = Float(lightValue)
        let stringToFloatDeep       = Float(deepValue)
        let stringToFloatREM        = Float(remValue)
        let stringToFloatUndetected = Float(undetectedValue)
        
        ///Double %% in string format bacuse to print single %
        self.lblPercentAwake.text       = String(format: "%.2f%%", stringToFloatAwake!)       //"\(awakeValue)%"
        self.lblPercentLight.text       = String(format: "%.2f%%", stringToFloatLight!)       //"\(lightValue)%"
        self.lblPercentDeep.text        = String(format: "%.2f%%", stringToFloatDeep!)        //"\(deepValue)%"
        self.lblPercentREM.text         = String(format: "%.2f%%", stringToFloatREM!)         //"\(remValue)%"
        self.lblPercentUndetected.text  = String(format: "%.2f%%", stringToFloatUndetected!)  //"\(undetectedValue)%"
        
        ///Value / 100 because progress bar range from 0 - 1
        self.circularProgressAwake.setProgressWithAnimation(duration: 3.0, value: Float(awakeValue)!/100)
        self.circularProgressLight.setProgressWithAnimation(duration: 3.0, value: Float(lightValue)!/100)
        self.circularProgressDeep.setProgressWithAnimation(duration: 3.0, value: Float(deepValue)!/100)
        self.circularProgressREM.setProgressWithAnimation(duration: 3.0, value: Float(remValue)!/100)
        self.circularProgressUndetected.setProgressWithAnimation(duration: 3.0, value: Float(undetectedValue)!/100)
        
        //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
        guard let awakeTime         = statData?.Awake_duration,
              let lightTime         = statData?.Light_duration,
              let deepTime          = statData?.Deep_duration,
              let remTime           = statData?.REM_duration,
              let undetectedTime    = statData?.Undetected_duration else { return }
        
        let (awakeHour, awakeMinute, awakeSecond)                   = Date().convertSecondsToHourMinutesSecond(awakeTime)
        let (lightHour, lightMinute, lightSecond)                   = Date().convertSecondsToHourMinutesSecond(lightTime)
        let (deepHour, deepMinute, deepSecond)                      = Date().convertSecondsToHourMinutesSecond(deepTime)
        let (remHour, remMinute, remSecond)                         = Date().convertSecondsToHourMinutesSecond(remTime)
        let (undetectedHour, undetectedMinute, undetectedSecond)    = Date().convertSecondsToHourMinutesSecond(undetectedTime)
        
        self.lblDurationAwake.text      = String(format: "%ih %im %is", awakeHour, awakeMinute, awakeSecond)
        self.lblDurationLight.text      = String(format: "%ih %im %is", lightHour, lightMinute, lightSecond)
        self.lblDurationDeep.text       = String(format: "%ih %im %is", deepHour, deepMinute, deepSecond)
        self.lblDurationREM.text        = String(format: "%ih %im %is", remHour, remMinute, remSecond)
        self.lblDurationUndetected.text = String(format: "%ih %im %is", undetectedHour, undetectedMinute, undetectedSecond)
        
        //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        guard let totalDuration = statData?.Session_duration else { return }
        
        let (totHour, totMinute, totSecond) = Date().convertSecondsToHourMinutesSecond(totalDuration)
        self.lblDurationTotal.text  = String(format: "%ih %imin", totHour, totMinute)
        self.lblSleepAt.text        = dateTimeToTime(sleepAt)
        self.lblWakeAt.text         = dateTimeToTime(wakeAt)
        
        ///Audio Player-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=
        guard let audioPath = statData?.music_file else {
       //     self.lblAudioTitle.text = nil
//            self.loadingView.isHidden = true
            //Audio Player
            if let player = player {
                player.pause()
//                removePeriodicTimeObserver()
                self.player = nil
            }
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            return
        }
        self.setupPlayer(withMediaPath: audioPath)
       // self.lblAudioTitle.text = String(format: "Recorded on %@", SleepDateFormatter(date: sleepAt))
       // Luvo will access your microphone to record ambient noise during sleep tracking.
    }
    
    private func dateTimeToTime(_ time: String) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFromString = dateFormatter.date(from: time)

        dateFormatter.dateFormat = "hh:mm aa"
        guard let stringDate = dateFromString else { return ""}
        return dateFormatter.string(from: stringDate)
        
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
////        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
////       // dateFormatter.timeZone = TimeZone.current
////
////        let dateFromString = dateFormatter.date(from: time)
////        dateFormatter.timeZone = TimeZone.current
////        dateFormatter.dateFormat = "hh:mm aa"
////        guard let stringDate = dateFromString else { return ""}
////        return dateFormatter.string(from: stringDate)
//
//        let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "H:mm:ss"
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//            if let date = dateFormatter.date(from: time) {
//                dateFormatter.timeZone = TimeZone.current
//                dateFormatter.dateFormat = "h:mm a"
//
//                return dateFormatter.string(from: date)
//          //  }
//            //return nil
    }
    
    private func SleepDateFormatter(date: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeZone = TimeZone.current
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFromString = dateFormatter1.date(from: date)!
        dateFormatter1.dateFormat = "dd MMM, yyyy hh:mm aa"
        let stringFromDate = dateFormatter1.string(from: dateFromString)
        return stringFromDate
    }
    
    //MARK: - Refresh graph
    fileprivate func refreshGraph() {
        //Clear the previous array data
        yValue = [BarChartDataEntry]()
        yBarColor = [UIColor]()
        labelValue = [String]()
        
        if let arrChartValue = statData?.result {
            var loopCount = 0.0
            for item in arrChartValue {
                if let _dataPoint = item.datapoint {
                    yValue?.append(BarChartDataEntry(x: loopCount, y: Double(_dataPoint))) //ChartDataEntry(x: loopCount, y: Double(_dataPoint))
                    loopCount += 1.0
                }
                if let sleepType = item.summary {
                    yBarColor?.append(setColor(sleepType))
                    loopCount += 1.0
                }
            }
        }
        
        setChartData(label: "Luvo")
//        chartView.setNeedsDisplay()
    }
    
    private func setChartData(label: String) {
        guard let yValue = yValue, let yBarColor = yBarColor else { return }
        
        var set1: BarChartDataSet! = nil
        
        set1 = BarChartDataSet(entries: yValue, label: label)
        set1.colors = yBarColor //[setColor("Awake"), setColor("Light_sleep"), setColor("Deep_sleep")] //ChartColorTemplates.material()
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        barChartView.data = data
    }
    
    private func setColor(_ value: String) -> UIColor{
        enum SleepType: String {
            case Awake          = "Awake"
            case Light_sleep    = "Light_sleep"
            case Deep_sleep     = "Deep_sleep"
            case REM            = "REM"
            case Undetected     = "Undetected"
        }
        
        switch value {
        case SleepType.Awake.rawValue:
            return UIColor(hexString: SleepTypeColor.awake.rawValue)
        case SleepType.Light_sleep.rawValue:
            return UIColor(hexString: SleepTypeColor.light.rawValue)
        case SleepType.Deep_sleep.rawValue:
            return UIColor(hexString: SleepTypeColor.deep.rawValue)
        case SleepType.REM.rawValue:
            return UIColor(hexString: SleepTypeColor.REM.rawValue)
        case SleepType.Undetected.rawValue:
            return UIColor(hexString: SleepTypeColor.undetected.rawValue)
        default:
            return UIColor.colorSetup()
        }
    }
    
    fileprivate func clearGraph() {
        //Reset graph
        self.barChartView.data = nil
    }
    
    private func clearData() {
        self.lblStartTime.text  = "0"
        self.lblEndTime.text    = "0"
        
        //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        self.lblPercentAwake.text       = "0%"
        self.lblPercentLight.text       = "0%"
        self.lblPercentDeep.text        = "0%"
        self.lblPercentREM.text         = "0%"
        self.lblPercentUndetected.text  = "0%"
        
        ///Value / 100 because progress bar range from 0 - 1
        self.circularProgressAwake.setProgressWithAnimation(duration: 3.0, value: 0/100)
        self.circularProgressLight.setProgressWithAnimation(duration: 3.0, value: 0/100)
        self.circularProgressDeep.setProgressWithAnimation(duration: 3.0, value: 0/100)
        self.circularProgressREM.setProgressWithAnimation(duration: 3.0, value: 0/100)
        self.circularProgressUndetected.setProgressWithAnimation(duration: 3.0, value: 0/100)
        
        //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
        self.lblDurationAwake.text      = "0"
        self.lblDurationLight.text      = "0"
        self.lblDurationDeep.text       = "0"
        self.lblDurationREM.text        = "0"
        self.lblDurationUndetected.text = "0"
        
        //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        self.lblDurationTotal.text  = "0"
        self.lblSleepAt.text        = "0"
        self.lblWakeAt.text         = "0"
    }
    
    //MARK: - Date Formatter
    private func setupDateLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let formatDate = dateFormatter.string(from: date)
        return formatDate
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
        print("Sleep Stat BADGE COUNT-----\(badgeCount)")
    }
    
}

extension SleepRecordsViewController: LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        print(yValues)
        lblChart.text = "State: \(yValues)"
    }
}

extension SleepRecordsViewController {
    func setupPlayer(withMediaPath: String) {
        //"http://beas.in:5000/music-1647320218414.mp3"
        //"http://beas.in:5000/music-1647310363635.mp3"
        //"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"
        //"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3"
        //"https://luvo.s3.us-east-2.amazonaws.com/uploads/musics/music-1638000779365.mp3"
        //let finalPath = "http%3A%2F%2Fbeas.in%3A5000%2Fmusic-1647320218414.mp3"
        
        let finalPath = Common.WebserviceAPI.baseURL+withMediaPath
        
//        guard let urlString = finalPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = URL.init(string: finalPath)!
        print("Audio DATA------\(finalPath)")
        
        if AVURLAsset.init(url: urlString).isPlayable {
            print("Audio DATA------Playable")
            
            let playerItem:AVPlayerItem = AVPlayerItem.init(url: urlString)
            player = AVPlayer.init(playerItem: playerItem)

            NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            
//            // Add playback slider
//            guard playerItem.duration >= .zero, !playerItem.duration.seconds.isNaN else {
//                return
//            }
//
//            playbackSlider.minimumValue = 0
//            playbackSlider.addTarget(self, action: #selector(FullAudioPlayerViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
//
//            let newDurationSeconds = Float(playerItem.duration.seconds)
//
//            let duration : CMTime = playerItem.asset.duration
//            let seconds : Float64 = CMTimeGetSeconds(duration)
//
//            playbackSlider.maximumValue = Float(newDurationSeconds)
//            playbackSlider.isContinuous = true

            //Track playback status
//            self.timeObserver = player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) {[weak self] (CMTime) -> Void in
//                guard let self = self else { return }
//                if self.player!.currentItem?.status == .readyToPlay {
//                    //Do your time duration text, playback slider setup here
//                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
//                    self.playbackSlider.value = Float ( time )
//                }
//
//                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
//                if playbackLikelyToKeepUp == false{
//    //                print("IsBuffering")
//                    self.btnPlay.isHidden = true
//                    self.loadingView.isHidden = false
//                } else {
//    //                print("Buffering completed")
//                    self.btnPlay.isHidden = false
//                    self.loadingView.isHidden = true
//                }
//            }

    //        //Autoplay at initial
    //        player?.play()
    //        self.btnPlay.isHidden = true
    //        btnPlay.setImage(UIImage(named: "ic_orchadio_stop"), for: UIControl.State.normal)
        
        
        } else {
            print("Audio not playable------------------------>")
        }
    }
    
    @IBAction func ButtonPlay(_ sender: Any) {
        print("play Button")
        if player == nil { return }
        if player?.rate == 0 {
            player!.play()
//            self.btnPlay.isHidden = true
//            self.loadingView.isHidden = false
            btnPlay.setImage(UIImage(named: "ic_orchadio_stop"), for: UIControl.State.normal)

        } else {
            player!.pause()
            player?.seek(to: CMTime.zero)
            btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
        }
    }
    
//    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
//        if player == nil { return }
//        let seconds : Int64 = Int64(playbackSlider.value)
//        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
//
//        player!.seek(to: targetTime)
//
//        if player!.rate == 0 {
//            player?.play()
//        }
//    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
//        playbackSlider.value = 0.0
        player?.seek(to: CMTime.zero)
        btnPlay.setImage(UIImage(named: "ic_orchadio_play"), for: UIControl.State.normal)
    }
}

extension SleepRecordsViewController: SleepStatDelegate {
    func didReceiveSleepStatDataResponse(sleepStatDataResponse: SleepStatResponse?) {
        self.view.stopActivityIndicator()
        
        if(sleepStatDataResponse?.status != nil && sleepStatDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)
            statData = sleepStatDataResponse?.report
            debugPrint(statData!)
            
            if let data = statData?.result {
                if data.count != 0 {
                    //Refresh graph data
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) { [weak self] in
//                        guard let self = self else { return }
                        self.refreshGraph()
                        //Refresh general data
                        self.refreshData()
//                    }
                } else {
                    
                    self.refreshData()
                    self.refreshGraph()
//                    self.clearGraph()
//                    self.clearData()
//                    showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
                }
            } else {
                self.clearGraph()
                self.clearData()
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "No data found. Your (if submitted) sleep data analysis is under process and the result will be available within 5 minutes")
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveSleepStatDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension SleepRecordsViewController: ChartViewDelegate {
    // TODO: Cannot override from extensions
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}
