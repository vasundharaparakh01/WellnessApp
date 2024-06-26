//
//  HeartRateStatsViewController.swift
 
//
//  Created by BEASMACUSR02 on 02/12/21.
//

import UIKit

fileprivate struct ConstantChartLabel {
    static let today    = "Today"
    static let weekly   = "Weekly"
    static let monthly  = "Monthly"
    static let yearly   = "Yearly"
}

class HeartRateCell: UITableViewCell {
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblBPM: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblBPM.textColor = UIColor.colorSetup()
    }
}

class HeartRateStatsViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var btnStatistics: UIBUtton_Designable!
    @IBOutlet var lblTodayStat: UILabel!
    @IBOutlet var btnToday: UIBUtton_Designable!
    @IBOutlet var btnWeekly: UIBUtton_Designable!
    @IBOutlet var btnMonthly: UIBUtton_Designable!
    @IBOutlet var btnYearly: UIBUtton_Designable!
    @IBOutlet var lineChart: LineChart!
    @IBOutlet var lblChart: UILabel!
    @IBOutlet var tblMain: UITableView!
    
    var startDate = ""
    var endDate = ""
    var xLabel = ""
    
    var xLabelValue:[String]?
    var yValue: [CGFloat]?
    
    var heartViewModel = HeartViewModel()
    var statData: HeartRateStatResponse?
    var arrLastFive: [HeartRateLatestFive]?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        heartViewModel.delegateHeartStat = self
        
        setupGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        //------------------------------
        
        
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())
        
        //Initial Chart
        setupChart(xLabel: [""], yValue: [0.0])
        lineChart.y.labels.visible = false
        
        getStatData(startDate: startDate, endDate: endDate)
        lblTodayStat.text = "Today's Statistics"
        xLabel = ConstantChartLabel.today
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
    
    //MARK: - Setup GUI
    fileprivate func setupGUI() {
        btnStatistics.backgroundColor = UIColor.colorSetup()
        
        //Initial button setup
        btnToday.backgroundColor = UIColor.white
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.white
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.white
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
    }
    
    //MARK: - Buton Func
    @IBAction func btnMeasure(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        
        lblTodayStat.text = "Today's Statistics"
        
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
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
        
        lblTodayStat.text = "Weekly Statistics"
        
        startDate = Date().formatDate(date: Date.sevenDayPrevious)
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
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
        
        lblTodayStat.text = "Monthly Statistics"
        
        startDate = Date().formatDate(date: Date.oneMonthPrevious)
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
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
        
        lblTodayStat.text = "Yearly Statistics"
        
        startDate = Date().formatDate(date: Date.oneYearPrevious)
        endDate = Date().formatDate(date: Date())
        
        getStatData(startDate: startDate, endDate: endDate)
        xLabel = ConstantChartLabel.yearly
    }
    
    func formatUnixDate(date: String) -> String {
        let dateFromString = Date().UTCFormatter(date: date)

        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MM/dd/yyyy"
        dateFormatter2.timeZone = TimeZone.current
        let stringFromDate = dateFormatter2.string(from: dateFromString)
        debugPrint("formatDate--->",stringFromDate)
        return stringFromDate
    }
    
    //MARK: - API Call
    fileprivate func getStatData(startDate: String, endDate: String) {
        print("Start date--->\(startDate) End date--->\(endDate)")
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            let request = HeartRateStatRequest(startDate: startDate, endDate: endDate, device_cat: "mobile")
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            heartViewModel.postGetHeartStat(heartStatRequest: request, token: token)
        }
    }
    
    fileprivate func refreshData() {
        if let arrFive = statData?.records {
            if arrFive.count > 0 {
                arrLastFive = arrFive
                tblMain.reloadData()
            } else {
                arrLastFive = nil
                tblMain.reloadData()
            }
        }
    }
    
    fileprivate func refreshGraph() {
        //Clear the previous array data
        yValue = [CGFloat]()
        xLabelValue = [String]()

        if let arrChartValue = statData?.graphRecords {
            for item in arrChartValue {
                if let totalBpm = item.heart_rate {
                    yValue?.append(CGFloat(totalBpm))
                }

                if let createdDate = item.add_date {
                    switch xLabel {
                    case ConstantChartLabel.today:
                        let dateFromString = Date().UTCFormatter(date: createdDate)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.timeZone = TimeZone.current
                        dateFormatter2.dateFormat = "hh:mm a"
                        dateFormatter2.amSymbol = "AM"
                        dateFormatter2.pmSymbol = "PM"
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
            print("---->\(yValue)")
            print("---->\(xLabelValue)")
            
            if let xLabel = xLabelValue, let yValues = yValue {
                setupChart(xLabel: xLabel, yValue: yValues)
            }
        }
    }
    
    //MARK: - Chart
    fileprivate func setupChart(xLabel: [String], yValue: [CGFloat]) {
//        // simple line with custom x axis labels
//        let xLabel: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//        // simple arrays
//        let data: [CGFloat] = [3, 4, 9, 11, 13, 15]
        //---------------------------------------
        
        lineChart.clearAll()
        
        let arrYLabelString = yValue.map {
            String(describing: $0 as CGFloat)
        }
        print("----->\(arrYLabelString)")

        lineChart.delegate = self
        lineChart.colors = [UIColor.colorSetup()]
        lineChart.animation.enabled = true
        lineChart.area = false
//        lineChart.dots.color = UIColor.colorSetup()
        
//        lineChart.x.grid.count = 5
        lineChart.x.axis.color = UIColor.colorSetup()
        lineChart.x.labels.visible = true
        lineChart.x.grid.visible = false
        lineChart.x.labels.values = xLabel
        
//        lineChart.y.grid.count = 5
        lineChart.y.axis.color = UIColor.colorSetup()
        lineChart.y.labels.visible = true
        lineChart.y.grid.visible = false
        lineChart.y.labels.values = arrYLabelString//["3","4","-2","11","13","15"]
        
        lineChart.addLine(yValue)
    }
    
    fileprivate func clearGraph() {
        ///Remove charts, areas and labels but keep axis and grid.
//        lineChart.clear()

//        ///Make whole UIView white again
        lineChart.clearAll()
        
        //Initial Chart
        setupChart(xLabel: [""], yValue: [0.0])
        lineChart.y.labels.visible = false
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

extension HeartRateStatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrFive = arrLastFive else { return 0 }
        return arrFive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeartRateCell", for: indexPath) as! HeartRateCell
        
        guard let arrFive = arrLastFive else { return cell }
        
        if let addDate = arrFive[indexPath.row].add_date {
            cell.lblDate.text = formatUnixDate(date: addDate)
        }
        
        if let bpm = arrFive[indexPath.row].heart_rate {
            cell.lblBPM.text = "\(Int(bpm)) bpm"
        }
        
        return cell
    }
    
}

extension HeartRateStatsViewController: LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        print(yValues)
        lblChart.text = "Bpm: \(Int(yValues[0]))"
    }
}

extension HeartRateStatsViewController: HeartStatDelegate {
    func didReceiveHeartStatDataResponse(heartStatDataResponse: HeartRateStatResponse?) {
        self.view.stopActivityIndicator()
        
        if(heartStatDataResponse?.status != nil && heartStatDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(heartStatDataResponse)
            statData = heartStatDataResponse
            if let data = statData?.graphRecords {
                if data.count != 0 {
                    //Refresh graph data
                    refreshGraph()
                } else {
                    clearGraph()
                    showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: heartStatDataResponse?.message ?? ConstantStatusAPI.failed)
                }
            } else {
                clearGraph()
                showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: heartStatDataResponse?.message ?? ConstantStatusAPI.failed)
            }
            //Refresh Data
            refreshData()
        } else {
            showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: heartStatDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveHeartStatDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
