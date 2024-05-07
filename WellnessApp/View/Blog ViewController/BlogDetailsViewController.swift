//
//  BlogDetailsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 19/10/21.
//

import UIKit
import WebKit

class BlogDetailsViewController: UIViewController, WKNavigationDelegate {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!

    @IBOutlet var imgViewBlog: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnComment: UIButton!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var lblLike: UILabel!
    @IBOutlet var lblTitle: UILabel!
//    @IBOutlet var txtViewDesc: UITextView!
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var constantHeightViewScroll: NSLayoutConstraint!
    @IBOutlet var constantHeightWebView: NSLayoutConstraint!
    
    var blogDetails: BlogList?
    var homeBlog: Blogs?
    
    var likeViewModel = LikesViewModel()
    
    var blogId: String?
    var boolLike = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        likeViewModel.delegate = self
        webView.navigationDelegate = self

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
    
    //MARK: Button Func-------------
    @IBAction func btnComment(_ sender: Any) {
        let commentVC = ConstantStoryboard.blogStoryboard.instantiateViewController(withIdentifier: "BlogCommentsViewController") as! BlogCommentsViewController
        if let blogid = blogId {
            commentVC.blogID = blogid
        }
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @IBAction func btnLike(_ sender: Any) {
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
            if boolLike {
                if let blogid = blogId {
                    boolLike = false
//                    btnLike.setButtonTintColor(color: UIColor.gray)
                    btnLike.tintColor = UIColor.gray
                    
                    likeViewModel.deleteFromLike(likeRequest: LikesRequest(blogId: blogid), token: token)
                }
            } else {
                if let blogid = blogId {
                    boolLike = true
//                    btnLike.setButtonTintColor(color: UIColor.colorSetup())
                    btnLike.tintColor = UIColor.colorSetup()
                    
                    likeViewModel.addToLike(likeRequest: LikesRequest(blogId: blogid), token: token)
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

extension BlogDetailsViewController {
    func setupGUI() {
        lblDate.textColor = UIColor.colorSetup()
//        btnComment.setButtonTintColor(color: UIColor.colorSetup())
        btnComment.tintColor = UIColor.colorSetup()
//        btnLike.setButtonTintColor(color: UIColor.gray)
        btnLike.tintColor = UIColor.gray
    }
    
    func setupData() {        
        if let homeBlogData = homeBlog {
            blogId = homeBlogData.blogId
            
            if let imgBlog = homeBlogData.location {
                imgViewBlog.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgBlog = homeBlogData.blog_img {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBlog
//                imgViewBlog.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            
            if let dateBlog = homeBlogData.add_date {
                lblDate.text = convertDateFormat(inputDate: dateBlog)
            }
            
            if let like = homeBlogData.likes {
                if like == 1 {
//                    btnLike.setButtonTintColor(color: UIColor.colorSetup())
                    btnLike.tintColor = UIColor.colorSetup()
                    boolLike = true
                } else {
//                    btnLike.setButtonTintColor(color: UIColor.gray)
                    btnLike.tintColor = UIColor.gray
                    boolLike = false
                }
            }
            
            if let totalLike = homeBlogData.tot_likes {
                lblLike.text = "\(totalLike)" //"\(arrayBlogList[indexPath.row].likes)"
            }            
            
            if let titleBlog = homeBlogData.title {
                lblTitle.text = titleBlog
            }
            
            if let descBlog = homeBlogData.description {
//                txtViewDesc.attributedText = descBlog.htmlToAttributedString
                
                //Increase the font size by adding <header> tag and appending with the html string
                var headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
                headerString.append(descBlog)
                webView.loadHTMLString(headerString, baseURL: nil)
            }
            
        } else {
            blogId = blogDetails?.blogId
            
            if let imgBlog = blogDetails?.location {
                imgViewBlog.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgBlog = blogDetails?.blog_img {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBlog
//                imgViewBlog.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            
            if let dateBlog = blogDetails?.add_date {
                lblDate.text = convertDateFormat(inputDate: dateBlog)
            }
            
            if let like = blogDetails?.likes {
                if like == 1 {
//                    btnLike.setButtonTintColor(color: UIColor.colorSetup())
                    btnLike.tintColor = UIColor.colorSetup()
                    boolLike = true
                } else {
//                    btnLike.setButtonTintColor(color: UIColor.gray)
                    btnLike.tintColor = UIColor.gray
                    boolLike = false
                }
            }
            
            if let totalLike = blogDetails?.tot_likes {
                lblLike.text = "\(totalLike)" //"\(arrayBlogList[indexPath.row].likes)"
            }
            
            if let titleBlog = blogDetails?.title {
                lblTitle.text = titleBlog
            }
            
            if let descBlog = blogDetails?.description {
//                txtViewDesc.attributedText = descBlog.htmlToAttributedString
                
                //Increase the font size by adding <header> tag and appending with the html string
                var headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
                headerString.append(descBlog)
                webView.loadHTMLString(headerString, baseURL: nil)
            }
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
    
    func convertDateFormat(inputDate: String) -> String {
        let oldDate = Date().UTCFormatter(date: inputDate)
        
        //Not using Date().formatDate becoz of dateFormat = "dd-MMM-yyyy"
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.timeZone = TimeZone.current
        convertDateFormatter.dateFormat = "dd-MMM-yyyy"
        
        return convertDateFormatter.string(from: oldDate)
    }
}

extension BlogDetailsViewController: LikesViewModelDelegate {
    func didReceiveLikesDataResponse(likesDataResponse: LikesResponse?) {
        self.view.stopActivityIndicator()
        
        if(likesDataResponse?.status != nil && likesDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(likesDataResponse)
            
            guard let message = likesDataResponse?.message else { return }
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: likesDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveLikesDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    
}
