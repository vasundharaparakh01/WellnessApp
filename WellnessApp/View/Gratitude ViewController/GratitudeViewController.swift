//
//  GratitudeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 04/10/21.
//

import UIKit

class GratitudeCell: UITableViewCell {
    
    @IBOutlet var imgCellIcon: UIImageView!
    @IBOutlet var lblCellDate: UILabel!
    @IBOutlet var lblCellMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCellIcon.layer.cornerRadius = imgCellIcon.frame.size.width / 2
        imgCellIcon.layer.masksToBounds = false
        imgCellIcon.clipsToBounds = true
    }
}

class GratitudeViewController: UIViewController, GratitudeListDelegate {
    
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var txtFromDate: UITextField!
    @IBOutlet var txtToDate: UITextField!
    @IBOutlet var imgCalenderFromDate: UIImageView!
    @IBOutlet var imgCalenderToDate: UIImageView!
    @IBOutlet var btnAddGratitude: UIButton!
    @IBOutlet var tblGratitude: UITableView!
    
    //Hidden View
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var datePicker: UIDatePicker!

    static let dateTypeFromDate = "fromDate"
    static let dateTypeToDate = "toDate"
    var dateType: String = "None"
    
    var gratitudeViewModel = GratitudeViewModel()
    var arrayGratitude: [GratitudeList]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        gratitudeViewModel.listDelegate = self
        
        datePicker.timeZone = TimeZone.current
        datePicker.date = Date()
        
        hideViewHidden()
        setupThemeColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        
        txtFromDate.text = nil
        txtToDate.text = nil
        
        getGratitudeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
    
    func hideViewHidden() {
        viewHidden.isHidden = true
        viewHidden.alpha = 0.0
    }
    
    func showViewHidden() {
        viewHidden.isHidden = false
        viewHidden.alpha = 1.0
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
    //-------------
    
    func setupThemeColor() {
        imgCalenderFromDate.setImageTintColor(color: UIColor.colorSetup())
        imgCalenderToDate.setImageTintColor(color: UIColor.colorSetup())
        btnAddGratitude.layer.backgroundColor = UIColor.colorSetup().cgColor
    }
    
    func getGratitudeData() {
        let previousSeventhDay = Date.sevenDayPrevious
                
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.timeZone = TimeZone.current
        convertDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let previousSeventhDate = convertDateFormatter.string(from: previousSeventhDay)
        let currentDate = convertDateFormatter.string(from: Date())
        
        debugPrint("formatDate--->",previousSeventhDate, currentDate)
        
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
            
            let request = GratitudeGetListRequestModel(startDate: previousSeventhDate, endDate: currentDate)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            gratitudeViewModel.getGratitudePreviousDetails(gratitudeRequest: request, token: token)
        }
    }
    
    //MARK: - Nav Button Func
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    
    //MARK: - Tap Ges Func
    @IBAction func tapGesViewHidden(_ sender: Any) {
        hideViewHidden()
    }
    
    @IBAction func tapGesViewFromDate(_ sender: Any) {
        showViewHidden()
        
        dateType = GratitudeViewController.dateTypeFromDate
        SetDatePicker()
    }
    
    @IBAction func tapGesViewToDate(_ sender: Any) {
        if let fromDate = txtFromDate.text {
            if fromDate.count > 0 && fromDate != "" {
                showViewHidden()
                
                dateType = GratitudeViewController.dateTypeToDate
                SetDatePicker()
                
            } else {
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.FromDateEmpty)
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.FromDateEmpty)
        }
    }
    
    //MARK: - Button Func
    @IBAction func btnGratitude(_ sender: Any) {
        let addGratitudeVC = ConstantStoryboard.gratitudeStoryboard.instantiateViewController(withIdentifier: "GratitudeAddViewController") as! GratitudeAddViewController
        navigationController?.pushViewController(addGratitudeVC, animated: true)
    }
    
    @IBAction func btnDateDone(_ sender: Any) {
        hideViewHidden()
        
        if dateType == GratitudeViewController.dateTypeFromDate {
            txtFromDate.text = Date().formatDate(date: self.datePicker.date)
            txtToDate.text = nil
            
        } else if dateType == GratitudeViewController.dateTypeToDate {
            txtToDate.text = Date().formatDate(date: self.datePicker.date)
            
            if let startDate = txtFromDate.text {
                if startDate.count > 0 && startDate != "" {
                    if let endDate = txtToDate.text {
                        if endDate.count > 0 && endDate != "" {
                            getFilterDateData(startDate: startDate, endDate: endDate)
                        }
                    }
                }
            }
        }
    }
    
    func getFilterDateData(startDate:String, endDate: String) {
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
            
            let request = GratitudeGetListRequestModel(startDate: startDate, endDate: endDate)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            gratitudeViewModel.getGratitudePreviousDetails(gratitudeRequest: request, token: token)
        }
    }
    
    func SetDatePicker() {
        // Max date & Min date
        let currentDate = Date()
        
        if dateType == GratitudeViewController.dateTypeFromDate {
            datePicker.date = currentDate
            datePicker.minimumDate = nil
            datePicker.maximumDate = nil
            
        } else if dateType == GratitudeViewController.dateTypeToDate {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let fromDate = txtFromDate.text {
                let date = dateFormatter.date(from: fromDate)
                datePicker.date = date!
                datePicker.minimumDate = date
                datePicker.maximumDate = nil
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

//MARK: - TableVIew Delegate
extension GratitudeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrGratitude = arrayGratitude else { return 0 }
        return arrGratitude.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GratitudeCell", for: indexPath) as! GratitudeCell
        cell.imgCellIcon.setImageTintColor(color: UIColor.colorSetup())
        
        guard let arrGratitude = arrayGratitude else { return cell }
        
        if let date = arrGratitude[indexPath.row].date {
//            cell.lblCellDate.text = formatDateForCell(date: date)
            let utcDate = Date().UTCFormatter(date: date)
            let dateToString = Date().formatDate(date: utcDate)
            cell.lblCellDate.text = dateToString
        }
        
        if let message = arrGratitude[indexPath.row].message {
            cell.lblCellMessage.text = message
        } else {
            if let category: Category = arrGratitude[indexPath.row].category_name?[0] {
                cell.lblCellMessage.text = category.categoryName
            }
        }
        
        return cell
    }
    
    func formatDateForCell(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateFromString = dateFormatter.date(from: date) else { return ""}
        dateFormatter.dateStyle = .medium
        let stringFromDate = dateFormatter.string(from: dateFromString)
        return stringFromDate
    }
}

extension GratitudeViewController {
    func didReceiveGratitudePreviousListResponse(gratitudeGetDataResponse: GratutudeGetListResponse?) {
        self.view.stopActivityIndicator()
        
        if(gratitudeGetDataResponse?.status != nil && gratitudeGetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(gratitudeGetDataResponse)
            
            if let arrGratitude = gratitudeGetDataResponse?.gratitudes {
                if arrGratitude.count > 0 {
                    arrayGratitude = arrGratitude
                    tblGratitude.reloadData()
                } else {
                    if let message = gratitudeGetDataResponse?.message {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
                    }
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveGratitudeDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
