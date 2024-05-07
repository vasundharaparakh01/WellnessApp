//
//  GratitudeAddViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 11/10/21.
//

import UIKit

let SectionCell1Height = 45

class GratitudeAddCell: UITableViewCell {
    
    @IBOutlet var imgRadioButton: UIImageView!
    @IBOutlet var lblGratitude: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgRadioButton.tintColor = .gray
    }
    
}

class GratitudeAddViewController: UIViewController, GratitudeAddDelegate, GratitudeSaveDelegate {
    
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var btnAddTodayGratitude: UIBUtton_Designable!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var imgCalender: UIImageView!
    @IBOutlet var viewTblBack: UIView!
    @IBOutlet var lblAddMessage: UILabel!
    @IBOutlet var tblGratitude: UITableView!
    @IBOutlet var txtViewOther: UITextView!
    @IBOutlet var btnSubmit: UIBUtton_Designable!
    
    //Constraint
    @IBOutlet var constantViewScrollMain: NSLayoutConstraint!
    @IBOutlet var constantViewBody: NSLayoutConstraint!
    @IBOutlet var constantViewTblBack: NSLayoutConstraint!
    @IBOutlet var constantTblMain: NSLayoutConstraint!
    
    var storeViewScrollMainConstant: CGFloat!
    var storeViewBodyConstant: CGFloat!
    var storeViewTblBackConstant: CGFloat!
    var storeTblMainConstant: CGFloat!
    
    var gratitudeViewModel = GratitudeViewModel()
    var selectedIndex: IndexPath?
    var arrayGratitude: [CategoryList]?
    var selectedGratitude: CategoryList?
    var stringOther: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        gratitudeViewModel.addDelegate = self
        gratitudeViewModel.saveDelegate = self
        
        setupGUI()
        storeConstraint()
        setupDate()
        getGratitudeCategoryData()
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
        txtViewOther.isUserInteractionEnabled = false
        
        btnAddTodayGratitude.setTitleColor(UIColor.colorSetup(), for: .normal)
        imgCalender.tintColor = UIColor.colorSetup()
        viewTblBack.layer.borderColor = UIColor.colorSetup().cgColor
        lblAddMessage.textColor = UIColor.colorSetup()
        txtViewOther.layer.cornerRadius = 10.0
        txtViewOther.layer.borderWidth = 1.0
        txtViewOther.layer.borderColor = UIColor.colorSetup().cgColor
        
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
               let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               
               print(crownList)
               print("chakra level ...--->>>",chakraLevel)
               print("coloris ...--->>>",chakraColour)
        
        if chakraColour == 0
        {
        switch chakraLevel {
        case 1:
            btnSubmit.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
            
        case 2:
            btnSubmit.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
            
        case 3:
            btnSubmit.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
            
        case 4:
            btnSubmit.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
            
        case 5:
            btnSubmit.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
        
        case 6:
            btnSubmit.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
            
        case 7:
            btnSubmit.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
            
        default:
            btnSubmit.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
            
            break
        }
        }else if crownList == 1
        {
            switch chakraColour {
            case 1:
                btnSubmit.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 2:
                btnSubmit.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 3:
                btnSubmit.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 4:
                btnSubmit.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 5:
                btnSubmit.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
            
            case 6:
                btnSubmit.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 7:
                btnSubmit.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            default:
                btnSubmit.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
            }
        }
        else{
            
            switch chakraLevel {
            case 1:
                btnSubmit.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 2:
                btnSubmit.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 3:
                btnSubmit.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 4:
                btnSubmit.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 5:
                btnSubmit.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
            
            case 6:
                btnSubmit.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            case 7:
                btnSubmit.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
                
            default:
                btnSubmit.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: true, leftToRight: false, topToBottom: false, bottomToTop: false)
                
                break
        }
        }
    }
    
    func storeConstraint() {
        storeViewScrollMainConstant = constantViewScrollMain.constant
        storeViewBodyConstant = constantViewBody.constant
        storeViewTblBackConstant = constantViewTblBack.constant
        storeTblMainConstant = constantTblMain.constant
    }
    
    func setupDate() {
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone.current
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormat.string(from: currentDate)
        txtDate.text = date
    }
    
    func getGratitudeCategoryData() {
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
            gratitudeViewModel.getGratitudeCategoryList(token: token)
        }
    }
    
    //MARK: - Button Func
    @IBAction func btnSubmit(_ sender: Any) {
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
            
            guard let selectedData = selectedGratitude else { return }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            let request: GratitudeAddRequest
            if stringOther == nil {
                request = GratitudeAddRequest(categoryId: selectedData.categoryId, message: nil)
                gratitudeViewModel.saveGratitudeCategory(addGratitudeRequest: request, token: token)
            } else {
                if txtViewOther.text != nil && txtViewOther.text.count > 0 && txtViewOther.text != "" {
                    request = GratitudeAddRequest(categoryId: selectedData.categoryId, message: txtViewOther.text)
                    gratitudeViewModel.saveGratitudeCategory(addGratitudeRequest: request, token: token)
                } else {
                    self.view.stopActivityIndicator()
                    showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.EnterGratitude)
                }
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

extension GratitudeAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrGratitude = arrayGratitude else { return 0 }
        return arrGratitude.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GratitudeAddCell", for: indexPath) as! GratitudeAddCell
        
        guard let arrGratitudeCategory = arrayGratitude else { return cell }
        
        if let gratitudeCategoryName = arrGratitudeCategory[indexPath.row].categoryName {
            cell.lblGratitude.text = gratitudeCategoryName
        }
        
        if selectedIndex == indexPath {
            cell.imgRadioButton.image = UIImage.init(named: "radioOn")
        } else {
            cell.imgRadioButton.image = UIImage.init(named: "radioOff")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedGratitude = arrayGratitude?[indexPath.row]
        
        if let gratitudeCategoryName = arrayGratitude?[indexPath.row].categoryName {
            if gratitudeCategoryName == "Other" {
                stringOther = gratitudeCategoryName
                txtViewOther.isUserInteractionEnabled = true
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantAlertMessage.EnterGratitude)
            } else {
                stringOther = nil
                txtViewOther.isUserInteractionEnabled = false
                txtViewOther.text = nil
            }
        }
        
        selectedIndex = indexPath
        tblGratitude.reloadData()
    }
    
    //MARK: - UTILITY
    func AdjustTableHeightForSection(arrayCount: NSInteger) {
        let height = CGFloat(SectionCell1Height * arrayCount)
        constantTblMain.constant = height
        constantViewTblBack.constant = (constantViewTblBack.constant + height) - storeTblMainConstant
        constantViewBody.constant = (constantViewBody.constant + height) - storeTblMainConstant
        constantViewScrollMain.constant = (constantViewScrollMain.constant + height) - storeTblMainConstant
    }
}

extension GratitudeAddViewController {
    func didReceiveGratitudeCategoryListResponse(gratitudeCategoryResponse: GratitudeCategoryResponse?) {
        self.view.stopActivityIndicator()
        
        if(gratitudeCategoryResponse?.status != nil && gratitudeCategoryResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(gratitudeCategoryResponse)
            
            if let arrGratitude = gratitudeCategoryResponse?.categories {
                if arrGratitude.count > 0 {
                    arrayGratitude = arrGratitude
                    tblGratitude.reloadData()
                    AdjustTableHeightForSection(arrayCount: arrGratitude.count)
                }
//                else {
//                    if let message = gratitudeGetDataResponse?.message {
//                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
//                    }
//                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveGratitudeSaveResponse(gratitudeAddResponse: GratitudeAddResponse?) {
        self.view.stopActivityIndicator()
        if(gratitudeAddResponse?.status != nil && gratitudeAddResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(gratitudeAddResponse)
                        
            if let message = gratitudeAddResponse?.message {
                popToRootVC(msg: message)
            } else {
                popToRootVC(msg: ConstantStatusAPI.success)
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: gratitudeAddResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveGratitudeDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    fileprivate func popToRootVC(msg: String) {
        openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                message: msg,
                                alertStyle: .alert, actionTitles: ["OK"],
                                actionStyles: [.default],
                                actions: [
                                    {
                                        _ in
                                        
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }])
    }
}
