//
//  MeditationQuestionTimeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 21/10/21.
//

import UIKit

fileprivate struct ExerciseTime {
    let time: String
}

class ExerciseTimeCell: UITableViewCell {
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

class MeditationQuestionTimeViewController: UIViewController {
    
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var viewHiddenPopup: UIView!
    @IBOutlet var lblAboutBreathing: UILabel!
    @IBOutlet var btnDone: UIBUtton_Designable!

    @IBOutlet var tblMain: UITableView!
    @IBOutlet var btnSkip: UIBUtton_Designable!
    
    var meditationAudioRequestData: MeditationAudioRequest? //Coming from first page
    var meditationAudioViewModel = MeditationAudioViewModel()
    fileprivate var arrayTime = [ExerciseTime]()
    var selectedIndex: IndexPath?
    var hideSkipBtn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Setup navbar
        setupCustomNavBar()
        
        meditationAudioViewModel.delegateAudioCheck = self
        
        setupPopupUI()
        setupData()
        setupUI()
        showPopup()
        
        debugPrint(meditationAudioRequestData as Any)
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
    
    func setupPopupUI() {
        lblAboutBreathing.textColor = UIColor.colorSetup()
        btnDone.backgroundColor = UIColor.colorSetup()
        btnSkip.backgroundColor = UIColor.colorSetup()
    }
    
    func showPopup() {
        let status = UserDefaults.standard.bool(forKey: "isFromMeditation")
        print(status)
        
        if status==true
        {
        viewHiddenPopup.isHidden = false
        viewHiddenPopup.alpha = 1.0
        }
        else
        {
            viewHiddenPopup.isHidden = true
            viewHiddenPopup.alpha = 1.0
        }
    }
    
    func setupData() {
        arrayTime.append(ExerciseTime(time: "02"))
        arrayTime.append(ExerciseTime(time: "03"))
        arrayTime.append(ExerciseTime(time: "04"))
        arrayTime.append(ExerciseTime(time: "05"))
    }
    
    func setupUI() {
        if hideSkipBtn == true {
            btnSkip.isHidden = true
        } else {
            btnSkip.isHidden = false
        }
    }
    
    //MARK: - Button Func
    @IBAction func btnDone(_ sender: Any) {
        viewHiddenPopup.isHidden = true
        viewHiddenPopup.alpha = 0.0
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        let audioListVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationAudioListViewController") as! MeditationAudioListViewController
//        meditationAudioRequestData?.exerciseId = ""
        audioListVC.meditationAudioRequest = meditationAudioRequestData
        navigationController?.pushViewController(audioListVC, animated: true)
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

extension MeditationQuestionTimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTimeCell", for: indexPath) as! ExerciseTimeCell
        
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
        
        cell.lblOption.text = "\(arrayTime[indexPath.row].time) Mins"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tblMain.reloadData()
        
        meditationAudioRequestData?.time = arrayTime[indexPath.row].time
        
        checkAudioPlay()
    }
    
    fileprivate func checkAudioPlay() {
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
            
            let request = MeditationAPIRequest(meditationId: meditationAudioRequestData?.meditationId, chakraId: meditationAudioRequestData?.chakraId, exerciseId: meditationAudioRequestData?.exerciseId)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            meditationAudioViewModel.getMeditationAudioCheck(meditationAudioRequest: request, token: token)
        }
    }
    
    func PushToVc(VCCase: Int) {
        switch VCCase {
        case 1: //Music Listing Page
            let audioListVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationAudioListViewController") as! MeditationAudioListViewController
            audioListVC.meditationAudioRequest = self.meditationAudioRequestData
            self.navigationController?.pushViewController(audioListVC, animated: true)
            
            break
            
        case 2: //Music Player Page
            let audioPlayerVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationAudioPlayerViewController") as! MeditationAudioPlayerViewController
            audioPlayerVC.meditationAudioRequest = self.meditationAudioRequestData
            navigationController?.pushViewController(audioPlayerVC, animated: true)
            
            break
        default:
            break
        }
    }
}

extension MeditationQuestionTimeViewController: MeditationAudioCheckViewModelDelegate {
    func didReceiveAudioCheckDataResponse(audioCheckDataResponse: MeditationAudioCheckResponse?) {
        self.view.stopActivityIndicator()
        
        if(audioCheckDataResponse?.status != nil && audioCheckDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(audioCheckDataResponse)
            
            ///If a user do a exercise for a particular day then he cannot do another exercise session for that day. He has to come back next day for exercise. (Soumalya - 07/12/2021)
            ///Check if 'completed' inside music array is 0 or > 0.
            ///If 0 then  go to music player page
            ///if > 0 then go to all music listing page
            ///
            ///
         
            
            if let arrayMusic = audioCheckDataResponse?.musics {
                
                print(arrayMusic)
                
                if arrayMusic.count > 0 {
                    if let complete = arrayMusic[0].completed {
                        if complete > 0 {
                            PushToVc(VCCase: 2)
                            
                           
//                          //  print(musicName as Any)
//
//                          //  You have already done your box breathing exercise for today
//
//                            let refreshAlert = UIAlertController(title: "Luvo", message: "You have already done your " + arrayMusic[0].musicName! + " for Today" , preferredStyle: UIAlertController.Style.alert)
//
//                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                                  print("Handle Ok logic here")
//                                let introVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//                                self.navigationController?.pushViewController(introVC, animated: false)
//
//                            }))
//
//                            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                                  print("Handle Cancel Logic here")
//                            }))
//
//                            present(refreshAlert, animated: true, completion: nil)

                           
                            
                        } else {
                            PushToVc(VCCase: 2)
                        }
                    }
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveAudioCheckDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
}
