//
//  HowToEarnPointsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-24.
//

import UIKit

class HowToEarnPointsViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var btnToday: UIBUtton_Designable!
    @IBOutlet var btnWeekly: UIBUtton_Designable!
    
    @IBOutlet var viewTime: UIView_Designable!
    
    @IBOutlet var tblSteps: UITableView!
    @IBOutlet var tblWater: UITableView!
    @IBOutlet var tblTime: UITableView!
    
    @IBOutlet var imgIconStep: UIImageView!
    @IBOutlet var imgIconWater: UIImageView!
    @IBOutlet var imgIconTime: UIImageView!
    
    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblWater: UILabel!
    
    @IBOutlet var constantViewStepHeight: NSLayoutConstraint!
    @IBOutlet var constantTblStepHeight: NSLayoutConstraint!
    @IBOutlet var constantViewWaterHeight: NSLayoutConstraint!
    @IBOutlet var constantTblWaterHeight: NSLayoutConstraint!
    @IBOutlet var constantViewTimeHeight: NSLayoutConstraint!
    @IBOutlet var constantTblTimeHeight: NSLayoutConstraint!
    @IBOutlet var constantViewScrollHeight: NSLayoutConstraint!
    
    var storeConstantViewStepHeight: CGFloat?
    var storeConstantTblStepHeight: CGFloat?
    var storeConstantViewWaterHeight: CGFloat?
    var storeConstantTblWaterHeight: CGFloat?
    var storeConstantViewTimeHeight: CGFloat?
    var storeConstantTblTimeHeight: CGFloat?
    var storeConstantViewScrollHeight: CGFloat?
    
    var arrStep = [HowToEarnModel]()
    var arrWater = [HowToEarnModel]()
    var arrTime = [HowToEarnModel]()
    
    var boolBtnToday = true
    private static let CellHeight = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        setupGUI()
        setupTableView()
        storeConstant()
        setupData()
        
        //call the button click function manually
        btnToday.sendActions(for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(FAQViewController.setupNotificationBadge),
//                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
//                                               object: nil)
//
//        setupNotificationBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }

    //MARK: Setup Custom Navbar--------------
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
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    fileprivate func setupGUI() {
        imgIconStep.backgroundColor = UIColor.colorSetup()
        imgIconWater.backgroundColor = UIColor.colorSetup()
        imgIconTime.backgroundColor = UIColor.colorSetup()
        
        imgIconStep.layer.cornerRadius = imgIconStep.frame.size.width/2
        imgIconWater.layer.cornerRadius = imgIconWater.frame.size.width/2
        imgIconTime.layer.cornerRadius = imgIconTime.frame.size.width/2
        
        lblStep.textColor = UIColor.colorSetup()
        lblWater.textColor = UIColor.colorSetup()
    }
    
    //MARK: -----Setup TableView
    fileprivate func setupTableView() {
        tblSteps.delegate = self
        tblSteps.dataSource = self
        
        tblWater.delegate = self
        tblWater.dataSource = self
        
        tblTime.delegate = self
        tblTime.dataSource = self
        
        tblSteps.separatorStyle = .none
        tblWater.separatorStyle = .none
        tblTime.separatorStyle = .none
        
        tblSteps.register(UINib.init(nibName: "HowToEarnTableViewCell", bundle: nil), forCellReuseIdentifier: "HowToEarnTableViewCell")
        tblWater.register(UINib.init(nibName: "HowToEarnTableViewCell", bundle: nil), forCellReuseIdentifier: "HowToEarnTableViewCell")
        tblTime.register(UINib.init(nibName: "HowToEarnTableViewCell", bundle: nil), forCellReuseIdentifier: "HowToEarnTableViewCell")
    }
    
    //MARK: -----Store Constant
    fileprivate func storeConstant() {
        storeConstantViewStepHeight = constantViewStepHeight.constant
        storeConstantTblStepHeight = constantTblStepHeight.constant
        storeConstantViewWaterHeight = constantViewWaterHeight.constant
        storeConstantTblWaterHeight = constantTblWaterHeight.constant
        storeConstantViewTimeHeight = constantViewTimeHeight.constant
        storeConstantTblTimeHeight = constantTblTimeHeight.constant
        storeConstantViewScrollHeight = constantViewScrollHeight.constant
    }
    
    //MARK: -----Setup Data
    fileprivate func setupData() {
        arrStep.append(HowToEarnModel(goal: "15,000# ", points: "1 points"))
        arrStep.append(HowToEarnModel(goal: "20,000# ", points: "2 points"))
        arrStep.append(HowToEarnModel(goal: "25,000# ", points: "3 points"))
        arrStep.append(HowToEarnModel(goal: "30,000# ", points: "4 points"))
        arrStep.append(HowToEarnModel(goal: "35,000# ", points: "5 points"))
        arrStep.append(HowToEarnModel(goal: "40,000# ", points: "6 points"))
        arrStep.append(HowToEarnModel(goal: "45,000# ", points: "7 points"))
        arrStep.append(HowToEarnModel(goal: "50,000# ", points: "8 points"))
        arrStep.append(HowToEarnModel(goal: "55,000# ", points: "9 points"))
        arrStep.append(HowToEarnModel(goal: "60,000# ", points: "10 points & so on"))
        
        arrWater.append(HowToEarnModel(goal: "7 litre# ", points: "1 points"))
        arrWater.append(HowToEarnModel(goal: "8 litre# ", points: "2 points"))
        arrWater.append(HowToEarnModel(goal: "9 litre# ", points: "3 points"))
        arrWater.append(HowToEarnModel(goal: "10 litre# ", points: "4 points"))
        arrWater.append(HowToEarnModel(goal: "11 litre# ", points: "5 points"))
        arrWater.append(HowToEarnModel(goal: "12 litre# ", points: "6 points"))
        arrWater.append(HowToEarnModel(goal: "13 litre# ", points: "7 points"))
        arrWater.append(HowToEarnModel(goal: "14 litre# ", points: "8 points"))
        arrWater.append(HowToEarnModel(goal: "15 litre# ", points: "9 points"))
        arrWater.append(HowToEarnModel(goal: "16 litre# ", points: "10 points & so on"))
        
        arrTime.append(HowToEarnModel(goal: "1 Hour = ", points: "4 points"))
        arrTime.append(HowToEarnModel(goal: "2 Hour = ", points: "8 points"))
        arrTime.append(HowToEarnModel(goal: "3 Hour = ", points: "12 points & so on"))
        
        tblSteps.reloadData()
        tblWater.reloadData()
        tblTime.reloadData()
    }
    
    //MARK: -----Button Func
    @IBAction func btnToday(_ sender: Any) {
        btnToday.backgroundColor = UIColor.colorSetup()
        btnToday.setTitleColor(.white, for: .normal)
        
        btnWeekly.backgroundColor = UIColor.white
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        boolBtnToday = true
        
        showHideTableView()
    }
    @IBAction func btnWeekly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.white
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.colorSetup()
        btnWeekly.setTitleColor(.white, for: .normal)
        
        boolBtnToday = false
        
        showHideTableView()
    }
    
    //MARK: -----Notification Setup
//    @objc func setupNotificationBadge() {
//        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }
//        
//        if badgeCount != 0 {
//            viewNotificationCount.isHidden = false
//            lblNotificationLabel.text = "\(badgeCount)"
//        } else {
//            viewNotificationCount.isHidden = true
//            lblNotificationLabel.text = "0"
//        }
//        print("BADGE COUNT-----\(badgeCount)")
//    }
}

extension HowToEarnPointsViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func showHideTableView() {
        if boolBtnToday {
            HideTableView(tableView: tblSteps)
            HideTableView(tableView: tblWater)
            ShowTableView(tableView: tblTime)
            
            viewTime.isHidden = false
            viewTime.alpha = 1.0
        } else {
            ShowTableView(tableView: tblSteps)
            ShowTableView(tableView: tblWater)
            HideTableView(tableView: tblTime)
            
            viewTime.isHidden = true
            viewTime.alpha = 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblSteps {
            return arrStep.count
        } else if tableView == tblWater {
            return arrWater.count
        } else {
            return arrTime.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblSteps {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HowToEarnTableViewCell", for: indexPath) as! HowToEarnTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(hexString: "#f5f5f5")
            } else {
                cell.backgroundColor = UIColor(hexString: "#fcfcfc")
            }
            
            cell.lblPointsInfo.text = "\(arrStep[indexPath.row].goal!)\(arrStep[indexPath.row].points!)"
            
            return cell
        } else if tableView == tblWater {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HowToEarnTableViewCell", for: indexPath) as! HowToEarnTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(hexString: "#f5f5f5")
            } else {
                cell.backgroundColor = UIColor(hexString: "#fcfcfc")
            }
            
            cell.lblPointsInfo.text = "\(arrWater[indexPath.row].goal!)\(arrWater[indexPath.row].points!)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HowToEarnTableViewCell", for: indexPath) as! HowToEarnTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(hexString: "#f5f5f5")
            } else {
                cell.backgroundColor = UIColor(hexString: "#fcfcfc")
            }
            
            cell.lblPointsInfo.text = "\(arrTime[indexPath.row].goal!)\(arrTime[indexPath.row].points!)"
            
            return cell
        }
    }
}

extension HowToEarnPointsViewController {
    fileprivate func AdjustTableviewHeight(tableView: UITableView, arrayCount: Int) {
        switch tableView {
        case tblSteps:
            let height: CGFloat = CGFloat(HowToEarnPointsViewController.CellHeight * arrayCount)
            
            self.constantTblStepHeight.constant = height
            self.constantViewStepHeight.constant = (self.storeConstantViewStepHeight! + height) - storeConstantTblStepHeight!
            self.constantViewScrollHeight.constant = (self.constantViewScrollHeight.constant + self.constantViewStepHeight.constant ) - storeConstantTblStepHeight!
            break
            
        case tblWater:
            let height: CGFloat = CGFloat(HowToEarnPointsViewController.CellHeight * arrayCount)
            
            self.constantTblWaterHeight.constant = height
            self.constantViewWaterHeight.constant = (self.storeConstantViewWaterHeight! + height) - storeConstantTblWaterHeight!
            self.constantViewScrollHeight.constant = (self.constantViewScrollHeight.constant + self.constantViewWaterHeight.constant ) - storeConstantTblWaterHeight!
            break
            
        case tblTime:
            let height: CGFloat = CGFloat(HowToEarnPointsViewController.CellHeight * arrayCount)
            
            self.constantTblTimeHeight.constant = height
            self.constantViewTimeHeight.constant = (self.storeConstantViewTimeHeight! + height) - storeConstantTblTimeHeight!
            self.constantViewScrollHeight.constant = (self.constantViewScrollHeight.constant + self.constantViewTimeHeight.constant ) - storeConstantTblTimeHeight!
            break
            
        default:
            break
        }
    }
    
    fileprivate func HideTableView(tableView: UITableView) {
        switch tableView {
        case tblSteps:
            AdjustTableviewHeight(tableView: tblSteps, arrayCount: 0)
            break
        case tblWater:
            AdjustTableviewHeight(tableView: tblWater, arrayCount: 0)
            break
        case tblTime:
            AdjustTableviewHeight(tableView: tblTime, arrayCount: 0)
            break
        default:
            break
        }
    }
    
    fileprivate func ShowTableView(tableView: UITableView) {
        switch tableView {
        case tblSteps:
            AdjustTableviewHeight(tableView: tblSteps, arrayCount: arrStep.count)
            break
        case tblWater:
            AdjustTableviewHeight(tableView: tblWater, arrayCount: arrWater.count)
            break
        case tblTime:
            AdjustTableviewHeight(tableView: tblTime, arrayCount: arrTime.count)
            break
        default:
            break
        }
    }
}
