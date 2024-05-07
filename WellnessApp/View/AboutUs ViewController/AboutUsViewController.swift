//
//  AboutUsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController, WKNavigationDelegate {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var imgViewBlog: UIImageView!
    @IBOutlet var lblTitle: UILabel!
//    @IBOutlet var txtViewDesc: UITextView!
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var constantHeightViewScroll: NSLayoutConstraint!
    @IBOutlet var constantHeightWebView: NSLayoutConstraint!
    
    var aboutViewModel = AboutUsViewModel()
    var aboutData: AboutUsCMS?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        aboutViewModel.aboutUsDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        getAboutUsData()
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    //MARK: -----Get About Us Data-----
    fileprivate func getAboutUsData() {
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            aboutViewModel.getAboutUs()
        }
    }
    
    //MARK: ----Set About Us Data----
    fileprivate func setupData() {
        if let imgBlog = aboutData?.location {
            imgViewBlog.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
        
//        if let imgBlog = aboutData?.cms_img {
//            let finalImgPath = Common.WebserviceAPI.baseURL + imgBlog
//            imgViewBlog.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//        }
        
        if let title = aboutData?.title {
            lblTitle.text = title
        }
        
        if let desc = aboutData?.description {
//            txtViewDesc.attributedText = desc.htmlToAttributedString
            
            //Increase the font size by adding <header> tag and appending with the html string
            var headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
            headerString.append(desc)
            webView.loadHTMLString(headerString, baseURL: nil)
        }
    }
    ////WebKit delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.isLoading == false {
            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [weak self] (result, error) in
                if let height = result as? CGFloat {
                    self?.constantHeightWebView.constant += height
                    self?.constantHeightViewScroll.constant += height
                }
            })
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

extension AboutUsViewController: AboutUsDelegate {
    func didReceiveAboutUsGetDataResponse(aboutUsGetDataResponse: AboutUsResponse?) {
        self.view.stopActivityIndicator()
        
        if(aboutUsGetDataResponse?.status != nil && aboutUsGetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)
            
            if let aboutDataResponse = aboutUsGetDataResponse?.cms {
                aboutData = aboutDataResponse
                
                setupData()
            }
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveAboutUsDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
