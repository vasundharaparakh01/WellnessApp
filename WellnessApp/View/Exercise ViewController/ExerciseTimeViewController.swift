//
//  ExerciseTimeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/11/21.
//

import UIKit

fileprivate struct ExerciseTime {
    let time: String
}

class ExerciseDurationCell: UITableViewCell {
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

class ExerciseTimeViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var btnWalk: UIBUtton_Designable!
    @IBOutlet var btnRun: UIBUtton_Designable!
    @IBOutlet var lblSteps: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var viewMinute: UIView_Designable!
    @IBOutlet var txtCustomMin: UITextField!
    @IBOutlet var btnNext: UIBUtton_Designable!
    
    fileprivate var arrayTime = [ExerciseTime]()
    var selectedIndex: IndexPath?
    var totalStepGoal: String?
    var stepAcheived: String?
    var exerciseFinishModel: ExerciseFinishRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        setupGUI()
        setupData()
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
    
    func setupGUI() {
        btnWalk.layer.borderColor = UIColor.gray.cgColor
        btnWalk.setTitleColor(UIColor.gray, for: .normal)
        btnWalk.tintColor = UIColor.gray
        
        btnRun.layer.borderColor = UIColor.gray.cgColor
        btnRun.setTitleColor(UIColor.gray, for: .normal)
        btnRun.tintColor = UIColor.gray
        
        viewMinute.layer.borderColor = UIColor.colorSetup().cgColor
        viewMinute.isHidden = true
        txtCustomMin.textColor = UIColor.colorSetup()
        
        btnEdit.backgroundColor = UIColor.colorSetup()
        btnNext.backgroundColor = UIColor.colorSetup()
    }
    
    func setupData() {
        
        let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                        print(status)
                        
                        if status==true
                {
        exerciseFinishModel = ExerciseFinishRequest(targetTime: nil, completedTime: nil, type: nil, steps: nil, miles: nil, add_date: nil, gpsDistance: nil, device_cat: "watch")
                            
                        }
        else
        {
            exerciseFinishModel = ExerciseFinishRequest(targetTime: nil, completedTime: nil, type: nil, steps: nil, miles: nil, add_date: nil, gpsDistance: nil, device_cat: "mobile")
        }
        
        ///Show total steps stored in App delegate background step tracking
//        if let storedSteps = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udStepsCount) {
//            if let steps = exerciseFinishModel?.targetSteps {
//                lblSteps.text = "\(storedSteps)/\(steps)"
//            }
//        } else {
//            if let steps = exerciseFinishModel?.targetSteps {
//                lblSteps.text = "0/\(steps)"
//            }
//        }
//        if let storedSteps = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udStepsCount) {
        if let stepAcheive = stepAcheived {
            if let steps = totalStepGoal {
                lblSteps.text = "\(stepAcheive)/\(steps)"
            }
        }
        
        arrayTime.append(ExerciseTime(time: "05"))
        arrayTime.append(ExerciseTime(time: "10"))
        arrayTime.append(ExerciseTime(time: "20"))
        arrayTime.append(ExerciseTime(time: "Enter Manual Choice"))
    }
    
    //MARK: - Button Func
    @IBAction func btnWalk(_ sender: Any) {
        btnWalk.layer.borderColor = UIColor.colorSetup().cgColor
        btnWalk.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnWalk.tintColor = UIColor.colorSetup()
        
        btnRun.layer.borderColor = UIColor.gray.cgColor
        btnRun.setTitleColor(UIColor.gray, for: .normal)
        btnRun.tintColor = UIColor.gray
        
        exerciseFinishModel?.type = "walk"
    }
    
    @IBAction func btnRun(_ sender: Any) {
        btnRun.layer.borderColor = UIColor.colorSetup().cgColor
        btnRun.setTitleColor(UIColor.colorSetup(), for: .normal)
        btnRun.tintColor = UIColor.colorSetup()
        
        btnWalk.layer.borderColor = UIColor.gray.cgColor
        btnWalk.setTitleColor(UIColor.gray, for: .normal)
        btnWalk.tintColor = UIColor.gray
        
        exerciseFinishModel?.type = "run"
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if selectedIndex?.row == 3 {
            exerciseFinishModel?.targetTime = txtCustomMin.text
        }
        guard let exerciseData = exerciseFinishModel else { return }
        if Validate(data: exerciseData) == true {
            let exerciseStartVC = ConstantStoryboard.exerciseStoryboard.instantiateViewController(withIdentifier: "ExerciseStartViewController") as! ExerciseStartViewController
            exerciseStartVC.stepGoal = totalStepGoal
            exerciseStartVC.exerciseFinishRequest = exerciseFinishModel
            navigationController?.pushViewController(exerciseStartVC, animated: true)
        }
    }
    
    func Validate(data: ExerciseFinishRequest) -> Bool {
        if data.type != nil {
            if data.targetTime != nil {
                return true
            } else {
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Select duration")
                return false
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Select walk or run")
            return false
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

extension ExerciseTimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseDurationCell", for: indexPath) as! ExerciseDurationCell
        
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
        
        if indexPath.row == 3 {
            viewMinute.isHidden = false
            txtCustomMin.text = ""
        } else {
            viewMinute.isHidden = true
            txtCustomMin.text = ""
            exerciseFinishModel?.targetTime = arrayTime[indexPath.row].time
        }
    }
}

extension ExerciseTimeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtCustomMin) {
            if (range.location == 0 && string == " ") {
                return false
            } else if (newString.count > 3) {
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
