//
//  ExerciseViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 08/11/21.
//

import UIKit

var isFromBackExercise = false

class ExerciseViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var viewSteps: UIView_Designable!
    @IBOutlet var btnSave: UIBUtton_Designable!
    @IBOutlet var txtSteps: UITextField!
    var isFromSave = false
    var isGoalSet = false
//    var tempStepAcheive = ""
    
    
    var exerciseViewModel = ExerciseViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Setup navbar
        setupCustomNavBar()
        
        exerciseViewModel.getGoalDelegate = self

        setupGUI()
        getDailyGoal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFromSave = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        
        if isGoalSet && !isFromBackExercise {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                if self.tempStepAcheive.count > 0 {
//                    self.sentToNextPage(stepAcheived: self.tempStepAcheive)
//                } else {
                    self.getDailyGoal()
//                }
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
    
    func setupGUI() {
        viewSteps.layer.borderColor = UIColor.colorSetup().cgColor
        txtSteps.textColor = UIColor.colorSetup()
        btnSave.backgroundColor = UIColor.colorSetup()
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
            exerciseViewModel.getDailyGoal(token: token)
        }
    }
    
    //MARK: - Button Func
    @IBAction func btnSave(_ sender: Any) {
        isFromSave = true
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
            let dailyGoal = RemoveZeroFromPrefix(stringNum: txtSteps.text)
            UserDefaults.standard.set(dailyGoal, forKey: "UpdatedSteps")
            UserDefaults.standard.set(true, forKey: "isFromSave")
            let request = ExerciseGoalRequest(daily_goal: dailyGoal)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            exerciseViewModel.setDailyGoal(goalRequest: request, token: token)
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

extension ExerciseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtSteps) {
            if (range.location == 0 && string == " ") {
                return false
            } else if (newString.count > 5) {
                return false
            } else {
                guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return false
                }
            }
        }
        return true
    }
}

extension ExerciseViewController: GetGoalDelegate {
    func didReceiveGoalDataResponse(exerciseGoalDataResponse: ExerciseGoalResponse?) {
        self.view.stopActivityIndicator()
        
        if(exerciseGoalDataResponse?.status != nil && exerciseGoalDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(exerciseGoalDataResponse)
            
            if let goal = exerciseGoalDataResponse?.dailyGoal {
                txtSteps.text = String(goal)
                if goal != 0 {
                    //Carry forward today steps acheived
                    if let stepAcheive = exerciseGoalDataResponse?.todaySteps {
//                        tempStepAcheive = "\(stepAcheive)"
                        self.sentToNextPage(stepAcheived: "\(stepAcheive)")
                    } else {
//                        tempStepAcheive = "0"
                        self.sentToNextPage(stepAcheived: "0")
                    }
                }
            } else {
                openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                        message: exerciseGoalDataResponse?.message ?? "Success",
                                        alertStyle: .alert,
                                        actionTitles: ["OK"],
                                        actionStyles: [.default],
                                        actions: [
                                            { _ in
                                                //Carry forward today steps acheived
                                                //Goto next page
                                                if let stepAcheive = exerciseGoalDataResponse?.todaySteps {
//                                                    self.tempStepAcheive = "\(stepAcheive)"
                                                    self.sentToNextPage(stepAcheived: "\(stepAcheive)")
                                                } else {
//                                                    self.tempStepAcheive = "0"
                                                    self.sentToNextPage(stepAcheived: "0")
                                                }
//                                                let exerciseTimeVC = ConstantStoryboard.exerciseStoryboard.instantiateViewController(withIdentifier: "ExerciseTimeViewController") as! ExerciseTimeViewController
//                                                exerciseTimeVC.exerciseFinishModel = ExerciseFinishRequest(targetSteps: self.txtSteps.text, targetTime: nil, completedTime: nil, type: nil, steps: nil, miles: nil)
//                                                self.navigationController?.pushViewController(exerciseTimeVC, animated: true)
                                            }
                                        ])
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: exerciseGoalDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveGoalDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func sentToNextPage(stepAcheived: String) {
        isFromBackExercise = true
        isGoalSet = true
        
        let status = UserDefaults.standard.bool(forKey: "FromHomeEdit")
                        print(status)
            if status == true
        {
                debugPrint("HElo")
                if isFromSave == true
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    
                }
                
            }
        
        else
        {
        
        let exerciseTimeVC = ConstantStoryboard.exerciseStoryboard.instantiateViewController(withIdentifier: "ExerciseTimeViewController") as! ExerciseTimeViewController
        exerciseTimeVC.totalStepGoal = RemoveZeroFromPrefix(stringNum: txtSteps.text)
        exerciseTimeVC.stepAcheived = stepAcheived
//        exerciseTimeVC.exerciseFinishModel = ExerciseFinishRequest(targetTime: nil, completedTime: nil, type: nil, steps: nil, miles: nil)
        self.navigationController?.pushViewController(exerciseTimeVC, animated: true)
        }
    }
    
    func RemoveZeroFromPrefix(stringNum: String?) -> String {
        guard let stepString = stringNum else { return "" }
        let numberString = stepString
        let numberAsInt = Int(numberString)
        let backToString = "\(numberAsInt!)"
        return backToString
    }
}
