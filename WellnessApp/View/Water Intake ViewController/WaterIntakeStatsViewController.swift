//
//  WaterIntakeStatsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 23/11/21.
//

import UIKit
import MSBBarChart

fileprivate struct ConstantChartLabel {
    static let today    = "Today"
    static let weekly   = "Weekly"
    static let monthly  = "Monthly"
    static let yearly   = "Yearly"
}

class WaterIntakeStatsViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var lblDateToday: UILabel!
    @IBOutlet var btnCalender: UIButton!
    @IBOutlet var btnToday: UIBUtton_Designable!
    @IBOutlet var btnWeekly: UIBUtton_Designable!
    @IBOutlet var btnMonthly: UIBUtton_Designable!
    @IBOutlet var btnYearly: UIBUtton_Designable!
    @IBOutlet var lblTagetGoal: UILabel!
    @IBOutlet var lblTagetGoalValue: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lblTimeQuantity: UILabel!
    @IBOutlet var lblQty0: UILabel!
    @IBOutlet var lblTime0: UILabel!
    @IBOutlet var lblQty1: UILabel!
    @IBOutlet var lblTime1: UILabel!
    @IBOutlet var lblQty2: UILabel!
    @IBOutlet var lblTime2: UILabel!
    @IBOutlet var lblQty3: UILabel!
    @IBOutlet var lblTime3: UILabel!
    @IBOutlet var lblQty4: UILabel!
    @IBOutlet var lblTime4: UILabel!
    @IBOutlet var btnAddIntake: UIButton!
    @IBOutlet var lblAchievedGoal: UILabel!
    @IBOutlet var lblAchievedGoalValue: UILabel!
    @IBOutlet var btnSetReminder: UIBUtton_Designable!
    @IBOutlet var imgClock1: UIImageView!
    @IBOutlet var imgClock2: UIImageView!
    @IBOutlet var lblTimeToTime: UILabel!
    @IBOutlet var imgCheck: UIImageView!
    @IBOutlet weak var viewChart: MSBBarChartView!
    @IBOutlet var viewAddReminderGrey: UIView!
    @IBOutlet var viewTimeToTime: UIView!
    @IBOutlet var viewAcheivment: UIView_Designable!
    @IBOutlet var imgVAcheivment: UIImageView!
    @IBOutlet var lblPoints: UILabel!
    
    var startDate = ""
    var endDate = ""
    var xLabel = ""
    
    var waterStatVM = WaterViewModel()
    var statData: WaterStatResponse?
    
    
    //Chart
    var chartLabel = ""
    var labelValue:[String]?
    var yValue: [Int]?
    
    //Hidden View
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnDateDone: UIButton!
    
//    var fromHome: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        waterStatVM.waterStatDelegate = self
        
        datePicker.timeZone = TimeZone.current
        datePicker.date = Date()
        hideViewHidden()
        
        setupGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())
        
//        if let fromHome = fromHome {
//            if fromHome {
//                getStatData(startDate: formatDate(date: Date.yesterday), endDate: formatDate(date: Date.yesterday))
//                chartLabel = ConstantChartLabel.today
//                xLabel = ConstantChartLabel.today
//            } else {
//                getStatData(startDate: formatDate(date: Date()), endDate: formatDate(date: Date()))
//                chartLabel = ConstantChartLabel.today
//                xLabel = ConstantChartLabel.today
//            }
//        } else {
            getStatData(startDate: startDate, endDate: endDate)
            chartLabel = ConstantChartLabel.today
            xLabel = ConstantChartLabel.today
//        }
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
    
    func setupGUI() {
//        if let fromHome = fromHome {
//            if fromHome {
//                lblDateToday.text = "\(setupDateLabel(date: Date.yesterday))"
//            } else {
//                lblDateToday.text = "\(setupDateLabel(date: Date()))"
//            }
//        } else {
            lblDateToday.text = "\(setupDateLabel(date: Date()))"
//        }
        //--------
        datePicker.tintColor = UIColor.colorSetup()
        btnDateDone.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnEdit.backgroundColor = UIColor.colorSetup()
        
        btnCalender.tintColor = UIColor.colorSetup()
        lblDateToday.textColor = UIColor.colorSetup()
        lblTagetGoal.textColor = UIColor.colorSetup()
        lblTimeQuantity.textColor = UIColor.colorSetup()
        btnAddIntake.tintColor = UIColor.colorSetup()
        lblAchievedGoal.textColor = UIColor.colorSetup()
        imgClock1.tintColor = UIColor.colorSetup()
        btnSetReminder.backgroundColor = UIColor.colorSetup()
        imgClock2.tintColor = UIColor.colorSetup()
        lblTimeToTime.textColor = UIColor.colorSetup()
        imgCheck.tintColor = UIColor.colorSetup()
        
        viewAddReminderGrey.isHidden = false
        viewTimeToTime.isHidden = true
        
        //Initial button setup
        btnToday.backgroundColor = UIColor.white
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.white
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.white
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        lblPoints.backgroundColor = UIColor.colorSetup()
        lblPoints.layer.cornerRadius = 12
        imgVAcheivment.backgroundColor = .white
        imgVAcheivment.layer.cornerRadius = imgVAcheivment.frame.size.width / 2
        
        let tapAcheive = UITapGestureRecognizer.init(target: self, action: #selector(WaterIntakeStatsViewController.tapAcheivement(_:)))
        viewAcheivment.addGestureRecognizer(tapAcheive)
        
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        print("coloris ...--->>>",chakraColour)
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               
               print(crownList)

        
        if chakraColour==0 {
            switch chakraLevel {
            case 1:
                //red
                viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                break
                
            case 2:
                //orange
                viewAcheivment.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 3:
                //yellow
                viewAcheivment.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 4:
                //green
                viewAcheivment.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 5:
                //blue
                viewAcheivment.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
            
            case 6:
                //violet
                viewAcheivment.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 7:
                //purple
                viewAcheivment.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            default:
                //red
                viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
            }
        } else if crownList == 1 {
            switch chakraColour {
            case 1:
                //red
                viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                break
                
            case 2:
                //orange
                viewAcheivment.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 3:
                //yellow
                viewAcheivment.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 4:
                //green
                viewAcheivment.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 5:
                //blue
                viewAcheivment.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
            
            case 6:
                //violet
                viewAcheivment.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 7:
                //purple
                viewAcheivment.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            default:
                //red
                viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
            }
        }
        else{
            
            switch chakraLevel {
            case 1:
                //red
                viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                break
                
            case 2:
                //orange
                viewAcheivment.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 3:
                //yellow
                viewAcheivment.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 4:
                //green
                viewAcheivment.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 5:
                //blue
                viewAcheivment.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
            
            case 6:
                //violet
                viewAcheivment.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            case 7:
                //purple
                viewAcheivment.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
                
            default:
                //red
                viewAcheivment.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                break
            }
            
        }
       
    }
    
    func getStatData(startDate: String, endDate: String) {
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
            let request = WaterStatRequest(startDate: startDate, endDate: endDate)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            waterStatVM.postGetWaterStat(waterStatRequest: request, token: token)
        }
    }
    
    func refreshData() {
        if let arrLastFive = statData?.records {
            if arrLastFive.count > 0 {
                if arrLastFive.count == 1 {
                    if let totwa0 = arrLastFive[0].totalWater, let time0 = arrLastFive[0].add_date {
                        lblQty0.text = "\(totwa0)"
                        lblTime0.text = "\(formatUnixDate(date: time0))"
                    }
                    //Blank the remaining label
                        lblQty1.text = ""
                        lblTime1.text = ""
                        
                        lblQty2.text = ""
                        lblTime2.text = ""
                        
                        lblQty3.text = ""
                        lblTime3.text = ""
                        
                        lblQty4.text = ""
                        lblTime4.text = ""
                }
                if arrLastFive.count == 2 {
                    if let totwa0 = arrLastFive[0].totalWater, let time0 = arrLastFive[0].add_date {
                        lblQty0.text = "\(totwa0)"
                        lblTime0.text = "\(formatUnixDate(date: time0))"
                    }
                    if let totwa1 = arrLastFive[1].totalWater, let time1 = arrLastFive[1].add_date {
                        lblQty1.text = "\(totwa1)"
                        lblTime1.text = "\(formatUnixDate(date: time1))"
                    }
                    //Blank the remaining label
                        lblQty2.text = ""
                        lblTime2.text = ""
                        
                        lblQty3.text = ""
                        lblTime3.text = ""
                        
                        lblQty4.text = ""
                        lblTime4.text = ""
                }
                if arrLastFive.count == 3 {
                    if let totwa0 = arrLastFive[0].totalWater, let time0 = arrLastFive[0].add_date {
                        lblQty0.text = "\(totwa0)"
                        lblTime0.text = "\(formatUnixDate(date: time0))"
                    }
                    if let totwa1 = arrLastFive[1].totalWater, let time1 = arrLastFive[1].add_date {
                        lblQty1.text = "\(totwa1)"
                        lblTime1.text = "\(formatUnixDate(date: time1))"
                    }
                    if let totwa2 = arrLastFive[2].totalWater, let time2 = arrLastFive[2].add_date {
                        lblQty2.text = "\(totwa2)"
                        lblTime2.text = "\(formatUnixDate(date: time2))"
                    }
                    //Blank the remaining label
                        lblQty3.text = ""
                        lblTime3.text = ""
                        
                        lblQty4.text = ""
                        lblTime4.text = ""
                }
                if arrLastFive.count == 4 {
                    if let totwa0 = arrLastFive[0].totalWater, let time0 = arrLastFive[0].add_date {
                        lblQty0.text = "\(totwa0)"
                        lblTime0.text = "\(formatUnixDate(date: time0))"
                    }
                    if let totwa1 = arrLastFive[1].totalWater, let time1 = arrLastFive[1].add_date {
                        lblQty1.text = "\(totwa1)"
                        lblTime1.text = "\(formatUnixDate(date: time1))"
                    }
                    if let totwa2 = arrLastFive[2].totalWater, let time2 = arrLastFive[2].add_date {
                        lblQty2.text = "\(totwa2)"
                        lblTime2.text = "\(formatUnixDate(date: time2))"
                    }
                    if let totwa3 = arrLastFive[3].totalWater, let time3 = arrLastFive[3].add_date {
                        lblQty3.text = "\(totwa3)"
                        lblTime3.text = "\(formatUnixDate(date: time3))"
                    }
                    //Blank the remaining label
                        lblQty4.text = ""
                        lblTime4.text = ""
                }
                if arrLastFive.count == 5 {
                    if let totwa0 = arrLastFive[0].totalWater, let time0 = arrLastFive[0].add_date {
                        lblQty0.text = "\(totwa0)"
                        lblTime0.text = "\(formatUnixDate(date: time0))"
                    }
                    if let totwa1 = arrLastFive[1].totalWater, let time1 = arrLastFive[1].add_date {
                        lblQty1.text = "\(totwa1)"
                        lblTime1.text = "\(formatUnixDate(date: time1))"
                    }
                    if let totwa2 = arrLastFive[2].totalWater, let time2 = arrLastFive[2].add_date {
                        lblQty2.text = "\(totwa2)"
                        lblTime2.text = "\(formatUnixDate(date: time2))"
                    }
                    if let totwa3 = arrLastFive[3].totalWater, let time3 = arrLastFive[3].add_date {
                        lblQty3.text = "\(totwa3)"
                        lblTime3.text = "\(formatUnixDate(date: time3))"
                    }
                    if let totwa4 = arrLastFive[4].totalWater, let time4 = arrLastFive[4].add_date {
                        lblQty4.text = "\(totwa4)"
                        lblTime4.text = "\(formatUnixDate(date: time4))"
                    }
                }
            } else {
                
            //Blank the remaining label
                lblQty0.text = ""
                lblTime0.text = ""
                
                lblQty1.text = ""
                lblTime1.text = ""
                
                lblQty2.text = ""
                lblTime2.text = ""
                
                lblQty3.text = ""
                lblTime3.text = ""
                
                lblQty4.text = ""
                lblTime4.text = ""
            }
        }
        
        let myAttribute1 = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 20.0)!,
                            NSAttributedString.Key.foregroundColor: UIColor.gray]
        let myString1 = NSMutableAttributedString(string: " ml", attributes: myAttribute1 )
        
        //Target Goal
        if let waterTarget = statData?.target {
            let attrString1 = NSMutableAttributedString(string: "\(waterTarget)")
            attrString1.append(myString1)
            lblTagetGoalValue.attributedText = attrString1
        }
        
        //Acheived Goal
        if let acheiveGoal = statData?.achived {
            let attrString1 = NSMutableAttributedString(string: "\(acheiveGoal)")
            attrString1.append(myString1)
            lblAchievedGoalValue.attributedText = attrString1
        }
        
        //Reminder
        if let reminder = statData?.reminder {
            if reminder > 0 {
                viewAddReminderGrey.isHidden = true
                viewTimeToTime.isHidden = false
                lblTimeToTime.text = "\(reminder) hr interval reminder set"
            } else {
                viewAddReminderGrey.isHidden = false
                viewTimeToTime.isHidden = true
                lblTimeToTime.text = "\(reminder) hr interval reminder set"
            }
        } else {
            viewAddReminderGrey.isHidden = false
            viewTimeToTime.isHidden = true
        }
    }
    
    fileprivate func refreshGraph() {
        //Clear the previous array data
        yValue = [Int]()
        labelValue = [String]()

        if let arrChartValue = statData?.graphRecords {
            for item in arrChartValue {
                if let totwa = item.totalWater {
                    yValue?.append(totwa)
                }

                if let createdDate = item.add_date {
                    switch xLabel {
                    case ConstantChartLabel.today:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
//                        dateFormatter1.dateFormat = "hh:mm a"
//                        dateFormatter1.amSymbol = "AM"
//                        dateFormatter1.pmSymbol = "PM"
                        dateFormatter2.dateFormat = "HH:mm" //24hr format
                        let stringFromDate = dateFormatter2.string(from: dateFromString)
                        debugPrint("formatDate--->",stringFromDate)
                        
                        labelValue?.append(stringFromDate)
                        break
                    case ConstantChartLabel.weekly:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
                        dateFormatter2.dateFormat = "EE"
                        let stringFromDate = dateFormatter2.string(from: dateFromString)
                        debugPrint("formatDate--->",stringFromDate)
                        
                        labelValue?.append(stringFromDate)
                        break
                    case ConstantChartLabel.monthly:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
                        dateFormatter2.dateFormat = "MMM"
                        let stringFromDate = dateFormatter2.string(from: dateFromString)
                        debugPrint("formatDate--->",stringFromDate)
                        
                        labelValue?.append(stringFromDate)
                        break
                    case ConstantChartLabel.yearly:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
                        dateFormatter2.dateFormat = "yyyy"
                        let stringFromDate = dateFormatter2.string(from: dateFromString)
                        debugPrint("formatDate--->",stringFromDate)
                        
                        labelValue?.append(stringFromDate)
                        break
                    default:
                        break
                    }
                }
                
            }
//            print("---->\(yValue)")
//            print("---->\(labelValue)")
            
            setChartData(label: chartLabel)
        }
    }
    
    //MARK: - Setup Chart Data
    func setChartData(label: String) {
        self.viewChart.setOptions([.yAxisTitle(label), .yAxisNumberOfInterval(10)])
        self.viewChart.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), 0.28..<0.42: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), 0.42..<0.56: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
        if let yVal = yValue, let xLabel = labelValue {
            self.viewChart.setDataEntries(values: yVal)
            self.viewChart.setXAxisUnitTitles(xLabel)
        }
        self.viewChart.start()
    }
    
    fileprivate func clearGraph() {
        yValue = [Int]()
        labelValue = [String]()
        
        yValue?.append(0)
        labelValue?.append("")
        
        setChartData(label: "")
    }
    
    //MARK: Tap Gesture Func---------
    @objc func tapAcheivement(_ sender: UITapGestureRecognizer) {
        let badgeVC = ConstantStoryboard.badgesStoryboard.instantiateViewController(withIdentifier: "BadgeViewController") as! BadgeViewController
        if let userBadge = statData?.user_badges {
            badgeVC.arrBadgeData = userBadge
        }
        badgeVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.navigationController?.present(badgeVC, animated: true)
    }
    
    //MARK: - Button Func
    @IBAction func btnCalender(_ sender: Any) {
        showViewHidden()
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        
//        if let preDate = prevDate {
            lblDateToday.text = "\(setupDateLabel(date: prevDate!))"
            
            startDate = prevDateString
            endDate = prevDateString

            getStatData(startDate: startDate, endDate: endDate)
            chartLabel = prevDateString
            xLabel = ConstantChartLabel.today
//        }
        
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
        
//        if let preDate = prevDate {
            lblDateToday.text = "\(setupDateLabel(date: nextDate!))"
            
            startDate = nextDateString
            endDate = nextDateString

            getStatData(startDate: startDate, endDate: endDate)
            chartLabel = nextDateString
            xLabel = ConstantChartLabel.today
//        }
        
        //Clear button selection color
        ClearButtonColor()
    }
    
    @IBAction func btnDateDone(_ sender: Any) {
        hideViewHidden()
        
        print(Date().formatDate(date: self.datePicker.date))
        
        //Clear button selection color
        ClearButtonColor()
        
        lblDateToday.text = "\(setupDateLabel(date: datePicker.date))"
        
        startDate = Date().formatDate(date: self.datePicker.date)
        endDate = Date().formatDate(date: self.datePicker.date)
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = "\(startDate)"
        xLabel = ConstantChartLabel.today
    }
    
    func hideViewHidden() {
        viewHidden.isHidden = true
        viewHidden.alpha = 0.0
    }
    
    func showViewHidden() {
        viewHidden.isHidden = false
        viewHidden.alpha = 1.0
    }
    
    func ClearButtonColor() {
        //Clear button selection color
        btnToday.backgroundColor = UIColor.white
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.white
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.white
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
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
        
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.today
        xLabel = ConstantChartLabel.today
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
        
        startDate = Date().formatDate(date: Date.sevenDayPrevious)
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.weekly
        xLabel = ConstantChartLabel.weekly
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
        
        startDate = Date().formatDate(date: Date.oneMonthPrevious)
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.monthly
        xLabel = ConstantChartLabel.monthly
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
        
        startDate = Date().formatDate(date: Date.oneYearPrevious)
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.yearly
        xLabel = ConstantChartLabel.yearly
    }

    @IBAction func btnAddIntake(_ sender: Any) {
        
        if self.lblDateToday.text == "\(setupDateLabel(date: Date()))" {
            let popupVC = ConstantStoryboard.waterStoryboard.instantiateViewController(withIdentifier: "WaterCupSizeViewController") as! WaterCupSizeViewController
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(popupVC, animated: true)
        } else {
            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.WaterIntakeAddMsg)
        }
    }
    
    @IBAction func btnSetReminder(_ sender: Any) {
        let reminderVC = ConstantStoryboard.waterStoryboard.instantiateViewController(withIdentifier: "WaterSetReminderViewController") as! WaterSetReminderViewController
        navigationController?.pushViewController(reminderVC, animated: true)
    }
    
    //MARK: - Date Formatter
    //Date Format
    func formatUnixDate(date: String) -> String {
        let dateFromString = Date().UTCFormatter(date: date)

        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        
        switch xLabel {
        case ConstantChartLabel.today:
            dateFormatter2.dateFormat = "hh:mm a"
            dateFormatter2.amSymbol = "AM"
            dateFormatter2.pmSymbol = "PM"
            break
        case ConstantChartLabel.weekly:
            dateFormatter2.dateFormat = "EE"
            break
        case ConstantChartLabel.monthly:
            dateFormatter2.dateFormat = "MMM"
            break
        case ConstantChartLabel.yearly:
            dateFormatter2.dateFormat = "yyyy"
            break
        default:
            break
        }
        
        let stringFromDate = dateFormatter2.string(from: dateFromString)
        debugPrint("formatUnixDate--->",stringFromDate)
        return stringFromDate
    }
    
    func setupDateLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let formatDate = dateFormatter.string(from: date)
        return formatDate
    }
    
//    //MARK: - Tap Ges Func
//    @IBAction func tapGesViewHidden(_ sender: Any) {
//        hideViewHidden()
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
        print("Water Stat BADGE COUNT-----\(badgeCount)")
    }
}

extension WaterIntakeStatsViewController: WaterStatDelegate {
    func didReceiveWaterStatDataResponse(waterStatDataResponse: WaterStatResponse?) {
        self.view.stopActivityIndicator()
        
        if(waterStatDataResponse?.status != nil && waterStatDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)
            statData = waterStatDataResponse
            if let data = statData?.graphRecords {
                if data.count != 0 {
                    //Refresh graph data
                    refreshGraph()
                } else {
//                    clearData()
                    clearGraph()
                    showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: waterStatDataResponse?.message ?? ConstantStatusAPI.failed)
                }
            } else {
//                clearData()
                clearGraph()
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: waterStatDataResponse?.message ?? ConstantStatusAPI.failed)
            }
            //Refresh general data
            refreshData()
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: waterStatDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveWaterStatDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
//    func clearData() {
//        lblQty0.text = "0"
//        lblTime0.text = "0"
//
//        lblQty1.text = "0"
//        lblTime1.text = "0"
//
//        lblQty2.text = "0"
//        lblTime2.text = "0"
//
//        lblQty3.text = "0"
//        lblTime3.text = "0"
//
//        lblQty4.text = "0"
//        lblTime4.text = "0"
//
//        //Target Goal
//        let myAttribute1 = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 20.0)!,
//                            NSAttributedString.Key.foregroundColor: UIColor.gray]
//        let myString1 = NSMutableAttributedString(string: " ml", attributes: myAttribute1 )
//
//        let attrString1 = NSMutableAttributedString(string: "0")
//        attrString1.append(myString1)
//        lblTagetGoalValue.attributedText = attrString1
//
//        //Acheived Goal
//        let attrString2 = NSMutableAttributedString(string: "0")
//        attrString2.append(myString1)
//        lblAchievedGoalValue.attributedText = attrString2
//
//    }
}

extension WaterIntakeStatsViewController: WaterCupSizeViewControllerDelegate {
    //MARK: - Refresh All Data
    func refreshWaterData() {
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        
        getStatData(startDate: Date().formatDate(date: Date()), endDate: Date().formatDate(date: Date()))
        chartLabel = ConstantChartLabel.today
        xLabel = ConstantChartLabel.today
    }
}
