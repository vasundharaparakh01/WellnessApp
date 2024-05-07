//
//  BreathExerciseViewAllViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 21/10/21.
//

import UIKit

class BreathExerciseCell: UITableViewCell {
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

class BreathExerciseViewAllViewController: UIViewController {

    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var tblMain: UITableView!
    
    var breathViewModel = BreathingExerciseViewModel()
    var arrayExerciseList = [BreathExerciseList]()
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        breathViewModel.delegate = self
        
        getBreathingListData()
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
    
    func getBreathingListData() {
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
            breathViewModel.getBreathExerciseList(token: token)
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

extension BreathExerciseViewAllViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayExerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreathExerciseCell", for: indexPath) as! BreathExerciseCell
        
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
        
        cell.lblOption.text = arrayExerciseList[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tblMain.reloadData()
        
        print(arrayExerciseList)
        
        // Default will be current blocked chakra coming from chakra level api
//        guard let blockedChakraID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraID) as? String else { return }
//        guard let blockedChakraName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraName) as? String else { return }
        //Temporary data - Root Chakra as default blocked chakra----------------
        let blockedChakraID = ConstantChakraID.rootChakra
        let blockedChakraName = ConstantChakraName.rootChakra
        
        //Store relax breathing & music breathing id and do check on audio player view controller
        if arrayExerciseList[indexPath.row].exerciseId == ConstantBreathExerciseID.relaxBreath {
            UserDefaults.standard.set(arrayExerciseList[indexPath.row].exerciseId, forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
            UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
            
        } else if arrayExerciseList[indexPath.row].exerciseId == ConstantBreathExerciseID.musicBreath {
            UserDefaults.standard.set(arrayExerciseList[indexPath.row].exerciseId, forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
            UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
            
        } else {
            UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
            UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
        }
        
        let meditationAudioRequestData = MeditationAudioRequest(meditationId: ConstantMeditationID.blockedChakras, chakraId: blockedChakraID, chakraName: blockedChakraName, exerciseId: arrayExerciseList[indexPath.row].exerciseId, exerciseName: arrayExerciseList[indexPath.row].name, time: nil, VCName: ConstantMeditationStaticName.blocked)
        
        let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
        exerciseTimeVC.hideSkipBtn = true
        exerciseTimeVC.meditationAudioRequestData = meditationAudioRequestData
        navigationController?.pushViewController(exerciseTimeVC, animated: true)
    }
}

extension BreathExerciseViewAllViewController: BreathingExerciseViewModelDelegate {
    func didReceiveBreathingExerciseListDataResponse(breathingExerciseListDataResponse: BreathExerciseListResponse?) {
        self.view.stopActivityIndicator()
        
        if(breathingExerciseListDataResponse?.status != nil && breathingExerciseListDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(breathingExerciseListDataResponse)
            
            if let arrExercise = breathingExerciseListDataResponse?.exercises {
                if arrExercise.count > 0 {
                    arrayExerciseList = arrExercise
                    tblMain.reloadData()
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveBreathingExerciseListDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
