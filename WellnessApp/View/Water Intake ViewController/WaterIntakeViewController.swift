//
//  WaterIntakeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/11/21.
//

import UIKit

var isFromBackWater = false

class WaterIntakeViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnCalender: UIButton!
    @IBOutlet var lblTotalMl: UILabel!
    @IBOutlet var lbl2000ml: UILabel!
    @IBOutlet var lbl4000ml: UILabel!
    @IBOutlet var sliderWater: UISlider!
    @IBOutlet var btnSetGoal: UIBUtton_Designable!
    
//    var fromHome: Bool?
    
    var isGoalSet = false
    
    var waterViewModel = WaterViewModel()
    
    var waterGoal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        waterViewModel.getWaterGoalDelegate = self
        setupGui()
        getDailyGoal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        
        if isGoalSet && !isFromBackWater {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.sentToNextPage()
            }
        }
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
    
    fileprivate func setupGui() {
        //Slider setup
        sliderWater.maximumValue = 4000
        sliderWater.minimumValue = 0
//        sliderWater.isContinuous = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let formatDate = dateFormatter.string(from: Date())
        lblDate.text = "\(formatDate)"
        
        lblDate.textColor = UIColor.colorSetup()
        btnCalender.tintColor = UIColor.colorSetup()
        lblTotalMl.textColor = UIColor.colorSetup()
        lbl2000ml.textColor = UIColor.lightGray
        lbl4000ml.textColor = UIColor.lightGray
        sliderWater.tintColor = UIColor.colorSetup()
        btnSetGoal.backgroundColor = UIColor.colorSetup()
    }
    
    //MARK: - Get Daily Goal
    func getDailyGoal() {
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
            waterViewModel.getDailyWaterGoal(token: token)
        }
    }

    //MARK: - Button Func
    @IBAction func btnCalender(_ sender: Any) {
        //Open calender if required later
    }
    
    @IBAction func btnSave(_ sender: Any) {
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
            let request = WaterGoalRequest(daily_water: waterGoal)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            waterViewModel.setDailyWaterGoal(goalRequest: request, token: token)
        }
    }
    
    @IBAction func sliderWater(_ sender: UISlider) {
        let roundedValue = round(sender.value / 50) * 50
        
        sender.setValue(roundedValue, animated: true)
        
        print(roundedValue)
        waterGoal = Int(roundedValue)
        lblTotalMl.text = "\(Int(roundedValue))Ml/\(Int(roundedValue/1000))L"
    }
    
    func sentToNextPage() {
        isFromBackWater = true
        isGoalSet = true
        let waterVC = ConstantStoryboard.waterStoryboard.instantiateViewController(withIdentifier: "WaterIntakeStatsViewController") as! WaterIntakeStatsViewController
//        waterVC.fromHome = fromHome
        self.navigationController?.pushViewController(waterVC, animated: true)
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

extension WaterIntakeViewController: GetWaterGoalDelegate {
    func didReceiveWaterGoalDataResponse(waterGoalDataResponse: WaterGoalResponse?) {
        self.view.stopActivityIndicator()
        
        if(waterGoalDataResponse?.status != nil && waterGoalDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterGoalDataResponse)
            
            if let goal = waterGoalDataResponse?.dailyWater {
                //Set slider value
                let roundedValue = Float(goal / 50) * 50
                sliderWater.value = roundedValue
                waterGoal = Int(roundedValue)
                lblTotalMl.text = "\(Int(roundedValue))Ml/\(Int(roundedValue/1000))L"
                if goal != 0 {
                    self.sentToNextPage()
                }
            } else {
                openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                        message: waterGoalDataResponse?.message ?? "Success",
                                        alertStyle: .alert,
                                        actionTitles: ["OK"],
                                        actionStyles: [.default],
                                        actions: [
                                            { _ in
                                                //Goto next page
                                                self.sentToNextPage()
                                            }
                                        ])
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: waterGoalDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveWaterGoalDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    
}
