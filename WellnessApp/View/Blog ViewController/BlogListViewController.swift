//
//  BlogListViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 19/10/21.
//

import UIKit

class BlogCell: UICollectionViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLblDate: UILabel!
    @IBOutlet var cellLblTitle: UILabel!
    @IBOutlet var cellLblDesc: UILabel!
    @IBOutlet var imgLike: UIImageView!
    @IBOutlet var lblLike: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellLblDate.textColor = UIColor.colorSetup()
        imgLike.tintColor = .gray
    }
}

class BlogListViewController: UIViewController, UITextFieldDelegate {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet var colViewMain: UICollectionView!
    
    var blogViewModel = BlogViewModel()
    var arrayBlogList = [BlogList]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()
        
        blogViewModel.delegate = self
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
        getBlogListData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fromSideMenu = false
        
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
    @IBAction func btnSearchAction(_ sender: Any) {
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            self.view.endEditing(true)
            guard !(searchTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty) else { return }
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            blogViewModel.getSearchBlogList(token: token, searchText: searchTextField.text!)
        }
    }
    //-----------------------------
    
    func getBlogListData() {
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
            blogViewModel.getBlogList(token: token)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchTextField.text?.count == 0 {
            getBlogListData()
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

extension BlogListViewController: BlogViewModelDelegate {
    func didReceiveBlogListDataResponse(blogListDataResponse: BlogListResponse?) {
        self.view.stopActivityIndicator()
        
        if(blogListDataResponse?.status != nil && blogListDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(blogListDataResponse)
            
            if let arrBlog = blogListDataResponse?.blogs {
                if arrBlog.count > 0 {
                    arrayBlogList = arrBlog
                    colViewMain.reloadData()
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveBlogListDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

//MARK: ----Collection View Delegate
extension BlogListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayBlogList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCell", for: indexPath) as! BlogCell
        
        if let imgBlog = arrayBlogList[indexPath.row].location {
            cell.cellImage.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
//        if let imgBlog = arrayBlogList[indexPath.row].blog_img {
//            let finalImgPath = Common.WebserviceAPI.baseURL + imgBlog
//            cell.cellImage.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//        }

        if let date = arrayBlogList[indexPath.row].add_date {
            cell.cellLblDate.text = convertDateFormat(inputDate: date)
        }
        
        if let like = arrayBlogList[indexPath.row].likes {
            if like == 1 {
                cell.imgLike.tintColor = UIColor.colorSetup()
            } else {
                cell.imgLike.tintColor = .gray
            }
        }
        
        if let totalLike = arrayBlogList[indexPath.row].tot_likes {
            cell.lblLike.text = "\(totalLike)" //"\(arrayBlogList[indexPath.row].likes)"
        }

        cell.cellLblTitle.text = arrayBlogList[indexPath.row].title
        cell.cellLblDesc.attributedText = arrayBlogList[indexPath.row].description?.htmlToAttributedString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DID SELECT COLLECTION VIEW---->",indexPath.row)
        
        let blogDetailVC = ConstantStoryboard.blogStoryboard.instantiateViewController(withIdentifier: "BlogDetailsViewController") as! BlogDetailsViewController
        blogDetailVC.blogDetails = arrayBlogList[indexPath.row]
        navigationController?.pushViewController(blogDetailVC, animated: true)
    }
    
    func convertDateFormat(inputDate: String) -> String {
        let oldDate = Date().UTCFormatter(date: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.timeZone = TimeZone.current
        convertDateFormatter.dateFormat = "dd-MMM-yyyy"
        
        return convertDateFormatter.string(from: oldDate)
    }
}
