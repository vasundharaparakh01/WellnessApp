//
//  SearchMeditationViewController.swift
//  Luvo
//
//  Created by Sahidul on 13/12/21.
//

import UIKit
class SearchCellBanner: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgView1: UIImageView!
    @IBOutlet var lbquotes: UILabel!
    @IBOutlet var lblAuthor: UILabel!
}
class SearchMeditationViewController: UIViewController {
    
    
    
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewTopBanner: UIView!
    @IBOutlet var lblQuotes: UILabel!
    @IBOutlet var lblQuoteAuthor: UILabel!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet weak var viewSearchBG: UIView!
    @IBOutlet var tblSearchAudio: UITableView!
    @IBOutlet var collBanner: UICollectionView!
    
    var meditationAudioData: MeditationAudioResponse?
    var arrayAudioList = [MeditationMusics]()
    var arrayVideoList = [SoothingVideosList]()
    var searchViewModel = SearchAudioViewModel()
    var favViewModel = FavouritesViewModel()
    var messageQuetes: String = ""
    var authorName: String = "_"
    var arrQuotes = [QuotesData]()
    var scrollTimer: Timer?
    var currenCallIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCustomNavBar()
        setUpTableView()
        setupUI()
        
        debugPrint(arrQuotes.count)
        debugPrint(arrQuotes.startIndex)
      //  scrollTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(sliderNext), userInfo: nil, repeats: true)

        
    }
    
    @objc func sliderNext()
    {
        //homeData?.quotesArray?.count
        debugPrint(arrQuotes.count )
        
        if currenCallIndex < (arrQuotes.count ) - 1
        {
            currenCallIndex = currenCallIndex + 1
        }
        else{
            
            currenCallIndex = 0
        }
        
        if currenCallIndex == 0
        {
        collBanner.scrollToItem(at: IndexPath(item: currenCallIndex, section: 0), at: .left, animated: false)
        }
        
        else
        {
        collBanner.scrollToItem(at: IndexPath(item: currenCallIndex, section: 0), at: .right, animated: true)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    fileprivate func setUpTableView() {
        tblSearchAudio.delegate = self
        tblSearchAudio.dataSource = self
        tblSearchAudio.separatorStyle = .none
    }
    
    fileprivate func setupUI() {
        lblQuotes.text = messageQuetes
        lblQuoteAuthor.text = authorName
        self.txtSearch.becomeFirstResponder()
        searchViewModel.delegate = self
        favViewModel.delegate = self
        
        //Color setup according to chakra level
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        print("coloris .<>>>>>..--->>>",chakraColour)
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
               
               print(crownList)

        
        if chakraColour==0 {
            switch chakraLevel {
            case 1:
//                viewTopBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                break
            case 2:
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)
                break
            case 3:
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)
                break
            case 4:
//                viewTopBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
                break
            case 5:
//                viewTopBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                break
            case 6:
//                viewTopBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                break
            case 7:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
                break
            default:
//                viewTopBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                break
            }
        } else if crownList == 1 {
            switch chakraColour {
            case 1:
//                viewTopBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                break
            case 2:
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)
                break
            case 3:
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)
                break
            case 4:
//                viewTopBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
                break
            case 5:
//                viewTopBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                break
            case 6:
//                viewTopBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                break
            case 7:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
                break
            default:
//                viewTopBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                break
            }
        }
        else
        {
            switch chakraLevel {
            case 1:
//                viewTopBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                break
            case 2:
//                viewTopBanner.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#f46d02","#f8a562"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.75)
                break
            case 3:
//                viewTopBanner.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#fdb200","#fecf61"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7019607843, blue: 0.01568627451, alpha: 0.7534304991)
                break
            case 4:
//                viewTopBanner.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#00a62c","#61c87c"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.75)
                
                break
            case 5:
//                viewTopBanner.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#00adef","#96ddf8"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)
                break
            case 6:
//                viewTopBanner.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#5b26a6","#a284cc"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                break
            case 7:
                
//                viewTopBanner.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#8400A5","#A81F93"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.75)
                
                break
            default:
//                viewTopBanner.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
//                viewSearchBG.setGradientBackground(hexColor: ["#ed010b","#f24249"], rightToLeft: false, leftToRight: true, topToBottom: false, bottomToTop: false)
                
                viewTopBanner.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                viewSearchBG.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.75)
                
                break
            }
        }

            
    }
    
    //MARK: ----------- Button Function ------------
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnSearchAction(_ sender: Any) {
        ///Check if search textfield have 1 letter or not. If 1 then no click else click
        
        guard let searchString = self.txtSearch.text else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Minimum 2 characters is required for search result")
            return
        }
        
        if searchString.count < 2 || searchString == "" {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Minimum 2 characters is required for search result")
        } else {
            //api call here
            let connectionStatus = ConnectionManager.shared.hasConnectivity()
            if (connectionStatus == false) {
                DispatchQueue.main.async {
                    self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                    return
                }
            } else {
                guard !(txtSearch.text!.trimmingCharacters(in: .whitespaces).isEmpty) else { return }
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }
                self.view.endEditing(true)
                
                // ExerciseId will always be blank here-------------------***
                //let request = MeditationAPIRequest(meditationId: meditationAudioRequest?.meditationId, chakraId: meditationAudioRequest?.chakraId, exerciseId: "")
                
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                searchViewModel.getSearchAudioList(token: token, searchText: txtSearch.text!)
            }
        }
    }
    
}

//MARK: ------- Table view delegate and datasource ------
extension SearchMeditationViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayAudioList.count
        } else {
            return arrayVideoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeditationAudioListCell", for: indexPath) as! MeditationAudioListCell
            cell.selectionStyle = .none
            
            if let imgAlbum = arrayAudioList[indexPath.row].location {
                cell.imgBackground.sd_setImage(with: URL(string: imgAlbum), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgAlbum = arrayAudioList[indexPath.row].musicImg {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgAlbum
//                cell.imgBackground.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            cell.lblTitle.text = arrayAudioList[indexPath.row].musicName
            cell.lblDesc.text = arrayAudioList[indexPath.row].description
            cell.lblDuration.text = arrayAudioList[indexPath.row].duration
            
            cell.viewCompleted.isHidden = true
            
            if let fav = arrayAudioList[indexPath.row].favorites {
                if fav.count > 0 {
                    cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                } else {
                    cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                }
            }
            
            cell.btnFavClick = {
                if cell.btnFav.currentImage == UIImage(named:"heartOn") {
                    cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                    self.favouriteData(musicId: self.arrayAudioList[indexPath.row].musicId! ,musicType: self.arrayAudioList[indexPath.row].musicType!, addToFav: false)
                } else {
                    cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                    self.favouriteData(musicId: self.arrayAudioList[indexPath.row].musicId! ,musicType: self.arrayAudioList[indexPath.row].musicType!, addToFav: true)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SoothingListCell", for: indexPath) as! SoothingListCell
            
            if let imgVideo = arrayVideoList[indexPath.row].location {
                cell.imgBackground.sd_setImage(with: URL(string: imgVideo), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgVideo = arrayVideoList[indexPath.row].musicImg {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgVideo
//                cell.imgBackground.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            cell.lblTitle.text = arrayVideoList[indexPath.row].musicName
            cell.lblDesc.attributedText = arrayVideoList[indexPath.row].description?.htmlToAttributedString
            cell.lblDuration.text = arrayVideoList[indexPath.row].duration
            
            if let fav = arrayVideoList[indexPath.row].favorites {
                if fav.count > 0 {
                    cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                } else {
                    cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                }
            }
            
            cell.btnFavClick = {
                if cell.btnFav.currentImage == UIImage(named:"heartOn") {
                    cell.btnFav.setImage(UIImage(named: "heartOff"), for: .normal)
                    self.favouriteData(musicId: self.arrayVideoList[indexPath.row].musicId! ,musicType: self.arrayVideoList[indexPath.row].musicType!, addToFav: false)
                } else {
                    cell.btnFav.setImage(UIImage(named: "heartOn"), for: .normal)
                    self.favouriteData(musicId: self.arrayVideoList[indexPath.row].musicId! ,musicType: self.arrayVideoList[indexPath.row].musicType!, addToFav: true)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PushToVc(indexPath: indexPath)
    }
    
    func PushToVc(indexPath: IndexPath) {
        if indexPath.section == 0 {
            let playerVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "FullAudioPlayerViewController") as! FullAudioPlayerViewController
            playerVC.arrayAudioListData = arrayAudioList
            indexpath = indexPath
            if let meditationId = arrayAudioList[indexPath.row].meditationId {
                if meditationId == ConstantMeditationID.blockedChakras {
                    playerVC.vcName = ConstantMeditationStaticName.blocked
                } else if meditationId == ConstantMeditationID.manifestation {
                    playerVC.vcName = ConstantMeditationStaticName.manifestation
                } else if meditationId == ConstantMeditationID.highPerformance {
                    playerVC.vcName = ConstantMeditationStaticName.performance
                }
            }
            navigationController?.pushViewController(playerVC, animated: true)
        } else {
            let soothingVideoPlayerVC = ConstantStoryboard.soothingMusicVideo.instantiateViewController(withIdentifier: "SoothingVideoPlayerViewController") as! SoothingVideoPlayerViewController
            soothingVideoPlayerVC.soothingVideoData = arrayVideoList[indexPath.row]
            navigationController?.pushViewController(soothingVideoPlayerVC, animated: false)
        }
    }
    
    fileprivate func postAudioUnlock(musicId: String, points: String) {
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
            let request = AudioUnlockRequest(musicId: musicId, points: points)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            //meditationMusicVewModel.postAudioUnlock(audioUnlockRequest: request, token: token)
        }
    }
    
    func favouriteData(musicId: String, musicType: String, addToFav: Bool) {
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
            //check if add to fav or delete from fav
            if addToFav == true {
                favViewModel.addToFavourite(favRequest: FavouritesRequest(musicId: musicId, musicType: musicType), token: token)
            } else {
                favViewModel.deleteFromFavourite(favRequest: FavouritesRequest(musicId: musicId, musicType: musicType), token: token)
            }
        }
    }
}

extension SearchMeditationViewController: SearchAudioViewModelDelegate {
    func didReceiveMeditationAudioDataResponse(meditationAudioDataResponse: MeditationAudioResponse?) {
        self.view.stopActivityIndicator()
        if(meditationAudioDataResponse?.status != nil && meditationAudioDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            meditationAudioData = meditationAudioDataResponse
            if let arrMusic = meditationAudioData?.musics {
                let videoMusic = meditationAudioData?.videos
                arrayAudioList.removeAll()
                arrayVideoList.removeAll()
                if arrMusic.count == 0 && videoMusic?.count == 0{
                    if let message = meditationAudioDataResponse?.message {
                        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
                    }
                } else if arrMusic.count != 0{
                    arrayAudioList = arrMusic
                } else if videoMusic?.count != 0 {
                    arrayVideoList = videoMusic ?? []
                }
                tblSearchAudio.reloadData()
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveMeditationAudioDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}


extension SearchMeditationViewController: FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?) {
        self.view.stopActivityIndicator()
        if(favouriteDataResponse?.status != nil && favouriteDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            guard let message = favouriteDataResponse?.message else { return }
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: message)
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveFavouriteDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension SearchMeditationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // return arrQuotes.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCellBanner", for: indexPath) as! SearchCellBanner
        cell.lbquotes.text = arrQuotes[indexPath.row].quote
        cell.lblAuthor.text =  arrQuotes[indexPath.row].authorName


                     //   let image = UIImage(named:"bannerHome")?.withTintColor(.systemPink, renderingMode: .alwaysTemplate)
                        cell.imgView.image = UIImage(named:"bannerHome")
                       
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 1
        print("chakra level ...--->>>",chakraLevel)
        print("coloris ...--->>>",chakraColour)
        let crownList = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraCrownListen) as? Int ?? 1
                
                print(crownList)


//        for view in viewTopBanner.subviews{
//            view.removeFromSuperview()
//        }

         // this gets things done
       // view.subviews.map({ $0.removeFromSuperview() })

        if chakraColour==0 {
            switch chakraLevel {
            case 1:

                cell.imgView1.backgroundColor  = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                break

            case 3:

                cell.imgView1.backgroundColor =  #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)

                break
            case 4:

                cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)

                break
            case 5:

                cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)

                break
            case 2:

                cell.imgView1.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)

                break
            case 6:

                cell.imgView1.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

                break
            case 7:

                cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

                break

            default:

                break
            }
        }
        else if crownList == 1 {
            switch chakraColour {
                        
                    case 1:

                        cell.imgView1.backgroundColor  = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                        break

                    case 3:

                        cell.imgView1.backgroundColor =  #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)

                        break
                    case 4:

                        cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)

                        break
                    case 5:

                        cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)

                        break
                    case 2:

                        cell.imgView1.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)

                        break
                    case 6:

                        cell.imgView1.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

                        break
                    case 7:

                        cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

                        
            default:
                break
            }
        }
            else {
                switch chakraLevel {
                case 1:

                    cell.imgView1.backgroundColor  = #colorLiteral(red: 0.9294117647, green: 0, blue: 0.03921568627, alpha: 0.35)
                    break

                case 3:

                    cell.imgView1.backgroundColor =  #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)

                    break
                case 4:

                    cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3541517447)

                    break
                case 5:

                    cell.imgView1.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.937254902, alpha: 0.75)

                    break
                case 2:

                    cell.imgView1.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4235294118, blue: 0, alpha: 0.35)

                    break
                case 6:

                    cell.imgView1.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

                    break
                case 7:

                    cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

                    break

                default:

                    break
                
                }
                
            }
                        
                        return cell

    }
    
    
    
    
}
