//
//  ExerciseStatsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 12/11/21.
//

import UIKit
import MSBBarChart

fileprivate struct ConstantChartLabel {
    static let today    = "Today"
    static let weekly   = "Weekly"
    static let monthly  = "Monthly"
    static let yearly   = "Yearly"
}

class ExerciseStatsViewController: UIViewController {
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
    @IBOutlet var imgStep: UIImageView!
    @IBOutlet var imgVWEdit: UIImageView!
    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblStepsCount: UILabel!
    @IBOutlet var imgDistance: UIImageView!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblMiles: UILabel!
    @IBOutlet var imgCalorie: UIImageView!
    @IBOutlet var lblCalorie: UILabel!
    @IBOutlet var lblCalBurn: UILabel!
    @IBOutlet var circularProgress: CircularProgressView!
    @IBOutlet var lblTodayStat: UILabel!
//    @IBOutlet var lineChart: LineChart!
    @IBOutlet weak var viewChart: MSBBarChartView!
    @IBOutlet var lblChart: UILabel!
    @IBOutlet var viewAcheivment: UIView_Designable!
    @IBOutlet var imgVAcheivment: UIImageView!
    @IBOutlet var lblPoints: UILabel!
    @IBOutlet var lblStepPercentage: UILabel!
    
    //Hidden View
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnDateDone: UIButton!
    
    var startDate = ""
    var endDate = ""
    var xLabel = ""
    
//    var xLabelValue:[String]?
//    var yValue: [CGFloat]?
    //Chart
    var chartLabel = ""
    var xLabelValue:[String]?
    var yValue: [Int]?
    
    var exerciseStatViewModel = ExerciseViewModel()
    var statData: ExerciseStatResponse?
    var stepsGoal: String?
    
    var fromHome: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        exerciseStatViewModel.exerciseStatDelegate = self
        
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
//                lblTodayStat.text = "Previous Statistics"
//                xLabel = ConstantChartLabel.today
//            } else {
//                getStatData(startDate: formatDate(date: Date()), endDate: formatDate(date: Date()))
//                lblTodayStat.text = "\(ConstantChartLabel.today)'s Statistics"
//                xLabel = ConstantChartLabel.today
//            }
//        } else {
            getStatData(startDate: startDate, endDate: endDate)
            lblTodayStat.text = "\(ConstantChartLabel.today)'s Statistics"
            chartLabel = ConstantChartLabel.today
            xLabel = ConstantChartLabel.today
//        }
       // print(stepsGoal)
        //refreshData()
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
    
    @IBAction func btnEdit(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "FromHomeEdit")
        let Exercise = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ExerciseViewController") as! ExerciseViewController
        navigationController?.pushViewController(Exercise, animated: true)
        
        
    }
    
    //MARK: - Nav Button Func
    @IBAction func btnBack(_ sender: Any) {
        if let fromHome = fromHome {
            if fromHome {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                isFromBackExercise = false
                self.navigationController?.popToCustomViewController(viewController: ExerciseViewController.self)
            }
        } else {
            isFromBackExercise = false
            self.navigationController?.popToCustomViewController(viewController: ExerciseViewController.self)
        }
//        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.popToCustomViewController(viewController: ExerciseTimeViewController.self)
    }
    
    @IBAction func btnShareAction(_ sender: Any) {
        // image to share
        let renderer = UIGraphicsImageRenderer(size: view.frame.size)
        let image = renderer.image(actions: { context in
            view.layer.render(in: context.cgContext)
        })
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
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
        
        datePicker.tintColor = UIColor.colorSetup()
        btnDateDone.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnCalender.tintColor = UIColor.colorSetup()
        imgStep.tintColor = UIColor.colorSetup()
        imgVWEdit.tintColor = UIColor.colorSetup()
        lblStep.textColor = UIColor.colorSetup()
        imgDistance.tintColor = UIColor.colorSetup()
        lblDistance.textColor = UIColor.colorSetup()
        imgCalorie.tintColor = UIColor.colorSetup()
        lblCalorie.textColor = UIColor.colorSetup()
        lblStepPercentage.textColor = UIColor.colorSetup()
        
        //Circular Progress Bar Setup
        circularProgress.trackClr = UIColor.darkGray
        circularProgress.progressClr = UIColor.colorSetup()
        
        //Initial button setup
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
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
                print("chakra level ...--->>>",chakraLevel)
                print("coloris ...--->>>",chakraColour)

        
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
        } else if crownList == 1{
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
    
    //MARK: - API Call
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
            let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                    print(status)
                    
                    if status==true
            {
            
            let request = ExerciseStatRequest(startDate: startDate, endDate: endDate,device_cat: "watch")
                        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                        exerciseStatViewModel.postGetExerciseStat(exerciseStatRequest: request, token: token)
                    }
            
            else
            {
                let request = ExerciseStatRequest(startDate: startDate, endDate: endDate,device_cat: "mobile")
                            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                            exerciseStatViewModel.postGetExerciseStat(exerciseStatRequest: request, token: token)
            }
           
        }
    }
    
    func refreshData() {
//        if let kiloCal = statData?.calBurns {
//            lblKiloCalorie.text = "\(kiloCal)"
//        }
        if let distance = statData?.completedMiles, let steps = statData?.completedSteps, let stepGoal = self.stepsGoal, let calBurn = statData?.calBurns {
            let myAttribute1 = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 24.0)!,
                                NSAttributedString.Key.foregroundColor: UIColor.gray]
            let myString1 = NSMutableAttributedString(string: " miles", attributes: myAttribute1 )
            
            let roundedValue = String(format: "%.3f", distance)
            let attrString1 = NSMutableAttributedString(string: roundedValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorSetup()])
            attrString1.append(myString1)
            lblMiles.attributedText = attrString1
            
            //let myAttribute2 = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 24.0)!,
            //                    NSAttributedString.Key.foregroundColor: UIColor.gray]
            let myString2 = NSMutableAttributedString(string: " kcal", attributes: myAttribute1 )
            let attrString2 = NSMutableAttributedString(string: "\(calBurn)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorSetup()])  //NSMutableAttributedString(string: "\(steps)/\(calBurn)")
            attrString2.append(myString2)
            lblCalBurn.attributedText = attrString2
            
            //let myAttribute3 = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 24.0)!,
            //                    NSAttributedString.Key.foregroundColor: UIColor.gray]
            let myString3 = NSMutableAttributedString(string: " steps", attributes: myAttribute1 )
            let status = UserDefaults.standard.bool(forKey: "isFromSave")
            
            if status==true
            {
                print(String(UserDefaults.standard.string(forKey: "UpdatedSteps") ?? "0"))
                let attrString3 = NSMutableAttributedString(string: "\(steps)/\((UserDefaults.standard.string(forKey: "UpdatedSteps") ?? "0"))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorSetup()])
                attrString3.append(myString3)
                lblStepsCount.attributedText = attrString3
                UserDefaults.standard.set(false, forKey: "isFromSave")
            }
            else{
            let attrString3 = NSMutableAttributedString(string: "\(steps)/\(stepGoal)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorSetup()])
            attrString3.append(myString3)
            lblStepsCount.attributedText = attrString3
            }
        }
        
        //Circular progress bar data
        let totalPercentage : Float
        
        if let stepCompleted = statData?.completedSteps, let stepsGoal = self.stepsGoal {
           
            if Float(stepsGoal)==0
            {
               debugPrint("Hello")
                totalPercentage = 100
            }
            else{
            
            totalPercentage = ((Float(stepCompleted)/Float(stepsGoal)!) * 100)
            }
            print("totalPercentage---------------->\(totalPercentage)")
            
            let roundedValue = String(format: "%.2f", totalPercentage)
            lblStepPercentage.text = "\(roundedValue)%"
            
            let circularPercentage = totalPercentage/100
            circularProgress.setProgressWithAnimation(duration: 2.0, value: circularPercentage)
        }
    }
    
    fileprivate func refreshGraph() {
        //Clear the previous array data
        yValue = [Int]()
        xLabelValue = [String]()

        if let arrChartValue = statData?.distance {
            for item in arrChartValue {
                if let totalStep = item.totalSteps {
                    yValue?.append(totalStep)
                }
                
                if let createdDate = item.created_date {
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
                        
                        xLabelValue?.append(stringFromDate)
                        break
                    case ConstantChartLabel.weekly:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
                        dateFormatter2.dateFormat = "EE"
                        let stringFromDate = dateFormatter2.string(from: dateFromString)
                        debugPrint("formatDate--->",stringFromDate)
                        
                        xLabelValue?.append(stringFromDate)
                        break
                    case ConstantChartLabel.monthly:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
                        dateFormatter2.dateFormat = "MMM"
                        let stringFromDate = dateFormatter2.string(from: dateFromString)
                        debugPrint("formatDate--->",stringFromDate)
                        
                        xLabelValue?.append(stringFromDate)
                        break
                    case ConstantChartLabel.yearly:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
                        dateFormatter2.dateFormat = "yyyy"
                        let stringFromDate = dateFormatter2.string(from: dateFromString)
                        debugPrint("formatDate--->",stringFromDate)
                        
                        xLabelValue?.append(stringFromDate)
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
        self.viewChart.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), 0.28..<0.42: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), 0.42..<0.56: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
        
//        self.viewChart.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), 0.28..<0.42: #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1), 0.42..<0.56: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
//
        if let yVal = yValue, let xLabel = xLabelValue {
            self.viewChart.setDataEntries(values: yVal)
            self.viewChart.setXAxisUnitTitles(xLabel)
        }
        self.viewChart.start()
    }
    
    fileprivate func clearGraph() {
        yValue = [Int]()
        xLabelValue = [String]()
        
        yValue?.append(0)
        xLabelValue?.append("")
        
        setChartData(label: "")
    }

    
//    fileprivate func refreshGraph() {
//        //Clear the previous array data
//        yValue = [CGFloat]()
//        xLabelValue = [String]()
//
//        if let arrChartValue = statData?.distance {
//            for item in arrChartValue {
//                if let totalStep = item.totalSteps {
//                    yValue?.append(CGFloat(totalStep))
//                }
//
//    if let createdDate = item.created_date {
//        switch xLabel {
//        case ConstantChartLabel.today:
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
//            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            let dateFromString = dateFormatter1.date(from: createdDate)!
//
//            let dateFormatter2 = DateFormatter()
//            dateFormatter2.timeZone = TimeZone.current
//            //                        dateFormatter1.dateFormat = "hh:mm a"
//            //                        dateFormatter1.amSymbol = "AM"
//            //                        dateFormatter1.pmSymbol = "PM"
//            dateFormatter2.dateFormat = "HH:mm" //24hr format
//            let stringFromDate = dateFormatter2.string(from: dateFromString)
//            debugPrint("formatDate--->",stringFromDate)
//
//            xLabelValue?.append(stringFromDate)
//            break
//        case ConstantChartLabel.weekly:
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
//            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            let dateFromString = dateFormatter1.date(from: createdDate)!
//
//            let dateFormatter2 = DateFormatter()
//            dateFormatter2.timeZone = TimeZone.current
//            dateFormatter2.dateFormat = "EE"
//            let stringFromDate = dateFormatter2.string(from: dateFromString)
//            debugPrint("formatDate--->",stringFromDate)
//
//            xLabelValue?.append(stringFromDate)
//            break
//        case ConstantChartLabel.monthly:
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
//            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            let dateFromString = dateFormatter1.date(from: createdDate)!
//
//            let dateFormatter2 = DateFormatter()
//            dateFormatter2.timeZone = TimeZone.current
//            dateFormatter2.dateFormat = "MMM"
//            let stringFromDate = dateFormatter2.string(from: dateFromString)
//            debugPrint("formatDate--->",stringFromDate)
//
//            xLabelValue?.append(stringFromDate)
//            break
//        case ConstantChartLabel.yearly:
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
//            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            let dateFromString = dateFormatter1.date(from: createdDate)!
//
//            let dateFormatter2 = DateFormatter()
//            dateFormatter2.timeZone = TimeZone.current
//            dateFormatter2.dateFormat = "yyyy"
//            let stringFromDate = dateFormatter2.string(from: dateFromString)
//            debugPrint("formatDate--->",stringFromDate)
//
//            xLabelValue?.append(stringFromDate)
//            break
//        default:
//            break
//        }
//    }
//
//            }
////            print("---->\(yValue)")
////            print("---->\(xLabelValue)")
//
//            if let xLabel = xLabelValue, let yValues = yValue {
//                setupChart(xLabel: xLabel, yValue: yValues)
//            }
//        }
//    }
//
//    //MARK: - Chart
//    fileprivate func setupChart(xLabel: [String], yValue: [CGFloat]) {
//        lineChart.clearAll()
//
//        let arrYLabelString = yValue.map {
//            String(describing: $0 as CGFloat)
//        }
//        print("----->\(arrYLabelString)")
//
//        lineChart.delegate = self
//        lineChart.colors = [UIColor.colorSetup()]
//        lineChart.animation.enabled = true
//        lineChart.area = false
////        lineChart.dots.color = UIColor.colorSetup()
//
////        lineChart.x.grid.count = 5
//        lineChart.x.axis.color = UIColor.colorSetup()
//        lineChart.x.labels.visible = true
//        lineChart.x.grid.visible = false
//        lineChart.x.labels.values = xLabel
//
////        lineChart.y.grid.count = 5
//        lineChart.y.axis.color = UIColor.colorSetup()
//        lineChart.y.labels.visible = true
//        lineChart.y.grid.visible = false
//        lineChart.y.labels.values = arrYLabelString//["3","4","-2","11","13","15"]
//
//        lineChart.addLine(yValue)
//    }
//
//    fileprivate func clearGraph() {
//        ///Remove charts, areas and labels but keep axis and grid.
//        lineChart.clear()
//
////        ///Make whole UIView white again
////        lineChart.clearAll()
//    }
    
    //MARK: Tap Gesture Func---------
    @objc func tapAcheivement(_ sender: UITapGestureRecognizer) {
        let badgeVC = ConstantStoryboard.badgesStoryboard.instantiateViewController(withIdentifier: "BadgeViewController") as! BadgeViewController
        if let userBadge = statData?.user_badge {
            badgeVC.arrBadgeData = userBadge
        }
        badgeVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.navigationController?.present(badgeVC, animated: true)
    }
    
    //MARK: - Button Func
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
        
        ClearButtonColor()
        
        lblDateToday.text = "\(setupDateLabel(date: datePicker.date))"
        
        startDate = Date().formatDate(date: self.datePicker.date)
        endDate = Date().formatDate(date: self.datePicker.date)
        lblTodayStat.text = "Previous Statistics"
        
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = "\(startDate)"
        xLabel = ConstantChartLabel.today
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
    
    @IBAction func btnToday(_ sender: Any) {
        btnToday.backgroundColor = UIColor.colorSetup()
        btnToday.setTitleColor(.white, for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())
        
        lblTodayStat.text = "\(ConstantChartLabel.today)'s Statistics"
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.today
        xLabel = ConstantChartLabel.today
    }
    
    @IBAction func btnWeekly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.colorSetup()
        btnWeekly.setTitleColor(.white, for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        
        startDate = Date().formatDate(date: Date.sevenDayPrevious)
        endDate = Date().formatDate(date: Date())
        
        lblTodayStat.text = "\(ConstantChartLabel.weekly) Statistics"
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.weekly
        xLabel = ConstantChartLabel.weekly
    }
    
    @IBAction func btnMonthly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.colorSetup()
        btnMonthly.setTitleColor(.white, for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        
        startDate = Date().formatDate(date: Date.oneMonthPrevious)
        endDate = Date().formatDate(date: Date())
        
        lblTodayStat.text = "\(ConstantChartLabel.monthly) Statistics"
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.monthly
        xLabel = ConstantChartLabel.monthly
    }
    
    @IBAction func btnYearly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.colorSetup()
        btnYearly.setTitleColor(.white, for: .normal)
        
        lblDateToday.text = "\(setupDateLabel(date: Date()))"
        
        startDate = Date().formatDate(date: Date.oneYearPrevious)
        endDate = Date().formatDate(date: Date())
        
        lblTodayStat.text = "\(ConstantChartLabel.yearly) Statistics"
        getStatData(startDate: startDate, endDate: endDate)
        chartLabel = ConstantChartLabel.yearly
        xLabel = ConstantChartLabel.yearly
    }
    
    func hideViewHidden() {
        viewHidden.isHidden = true
        viewHidden.alpha = 0.0
    }
    
    func showViewHidden() {
        viewHidden.isHidden = false
        viewHidden.alpha = 1.0
    }
    
    //MARK: - Date Formatter
    private func setupDateLabel(date: Date) -> String {
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
        print("BADGE COUNT-----\(badgeCount)")
    }
}

extension ExerciseStatsViewController: ExerciseStatDelegate {
    func didReceiveExerciseStatDataResponse(exerciseStatDataResponse: ExerciseStatResponse?) {
        self.view.stopActivityIndicator()
        
        if(exerciseStatDataResponse?.status != nil && exerciseStatDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(exerciseStatDataResponse)
            statData = exerciseStatDataResponse
            if let data = statData?.distance {
                if data.count != 0 {
                    //Refresh graph data
                    refreshGraph()
                } else {
//                    clearData()
                    clearGraph()
                    showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: exerciseStatDataResponse?.message ?? ConstantStatusAPI.failed)
                }
            } else {
//                clearData()
                clearGraph()
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: exerciseStatDataResponse?.message ?? ConstantStatusAPI.failed)
            }
            //Refresh general data
            refreshData()
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: exerciseStatDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveExerciseStatDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

//extension ExerciseStatsViewController: LineChartDelegate {
//    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
//        print(yValues)
//        lblChart.text = "Steps: \(yValues)"
//    }
//}
