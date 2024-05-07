//
//  FAQViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-20.
//

import UIKit

class FAQViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var tblMain: UITableView!
    @IBOutlet var imgSemiCircleBack: UIImageView!
    
    var faqViewModel = FAQViewModel()
    var faqData: [FAQDetails]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        faqViewModel.faqDelegate = self
        
        setupTableView()
        setupUI()
        
        getFAQData()
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
        
        fromSideMenu = false
        
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    //MARK: -----Setup TableView
    fileprivate func setupTableView() {
        tblMain.delegate = self
        tblMain.dataSource = self
        
        tblMain.separatorStyle = .none
        tblMain.register(UINib.init(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQTableViewCell")
    }
    
    //MARK: -----SetupUI
    fileprivate func setupUI() {
        imgSemiCircleBack.tintColor = UIColor.colorSetup()
    }
    
    //MARK: -----Get FAQ Data
    fileprivate func getFAQData() {
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            faqViewModel.getFAQ()
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

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrData = faqData else { return 0 }
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        guard let arrData = faqData else { return 0 }
//
//        if let wins = arrData[indexPath.row].wins {
//            if wins > 0 {
//                return UITableView.automaticDimension
//            }
//        }
//        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        
        guard let arrData = faqData else { return cell }
        
        cell.updateFAQTableData(cellData: arrData[indexPath.row])
        
        return cell
    }
}

extension FAQViewController: FAQDelegate {
    func didReceiveFAQGetDataResponse(faqGetDataResponse: FAQResponse?) {
        self.view.stopActivityIndicator()

        if(faqGetDataResponse?.status != nil && faqGetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)

            if let faqDataResponse = faqGetDataResponse?.faq {
                faqData = faqDataResponse

                tblMain.reloadData()
            }

        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveFAQDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    
}
