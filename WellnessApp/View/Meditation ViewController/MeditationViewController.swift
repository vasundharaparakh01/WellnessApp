//
//  MeditationViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 01/10/21.
//

import UIKit

//struct MeditationIDs {
//    let meditationId: String
//}

var isFromTabarMeditation = false   //To disable tableview selection highlight when coming from tabbar

class MeditationCell: UITableViewCell {
    
    @IBOutlet var viewBackground: UIView_Designable!
    @IBOutlet var imgCellIcon: UIImageView!
    @IBOutlet var lblCellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgCellIcon.layer.cornerRadius = imgCellIcon.frame.size.width / 2
        imgCellIcon.layer.masksToBounds = false
        imgCellIcon.clipsToBounds = true
        
        viewBackground.clipsToBounds = true
    }
}

class MeditationViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    //Not neede here. Remove after
    @IBOutlet var viewHiddenPopup: UIView!
    @IBOutlet var lblAboutBreathing: UILabel!
    @IBOutlet var btnDone: UIBUtton_Designable!
    //----------------

    @IBOutlet var tblMeditaion: UITableView!
    
    var arrayMeditationList = [MeditationModel]()
    var meditationViewModel = MeditationViewModel()
    var badgeData = [BadgeModel]()
//    var arrayMeditationIDs = [MeditationIDs]()
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        meditationViewModel.meditationBadgeDelegate = self
        
//        setupPopupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        
        if isFromTabarMeditation {
            selectedIndex = nil
            tblMeditaion.reloadData()
        }
        
        let startDate = Date().formatDate(date: Date())
        let endDate = Date().formatDate(date: Date())
        
        getMeditationBadgeData(startDate: startDate, endDate: endDate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
    
    func setupData() {
        arrayMeditationList.append(MeditationModel(image: "meditate", title: "Meditation for blocked chakras", isViewBackgroundColor: false, meditationId: ConstantMeditationID.blockedChakras))
        arrayMeditationList.append(MeditationModel(image: "performance", title: "Guided Meditation", isViewBackgroundColor: false, meditationId: ConstantMeditationID.guidedMeditation))
        arrayMeditationList.append(MeditationModel(image: "loudspeaker", title: "Meditation for Manifestation", isViewBackgroundColor: false, meditationId: ConstantMeditationID.manifestation))
        arrayMeditationList.append(MeditationModel(image: "performance", title: "Meditation for high performance", isViewBackgroundColor: false, meditationId: ConstantMeditationID.highPerformance))
       
        arrayMeditationList.append(MeditationModel(image: "music", title: "Soothing music videos", isViewBackgroundColor: false, meditationId: nil))
        arrayMeditationList.append(MeditationModel(image: "Group 9133", title: "Points", isViewBackgroundColor: false, meditationId: nil))
        
//        arrayMeditationIDs.append(MeditationIDs(meditationId: ConstantMeditationID.blockedChakras))
//        arrayMeditationIDs.append(MeditationIDs(meditationId: ConstantMeditationID.manifestation))
//        arrayMeditationIDs.append(MeditationIDs(meditationId: ConstantMeditationID.highPerformance))
        
        tblMeditaion.reloadData()
    }
    
    //MARK: -----Get Meditation Badge Data
    fileprivate func getMeditationBadgeData(startDate: String, endDate: String) {
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
            let request = MeditationBadgeRequest(startDate: startDate, endDate: endDate)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationViewModel.getMeditationBadge(meditationBadgeRequest: request, token: token)
        }
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
        print("Meditation BADGE COUNT-----\(badgeCount)")
    }
    
    /*
    func setupPopupUI() {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
        
        lblAboutBreathing.textColor = UIColor.colorSetup()
        btnDone.backgroundColor = UIColor.colorSetup()
    }
    
    func showPopup() {
        viewHiddenPopup.isHidden = false
        viewHiddenPopup.alpha = 1.0
    }
    
    //MARK: - Button Func
    @IBAction func btnDone(_ sender: Any) {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
        
        let blockedChakraID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraID) as! String
        
        guard let indexpath = selectedIndex else { return }
        switch indexpath.row {
//        case 0:
//            let exerciseLevelVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationLevelsViewController") as! MeditationLevelsViewController
//            exerciseLevelVC.meditationAudioRequestData = MeditationAudioRequest(meditationId: arrayMeditationIDs[indexpath.row].meditationId, chakraId: nil, exerciseId: nil, exerciseName: nil, time: nil)
//            navigationController?.pushViewController(exerciseLevelVC, animated: true)
//
//            break
        case 1:
            let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
            exerciseTimeVC.hideSkipBtn = false
            exerciseTimeVC.meditationAudioRequestData = MeditationAudioRequest(meditationId: arrayMeditationIDs[indexpath.row].meditationId, chakraId: blockedChakraID, exerciseId: ConstantBreathExerciseID.boxBreathing, exerciseName: ConstantBreathExerciseName.boxBreathing, time: nil)
            navigationController?.pushViewController(exerciseTimeVC, animated: true)
            break
        case 2:
            let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
            exerciseTimeVC.hideSkipBtn = false
            exerciseTimeVC.meditationAudioRequestData = MeditationAudioRequest(meditationId: arrayMeditationIDs[indexpath.row].meditationId, chakraId: blockedChakraID, exerciseId: ConstantBreathExerciseID.boxBreathing, exerciseName: ConstantBreathExerciseName.boxBreathing, time: nil)
            navigationController?.pushViewController(exerciseTimeVC, animated: true)
            break
        case 3:
            let soothingVC = ConstantStoryboard.soothingMusicVideo.instantiateViewController(withIdentifier: "SoothingVideosListViewController") as! SoothingVideosListViewController
            navigationController?.pushViewController(soothingVC, animated: true)
            break
            
        default:
            break
        }
    }*/
}

extension MeditationViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMeditationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeditationCell", for: indexPath) as! MeditationCell
        
        let meditationData = arrayMeditationList[indexPath.row]
        
        if selectedIndex == indexPath {
            cell.imgCellIcon.backgroundColor = .white
            cell.imgCellIcon.tintColor = UIColor.colorSetup()
            cell.lblCellTitle.textColor = .white
            
            cell.viewBackground.backgroundColor = UIColor.colorSetup()
            
            /*
            //Color setup according to chakra level
            let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1

            switch chakraLevel {
            case 1:
                cell.viewBackground.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break

            case 2:
                cell.viewBackground.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break

            case 3:
                cell.viewBackground.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break

            case 4:
                cell.viewBackground.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break

            case 5:
                cell.viewBackground.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break

            case 6:
                cell.viewBackground.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break

            case 7:
                cell.viewBackground.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break

            default:
                cell.viewBackground.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)

                break
            }
             */
        } else {
            cell.viewBackground.backgroundColor = UIColor.white
            cell.imgCellIcon.backgroundColor = UIColor.colorSetup()
            cell.imgCellIcon.tintColor = UIColor.white
            cell.lblCellTitle.textColor = .black
        }
        
        cell.imgCellIcon.image = UIImage.init(named: meditationData.image)
        cell.lblCellTitle.text = meditationData.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isFromTabarMeditation = false
        
        selectedIndex = indexPath
        tblMeditaion.reloadData()
        
//        guard let blockedChakraID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraID) else { return }
        guard let defaultExerciseID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultExerciseID) else { return }
        guard let defaultExerciseName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udDefaultExerciseName) else { return }
        
        UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
        UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
        
        ///Exercise id will be blank for all the time on MeditationAudioListViewController page
        ///If chakrId has data then send it otherwise don't
        ///Send default exercise id from above (guard let defaultExerciseID) coming from JSON response on HomeVCExt
        ///If from blog ( Home page ), send default chakra as ROOT CHAKRA else chakra will be selected on Meditation for Block Chakra & blank for Manifestation and High Performance
        
        let meditationData = arrayMeditationList[indexPath.row]
        
        switch indexPath.row {
        case 0:
//            selectedIndex = indexPath
//            showPopup()
            UserDefaults.standard.set(true, forKey: "isFromMeditation")
            let exerciseLevelVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationLevelsViewController") as! MeditationLevelsViewController
            exerciseLevelVC.meditationAudioRequestData = MeditationAudioRequest(meditationId: meditationData.meditationId, chakraId: "", exerciseId: defaultExerciseID as? String, exerciseName: defaultExerciseName as? String, time: nil, VCName: ConstantMeditationStaticName.blocked)
            navigationController?.pushViewController(exerciseLevelVC, animated: true)
            break
        case 2:
//            selectedIndex = indexPath
//            showPopup()
            UserDefaults.standard.set(true, forKey: "isFromMeditation")
            let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
            exerciseTimeVC.hideSkipBtn = false
            exerciseTimeVC.meditationAudioRequestData = MeditationAudioRequest(meditationId: meditationData.meditationId, chakraId: "", exerciseId: defaultExerciseID as? String, exerciseName: defaultExerciseName as? String, time: nil, VCName: ConstantMeditationStaticName.manifestation)
            navigationController?.pushViewController(exerciseTimeVC, animated: true)
            break
        case 3:
//            selectedIndex = indexPath
//            showPopup()
            UserDefaults.standard.set(true, forKey: "isFromMeditation")
            let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
            exerciseTimeVC.hideSkipBtn = false
            exerciseTimeVC.meditationAudioRequestData = MeditationAudioRequest(meditationId: meditationData.meditationId, chakraId: "", exerciseId: defaultExerciseID as? String, exerciseName: defaultExerciseName as? String, time: nil, VCName: ConstantMeditationStaticName.performance)
            navigationController?.pushViewController(exerciseTimeVC, animated: true)
            break
        case 1:
//            selectedIndex = indexPath  MeditationAudioListViewController
//            showPopup()
            UserDefaults.standard.set(true, forKey: "isFromMeditation")
            let MeditationVC = ConstantStoryboard.Meditation.instantiateViewController(withIdentifier: "MeditationAudioListViewController") as! MeditationAudioListViewController
            MeditationVC.meditationAudioRequest = MeditationAudioRequest(meditationId: meditationData.meditationId, chakraId: "", exerciseId: defaultExerciseID as? String, exerciseName: defaultExerciseName as? String, time: nil, VCName: ConstantMeditationStaticName.guided)
            navigationController?.pushViewController(MeditationVC, animated: true)
            

            break
        case 4:
//            selectedIndex = indexPath  MeditationAudioListViewController
//            showPopup()
            UserDefaults.standard.set(true, forKey: "isFromMeditation")
            let soothingVC = ConstantStoryboard.soothingMusicVideo.instantiateViewController(withIdentifier: "SoothingVideosListViewController") as! SoothingVideosListViewController
            navigationController?.pushViewController(soothingVC, animated: true)
            break
            
        case 5:
            UserDefaults.standard.set(true, forKey: "isFromMeditation")
            let badgeVC = ConstantStoryboard.badgesStoryboard.instantiateViewController(withIdentifier: "BadgeViewController") as! BadgeViewController
//            if let userBadge = badgeData {
                badgeVC.arrBadgeData = badgeData
//            }
            badgeVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            navigationController?.present(badgeVC, animated: true)            
            break
            
        default:
            break
        }
    }
}

extension MeditationViewController: MeditationBadgeDelegate {
    func didReceiveMeditationBadgeDataResponse(meditationBadgeDataResponse: MeditationBadgeResponse?) {
        self.view.stopActivityIndicator()
        
        if(meditationBadgeDataResponse?.status != nil && meditationBadgeDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(meditationBadgeDataResponse)
            
            if let data = meditationBadgeDataResponse?.user_badges {
                if data.count > 0 {
                    badgeData = data
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveMeditationBadgeDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    
}
