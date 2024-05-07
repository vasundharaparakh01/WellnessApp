//
//  HomeVCExt.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/09/21.
//
import FirebaseDatabase
import Foundation
import UIKit
import SDWebImage

extension HomeViewController {
    func getChakraLevelData() {
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
            chakraDiplayViewModel.getChakraDisplayDetails(token: token)
        }
    }
    func getData() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            debugPrint("token--->",token)
            
            //Get previous date
            let previousDate = Date.yesterday
//            debugPrint("home previous date--->",previousDate)
//            let convertDateFormatter = DateFormatter()
//            convertDateFormatter.timeZone = TimeZone.current
//            convertDateFormatter.dateFormat = "yyyy-MM-dd"
//            let formatDate = convertDateFormatter.string(from: previousDate)
//            debugPrint("home formatDate--->",formatDate)
            
            let formatDate = Date().formatDate(date: previousDate)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            let status = UserDefaults.standard.bool(forKey: "isFromWatch")
            print(status)
            if status==true
            {
            print("second phase")
                homeViewModel.getHomeData(token: token, date: formatDate, device_cat: "?device_cat=watch")
            }
            else
            {
                homeViewModel.getHomeData(token: token, date: formatDate, device_cat: "?device_cat=mobile")
            }
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {    
    func didReceiveHomeResponse(homeResponse: HomeResponse?) {
        self.view.stopActivityIndicator()
        
        if(homeResponse?.status != nil && homeResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(homeResponse)
            homeData = homeResponse
            scrollTimer?.invalidate()
            scrollTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(sliderNext), userInfo: nil, repeats: true)
            setupUI()
            setupUIData()
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveHomeError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func setupUIData() {
        //lblQuotes.text = homeData?.quotes?.quote
        debugPrint(homeData?.isPaymented ?? "trueeee")
        if homeData?.isPaymented == false
        {
            btnDonateUs.isHidden = true
            
        }
        else
        {
            btnDonateUs.isHidden = false
        }
        lblQuoteAuthor.text = "-\(homeData?.quotes?.authorName ?? "")"
        
        if let steps = homeData?.distances.steps {
            if let miles = homeData?.distances.miles {
                let mile = String(format: "%.2f", miles)
                lblSteps.text = "\(steps)/\(mile)Miles"
            }
        }
        //Convert mililiter to liter
        if let mLiter = homeData?.waterIntaked?.waterIntake {
            let liter = Double(mLiter) / Double(1000)
            lblWaterIntake.text = "\(mLiter)ML/\(liter)L"
        }
        
        lblMood.text = homeData?.mood?.mood
        
        if let heartRate = homeData?.heartRate?.heartRate {
            lblHeartRate.text = "\(Int(heartRate)) Bpm"
        }
        
        if let sleep = homeData?.sleep?.sleep {
            let (hour, minute, second) = Date().convertSecondsToHourMinutesSecond(sleep)
            lblSleep.text = "\(hour)hr \(minute)min"
        }
        
        if let points = homeData?.point?.totalPoint {
            lblPoints.text = "\(points)"
        }
        
        //If message is blank then pickup category name value
        if let gratitudeMsg = homeData?.gratitude?.message {
            if gratitudeMsg.count > 0 && gratitudeMsg != "" {
                lblGratitude.text = gratitudeMsg
            } else {
                if let gratitudeMsg = homeData?.gratitude?.categoryName {
                    if gratitudeMsg.count > 0 && gratitudeMsg != "" {
                        lblGratitude.text = gratitudeMsg
                    } else {
                        lblGratitude.text = ConstantAlertMessage.GratitudeBlank
                    }
                }
            }
        } else {
            if let gratitudeMsg = homeData?.gratitude?.categoryName {
                if gratitudeMsg.count > 0 && gratitudeMsg != "" {
                    lblGratitude.text = gratitudeMsg
                } else {
                    lblGratitude.text = ConstantAlertMessage.GratitudeBlank
                }
            }
        }
        
        collBreathExercise.reloadData()
        collBlog.reloadData()
        collRec.reloadData()
        collLive.reloadData()
        collBanner.reloadData()
        upComingSession.reloadData()
        
        //Store badge count and post local notification to update if the user login from different device
        UserDefaults.standard.set(homeData?.unread_notification, forKey: ConstantUserDefaultTag.udNotificationBadge)
        NotificationCenter.default.post(name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
}

extension HomeViewController: ChakraDisplayViewModelDelegate {
    //MARK: - Delegate
    func didReceiveChakraDisplayResponse(chakraDisplayResponse: ChakraDisplayResponse?) {
        self.view.stopActivityIndicator()
        
        if(chakraDisplayResponse?.status != nil && chakraDisplayResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(chakraDisplayResponse)
            
            let chakraResponse = chakraDisplayResponse
            
            UserDefaults.standard.set(chakraResponse?.prev_level, forKey: ConstantUserDefaultTag.udPrevChakraLevel)
            UserDefaults.standard.set(chakraResponse?.prev_chakra, forKey: ConstantUserDefaultTag.udPrevChakraName)
            UserDefaults.standard.set(chakraResponse?.current_level, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)  //Store blocked chakra level
            UserDefaults.standard.set(chakraResponse?.level_chakra, forKey: ConstantUserDefaultTag.udBlockedChakraName)  //Store blocked chakra name
            UserDefaults.standard.set(chakraResponse?.current_chakraId, forKey: ConstantUserDefaultTag.udBlockedChakraID)   //Store blocked chakra id
            UserDefaults.standard.set(chakraResponse?.default_exercise?.exerciseId, forKey: ConstantUserDefaultTag.udDefaultExerciseID)
            UserDefaults.standard.set(chakraResponse?.default_exercise?.name, forKey: ConstantUserDefaultTag.udDefaultExerciseName)
            UserDefaults.standard.set(chakraResponse?.chakra_color, forKey: ConstantUserDefaultTag.udChakraColorchange)
            UserDefaults.standard.set(chakraResponse?.crownListen, forKey: ConstantUserDefaultTag.udChakraCrownListen)
            UserDefaults.standard.set(chakraResponse?.isLive, forKey: ConstantUserDefaultTag.udFromLive)
            
//            if(chakraResponse?.chakra_color==0)
//            {
//                UserDefaults.standard.set(chakraResponse?.current_level, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)  udChakraCrownListen
//
//            }
//            else{
//                UserDefaults.standard.set(chakraResponse?.chakra_color, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)
//            }
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveChakraDisplayError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension HomeViewController:LiveJoinViewModelDelegate
{
    func didReceiveLiveJoinResponse(liveResponse: LiveJoinResponse?) {
        
        self.view.stopActivityIndicator()
        
        if(liveResponse?.status != nil && liveResponse?.status?.lowercased() == ConstantStatusAPI.success) {
           
            debugPrint(liveResponse?.joinedsessionsdetails?.sessionId as Any)
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        
    }
    
    func didReceiveLiveJoinError(statusCode: String?) {
        
        
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Collection View Delegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == collBreathExercise {
//            return CGSize(width: 160.0, height: 120.0)
//        } else {
//            return CGSize(width: 194.0, height: 200.0)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let breathArray = homeData?.exercises else { return 0 }
        guard let blogArray = homeData?.blogs else { return 0 }
        guard let LiveArray = homeData?.live else {return 0}
        guard let RecordArray = homeData?.recording else {return 0}
        guard let BannerArray = homeData?.quotesArray else {return 0}
     
        
        
        if collectionView == collBreathExercise {
            return breathArray.count
        } else if collectionView == collBlog{
            return blogArray.count
        } else if collectionView == collRec{
            return RecordArray.count
        }else if collectionView == collBanner{
            return BannerArray.count
        } else
        {
            return LiveArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collBreathExercise {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellBreath", for: indexPath) as! CellBreath
            
            if let imgBreath = homeData?.exercises?[indexPath.row].location {
                cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgBreath = homeData?.exercises?[indexPath.row].exercise_img {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBreath
//                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            
            cell.lblTitle.text = homeData?.exercises?[indexPath.row].name
            
            return cell
            
        } else if collectionView == collBlog{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellBlog", for: indexPath) as! CellBlog
            
             
            if let imgBlog = homeData?.blogs?[indexPath.row].location {
                let finalImgPath = Common.WebserviceAPI.baseURL + imgBlog
                cell.imgView.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
             
            if let date = homeData?.blogs?[indexPath.row].add_date {
                cell.lblDate.text = convertDateFormat(inputDate: date)
                cell.lblDate.textColor = UIColor.colorSetup()
            }
            
            cell.lblTitle.text = homeData?.blogs?[indexPath.row].title
            cell.lblDesc.attributedText = homeData?.blogs?[indexPath.row].description?.htmlToAttributedString
            
            return cell
        }
        else if collectionView == collRec{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellRecord", for: indexPath) as! CellRecord
            
        //    if let imgBreath = homeData?.exercises?[indexPath.row].location {
              //  cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                
//                var yourArray = [String]()
//                yourArray.append("7.png")
//                yourArray.append("10.png")
//                yourArray.append("9.png")
//                yourArray.append("1.png")
//                yourArray.append("5.png")
//
//            var yourArray1 = [String]()
//            yourArray1.append("Meditation")
//            yourArray1.append("Yoga")
//            yourArray1.append("Healthy Eating")
//            yourArray1.append("Gratitude")
//            yourArray1.append("Meditation Music")
//                cell.imgView.image = UIImage(named: yourArray[indexPath.row])
//      //      }
////            if let imgBreath = homeData?.exercises?[indexPath.row].exercise_img {
////                let finalImgPath = Common.WebserviceAPI.baseURL + imgBreath
////                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////            }
//
            debugPrint(homeData?.recording?.count as Any)
            
            if let imgBlog = homeData?.recording?[indexPath.row].reclocation {
                cell.imgView.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
            
            
            cell.lblTitle.text = homeData?.recording?[indexPath.row].categoryName
            
            
            
            
            return cell
        }else if collectionView == collBanner{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellBanner", for: indexPath) as! CellBanner

        //    if let imgBreath = homeData?.exercises?[indexPath.row].location {
              //  cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)

//                var yourArray = [String]()
//                yourArray.append("7.png")
//                yourArray.append("10.png")
//                yourArray.append("9.png")
//                yourArray.append("1.png")
//                yourArray.append("5.png")
//
//            var yourArray1 = [String]()
//            yourArray1.append("Meditation")
//            yourArray1.append("Yoga")
//            yourArray1.append("Healthy Eating")
//            yourArray1.append("Gratitude")
//            yourArray1.append("Meditation Music")
//                cell.imgView.image = UIImage(named: yourArray[indexPath.row])
//      //      }
////            if let imgBreath = homeData?.exercises?[indexPath.row].exercise_img {
////                let finalImgPath = Common.WebserviceAPI.baseURL + imgBreath
////                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////            } bannerHome
//
           // debugPrint(homeData?.recording?.count as Any)

//            if let imgBlog = homeData?.recording?[indexPath.row].locationThumbnail {
//                cell.imgView.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)


//            }

//            let image:UIImage = UIImage(named:"bannerHome")!
//            cell.imgView.image = image
//            //cell.imgView.tintColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)
//            cell.imgView.tintColor = .red
            cell.lbquotes.text = homeData?.quotesArray?[indexPath.row].quote
            cell.lblAuthor.text = homeData?.quotesArray?[indexPath.row].authorName


         //   let image = UIImage(named:"bannerHome")?.withTintColor(.systemPink, renderingMode: .alwaysTemplate)
            cell.imgView.image = UIImage(named:"bannerHome")
            cell.imgView1.backgroundColor  = #colorLiteral(red: 0.3568627451, green: 0.1490196078, blue: 0.6509803922, alpha: 0.35)

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

            
           // cell.imgView.tintColor = #colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0, alpha: 0.3001468165)

            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLive", for: indexPath) as! CellLive
            
           // if let imgBreath = homeData?.exercises?[indexPath.row].location {
               // cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            
            
            debugPrint(homeData?.live?[indexPath.row].locationThumbnail)
                
//                var yourArray = [String]()
//                yourArray.append("2.png")
//                yourArray.append("6.png")
//                yourArray.append("3.png")
//                yourArray.append("8.png")
//                yourArray.append("4.png")
//                cell.imgView.image = UIImage(named: yourArray[indexPath.row])
//
//            var yourArray1 = [String]()
//            yourArray1.append("Meditation")
//            yourArray1.append("Yoga")
//            yourArray1.append("Healthy Eating")
//            yourArray1.append("Gratitude")
//            yourArray1.append("Meditation Music")
       //     }
//            if let imgBreath = homeData?.live?[indexPath.row].locationThumbnail {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBreath
//                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            
            if let imgBlog = homeData?.live?[indexPath.row].locationThumbnail {
                cell.imgView.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
            
            
            cell.lblTitle.text = homeData?.live?[indexPath.row].categoryName
            
            return cell
        }
        
   
           // return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collBreathExercise {
            // Default will be current blocked chakra coming from chakra level api
//            guard let blockedChakraID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraID) as? String else { return }
//            guard let blockedChakraName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraName) as? String else { return }
            //Temporary data - Root Chakra as default blocked chakra (Bhaiya)----------------
            let blockedChakraID = ConstantChakraID.rootChakra
            let blockedChakraName = ConstantChakraName.rootChakra
            
            UserDefaults.standard.set(false, forKey: "isFromMeditation")
            
            //Store relax breathing & music breathing id and do check on audio player view controller
            if homeData?.exercises?[indexPath.row].exerciseId == ConstantBreathExerciseID.relaxBreath {
                UserDefaults.standard.set(homeData?.exercises?[indexPath.row].exerciseId, forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
                
            }else if homeData?.exercises?[indexPath.row].exerciseId == ConstantBreathExerciseID.musicBreath {
                UserDefaults.standard.set(homeData?.exercises?[indexPath.row].exerciseId, forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID)//Store music breath id
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
                
            } else {
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
            }
            
            let meditationAudioRequestData = MeditationAudioRequest(meditationId: ConstantMeditationID.blockedChakras, chakraId: blockedChakraID, chakraName: blockedChakraName, exerciseId: homeData?.exercises?[indexPath.row].exerciseId, exerciseName: homeData?.exercises?[indexPath.row].name, time: nil, VCName: ConstantMeditationStaticName.blocked)
            
            let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
            exerciseTimeVC.hideSkipBtn = true
            exerciseTimeVC.meditationAudioRequestData =  meditationAudioRequestData
            navigationController?.pushViewController(exerciseTimeVC, animated: true)
            
        } else if collectionView == collBlog{
            let blogDetailVC = ConstantStoryboard.blogStoryboard.instantiateViewController(withIdentifier: "BlogDetailsViewController") as! BlogDetailsViewController
            blogDetailVC.homeBlog = homeData?.blogs?[indexPath.row]
            navigationController?.pushViewController(blogDetailVC, animated: true)
        }else if collectionView == collRec{
            
//            let refreshAlert = UIAlertController(title: "Luvo", message: "Recorded Sessions is coming soon", preferredStyle: UIAlertController.Style.alert)
//
//            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                  print("Handle Ok logic here")
//
//            }))
//
//    //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//    //              print("Handle Cancel Logic here")
//    //        }))
//
//            present(refreshAlert, animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "isFromHomeList")
            
            let LiveVC = ConstantStoryboard.RecordedSessionList.instantiateViewController(withIdentifier: "RecordedSessionListVC") as! RecordedSessionListVC
            LiveVC.sessionId = (homeData?.recording?[indexPath.row].ctgryId)!
            LiveVC.catagoryName = homeData?.recording?[indexPath.row].categoryName ?? "test"
          //  LiveVC.sessionNameLabel = homeData?.recording?[indexPath.row].sessionName ?? "test"
            navigationController?.pushViewController(LiveVC, animated: true)
            
            
        }else if collectionView == collBanner{


        }else {
            
//            let refreshAlert = UIAlertController(title: "Luvo", message: "Live Sessions is coming soon", preferredStyle: UIAlertController.Style.alert)
//
//            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                  print("Handle Ok logic here")
//
//            }))
//
//    //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//    //              print("Handle Cancel Logic here")
//    //        }))
//
//            present(refreshAlert, animated: true, completion: nil)
            
            let LiveVC = ConstantStoryboard.LiveSessionList.instantiateViewController(withIdentifier: "LiveSessionListViewController") as! LiveSessionListViewController
            LiveVC.sessionId = (homeData?.live?[indexPath.row].ctgryId)!
            LiveVC.CatagoryName = (homeData?.live?[indexPath.row].categoryName)!
            navigationController?.pushViewController(LiveVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        guard let UpcomingArray = homeData?.upcoming else {return 0}
        UpcomingArray2 = UpcomingArray
         debugPrint(UpcomingArray2)
       // return UpcomingArray.count// Here also
        if UpcomingArray2.count == 0{
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                emptyLabel.text = "No session available for today"
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.textColor = UIColor.colorSetup()
          //  emptyLabel.backgroundColor = UIColor.colorSetup()
               self.upComingSession.backgroundView = emptyLabel
                self.upComingSession.separatorStyle = .none
                return 0
            } else {
                return UpcomingArray.count
            }
        
       // return 5
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let image = UIImage(named: "Swift")?.withRenderingMode(.alwaysTemplate)
        //        let imageView = UIImageView(image: image)
        //        imageView.tintColor = .systemPink
        
        if UpcomingArray2.count == 0 {
           // tableView.setEmptyView(title: "You don't have any contact.", message: "Your contacts will be in here.", messageImage: #imageLiteral(resourceName: "swipe-right (1)"))
        }
        else {
        }
       
        if tableView == upComingSession,
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingList") as? UpcomingList {
           
            if let imgBreath = homeData?.upcoming?[indexPath.row].sessionThumbnailLocation {
                cell.imgViewCoach.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                cell.imgViewCoach.layer.cornerRadius = 7
                cell.Sessonname.text = homeData?.upcoming?[indexPath.row].sessionName
               // cell.lblCoach.text = homeData?.upcoming?[indexPath.row].coachname
                cell.lblCatagory.text = homeData?.upcoming?[indexPath.row].categoryName
            
              print(homeData?.upcoming?[indexPath.row].sessionStatus ?? "test")
            
            if homeData?.upcoming?[indexPath.row].sessionStatus ?? "test" == "active"
            {
                cell.imgViewLive.isHidden = false
                cell.imgViewLive.layer.cornerRadius = 5
                //AlreadyActive = true
            }
            else
            {
               // AlreadyActive = false
                cell.imgViewLive.isHidden = true
            }
            
//                if Started == true
//                {
//                    if string.contains(homeData?.upcoming?[indexPath.row]._id ?? "")
//                    {
//                        print(homeData?.upcoming?[indexPath.row]._id ?? "")
//                        cell.imgViewLive.isHidden = false
//                        cell.imgViewLive.layer.cornerRadius = 5
//                    }
//                    else{
//
//                        if AlreadyActive == true
//                        {
//                        }
//                        else
//                        {
//                        cell.imgViewLive.isHidden = true
//                        }
//                    }
//                }
                
//            let timeN: String = (homeData?.upcoming?[indexPath.row].sessionStarttime)!
//                debugPrint(timeN)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//            let date = dateFormatter.date(from: (homeData?.upcoming?[indexPath.row].sessionStarttime)!)// create   date from string
//
//                        // change to a readable time format and change to local time zone
//                        dateFormatter.dateFormat = "MMM d, yyyy"
//                        dateFormatter.timeZone = NSTimeZone.local
//            let timeStamp = dateFormatter.string(from: date!)
//                debugPrint(timeStamp)
//
             //   return dateFormatter.string(from: stringDate)
             //   cell.lblsessionDate.text = LiveData?.sessionList?[indexPath.row].sessionStarttime
           /// }
            
            
            
          //  cell.sessionName.text = arrsessionName[indexPath.row]
           // let startTime = arrSessionStartTime[indexPath.row]
            var convertedLocalStartTime : String = ""
            var convertedLocalEndTime : String = ""
            
            convertedLocalStartTime = utcToLocal(dateStr: homeData?.upcoming?[indexPath.row].sessionStarttime as Any as! String) ?? "text"
           
            convertedLocalEndTime = utcToLocal(dateStr: homeData?.upcoming?[indexPath.row].sessionEndtime as Any as! String) ?? "text"
            
            cell.lblTime.text = convertedLocalStartTime + "-" + convertedLocalEndTime
        //    debugPrint(arrsessionName[indexPath.row])
            if (indexPath.row % 2) != 0{
                
                cell.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.9882352941, blue: 0.9450980392, alpha: 1)
                }else{
                    
                    cell.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.8274509804, blue: 0.9607843137, alpha: 1)

                }
            }
            let tintableImage = UIImage(named: "Icon feather-clock")?.withRenderingMode(.alwaysTemplate)
           // cell.imgViewCalender.image = tintableImage
           // cell.imgViewCalender.tintColor = UIColor.colorSetup()
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true
            
            return cell
        }
        return UITableViewCell()
    }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "H:mm"
            
                return dateFormatter.string(from: date)
            }
            return nil
    }
     func childObserver()
    {
        ref.child("NewSessionStart").observe(.childChanged) { (snapshot) in
            
            if let value = snapshot.value as? String
            {
                debugPrint(value)
                self.string = value
                if self.string.contains("SessionStart") {
                    print("exists")
                    self.Started = true
                    self.getData()
                    self.imageViewGif.isHidden = false
                    self.btnHeaderLive.isHidden = false
                    self.upComingSession.reloadData()
                    
                }
            
                if self.string.contains("SessionEnd") {
                    print("Notexists")
                    self.Started = false
                    self.imageViewGif.isHidden = true
                    self.btnHeaderLive.isHidden = true
                    self.getData()
                    self.upComingSession.reloadData()
                    
                }
                
                

            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if homeData?.upcoming?[indexPath.row].sessionStatus ?? "test" == "active"
        {
            sessionIdUpcoming = (homeData?.upcoming?[indexPath.row]._id)!
            self.callData()
            let LiveVC = ConstantStoryboard.LiveSessionList.instantiateViewController(withIdentifier: "AgoraStreamViewController") as! AgoraStreamViewController
            
            LiveVC.sessionId = (homeData?.upcoming?[indexPath.row]._id)!
            LiveVC.AgoraAppId = (homeData?.upcoming?[indexPath.row].agoraAppId)!
            LiveVC.Agoaratoken = (homeData?.upcoming?[indexPath.row].agoraAccessToken)!
            LiveVC.channelName = (homeData?.upcoming?[indexPath.row].channelName)!
            LiveVC.coachImage = (homeData?.upcoming?[indexPath.row].coachProfileImage ?? "Rert" )
            LiveVC.sessionName = (homeData?.upcoming?[indexPath.row].sessionName)!
            navigationController?.pushViewController(LiveVC, animated: true)
        }
        else
        {
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Your Session is not started yet", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                
                
            }))

//            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                  print("Handle Cancel Logic here")
//            }))

            present(refreshAlert, animated: true, completion: nil)
        }
        
       
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        debugPrint(homeData?.upcoming?[indexPath.row].sessionName?.count)

        if tableView == upComingSession
        {
            if Int(homeData?.upcoming?[indexPath.row].sessionName?.count ?? 0) < 50
            {
            return 103 //Choose your custom row height
            }
            else if Int(homeData?.upcoming?[indexPath.row].sessionName?.count ?? 0) > 49 && Int(homeData?.upcoming?[indexPath.row].sessionName?.count ?? 0) < 101
            {
                return 115
            }
            else if Int(homeData?.upcoming?[indexPath.row].sessionName?.count ?? 0) > 101 && Int(homeData?.upcoming?[indexPath.row].sessionName?.count ?? 0) < 151
            {
                return 170
            }
            else
            {
                return 70
            }
        }
        return 0
     
    }
      
    func callData()
    {
        

            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            debugPrint("token--->",sessionIdUpcoming)

//            let request = SignupResquest(name: txtUsername.text, userEmail: txtEmail.text, mobileNo: txtPhoneNo.text, password: txtPassword.text, dateOfBirth: "", FCMToken: FCMToken)
//            signupViewModel.signupUser(signupRequest: request)
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))

            print(time + ", Type :UserJoin")

            self.ref.child(sessionIdUpcoming).setValue(["value": time + ", Type :UserJoin"])
           // self.ref.child(NewsessionId).setValue(["value": "1672237568, Type :UserJoin"])

            let request = LiveJoinRequest(sessionId: sessionIdUpcoming, action: "Joining")
            liveJoinViewModelUpcoming.postLiveJoinData(date: request, token: token)
        
    }
    
    func convertDateFormat(inputDate: String) -> String {
        let oldDate = Date().UTCFormatter(date: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.timeZone = TimeZone.current
        convertDateFormatter.dateFormat = "dd-MMM-yyyy"
        
        return convertDateFormatter.string(from: oldDate)
    }
}
extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        
    }
    
}
