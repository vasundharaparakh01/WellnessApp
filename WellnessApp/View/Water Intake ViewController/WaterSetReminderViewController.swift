//
//  WaterSetReminderViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 30/11/21.
//

import UIKit

fileprivate struct ExerciseTime {
    let time: String
}

class WaterReminderCell: UITableViewCell {
    
    @IBOutlet var viewBackground: UIView_Designable!
    @IBOutlet var imgRadio: UIImageView!
    @IBOutlet var lblOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.backgroundColor = UIColor(hexString: ConstantBackgroundHexColor.offWhite)
        viewBackground.layer.borderColor = UIColor.gray.cgColor
        viewBackground.layer.masksToBounds = false
        viewBackground.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        viewBackground.layer.shadowRadius = 2.0
        viewBackground.layer.shadowOpacity = 0.35
        
        imgRadio.tintColor = .gray
        
        lblOption.textColor = .gray
    }
}

class WaterSetReminderViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var imgClock: UIImageView!
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var btnSetGoal: UIBUtton_Designable!
    
    private var waterViewModel = WaterViewModel()
    private var selectedIndex: IndexPath?
    
    fileprivate var arrayTime = [ExerciseTime]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        waterViewModel.waterReminderDelegate = self
        
        setupData()
        setupGUI()
        
        getReminderListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
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
    private func setupData() {
        arrayTime.append(ExerciseTime(time: "1"))
        arrayTime.append(ExerciseTime(time: "2"))
        arrayTime.append(ExerciseTime(time: "3"))
        arrayTime.append(ExerciseTime(time: "4"))
        
        tblMain.reloadData()
    }
    
    private func setupGUI() {
        imgClock.tintColor = UIColor.colorSetup()
        btnSetGoal.backgroundColor = UIColor.colorSetup()
    }
    
    private func getReminderListData() {
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
            waterViewModel.getWaterReminder(token: token)
        }
    }

    //MARK: - Button Func
    @IBAction func btnRemove(_ sender: Any) {
        selectedIndex = IndexPath(row: 999, section: 0)
        tblMain.reloadData()
        PostReminder(duration: "0")
    }
    @IBAction func btnSetGoal(_ sender: Any) {
        PostReminder(duration: arrayTime[selectedIndex!.row].time)
    }
    
    fileprivate func PostReminder(duration: String) {
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
            let request = WaterReminderSetRequest(reminder: duration)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            waterViewModel.postWaterReminder(waterReminderRequest: request, token: token)
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

extension WaterSetReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaterReminderCell", for: indexPath) as! WaterReminderCell
        
        if selectedIndex == indexPath {
            cell.imgRadio.image = UIImage.init(named: "radioOn")
            cell.imgRadio.tintColor = UIColor.colorSetup()
            cell.viewBackground.layer.borderColor = UIColor.colorSetup().cgColor
            cell.lblOption.textColor = UIColor.colorSetup()
        } else {
            cell.imgRadio.image = UIImage.init(named: "radioOff")
            cell.imgRadio.tintColor = .gray
            cell.viewBackground.layer.borderColor = UIColor.gray.cgColor
            cell.lblOption.textColor = .gray
        }
        
        cell.lblOption.text = "\(arrayTime[indexPath.row].time) Hours"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tblMain.reloadData()
    }
}

extension WaterSetReminderViewController: WaterReminderDelegate {
    func didReceiveWaterReminderGetDataResponse(waterReminderGetDataResponse: WaterReminderGetResponse?) {
        self.view.stopActivityIndicator()
        
        if(waterReminderGetDataResponse?.status != nil && waterReminderGetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterReminderGetDataResponse)
            
            if let reminder = waterReminderGetDataResponse?.reminder {
                switch reminder {
                case 1:
                    selectedIndex = IndexPath(row: 0, section: 0)
                    tblMain.reloadData()
                    break
                    
                case 2:
                    selectedIndex = IndexPath(row: 1, section: 0)
                    tblMain.reloadData()
                    break
                    
                case 3:
                    selectedIndex = IndexPath(row: 2, section: 0)
                    tblMain.reloadData()
                    break
                case 4:
                    selectedIndex = IndexPath(row: 3, section: 0)
                    tblMain.reloadData()
                    break
                default:
                    
                    break
                }
            }
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveWaterReminderSetDataResponse(waterReminderSetDataResponse: WaterReminderSetResponse?) {
        self.view.stopActivityIndicator()
        
        if(waterReminderSetDataResponse?.status != nil && waterReminderSetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterReminderSetDataResponse)
            
            if let msg = waterReminderSetDataResponse?.message {                
                openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                        message: msg,
                                        alertStyle: .alert,
                                        actionTitles: ["OK"],
                                        actionStyles: [.default],
                                        actions: [
                                            { _ in
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        ])
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveWaterReminderDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
