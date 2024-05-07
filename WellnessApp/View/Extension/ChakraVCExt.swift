//
//  ChakraVCExt.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/09/21.
//

import Foundation
import UIKit

extension ChakraViewController: ChakraDisplayViewModelDelegate {
    
    //MARK: - Delegate
    func didReceiveChakraDisplayResponse(chakraDisplayResponse: ChakraDisplayResponse?) {
        self.view.stopActivityIndicator()
        
        if(chakraDisplayResponse?.status != nil && chakraDisplayResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(chakraDisplayResponse)
            btnBack.isUserInteractionEnabled = true //If data coming then go to next page else not
            
            chakraResponse = chakraDisplayResponse
            
            let tempRememberMe = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udTempRememberMe)
            UserDefaults.standard.set(tempRememberMe, forKey: ConstantUserDefaultTag.udRememberMe) //Bool
            UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udQuestions) //Bool to true all question complete
            UserDefaults.standard.set(chakraResponse?.prev_level, forKey: ConstantUserDefaultTag.udPrevChakraLevel)
            UserDefaults.standard.set(chakraResponse?.prev_chakra, forKey: ConstantUserDefaultTag.udPrevChakraName)
            UserDefaults.standard.set(chakraResponse?.current_level, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)  //Store blocked chakra level
            UserDefaults.standard.set(chakraResponse?.level_chakra, forKey: ConstantUserDefaultTag.udBlockedChakraName)  //Store blocked chakra name
            UserDefaults.standard.set(chakraResponse?.current_chakraId, forKey: ConstantUserDefaultTag.udBlockedChakraID) //Store blocked blocked chakra id
            UserDefaults.standard.set(chakraResponse?.default_exercise?.exerciseId, forKey: ConstantUserDefaultTag.udDefaultExerciseID)
            UserDefaults.standard.set(chakraResponse?.default_exercise?.name, forKey: ConstantUserDefaultTag.udDefaultExerciseName)
            
            setupUserAlert()
                        
        } else {
            btnBack.isUserInteractionEnabled = false    //If data not coming then don't go to next page
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveChakraDisplayError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    //MARK: - Setup User Alert
    func setupUserAlert() {
        let popupVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ChakraPopupViewController") as! ChakraPopupViewController
        popupVC.delegate = self
        
        if chakraResponse != nil {
//            let chakraLevel = chakraResponse?.current_level
            
//            if chakraLevel == 0 {
                popupVC.chakraName = chakraResponse?.level_chakra
                popupVC.chakraLevel = chakraResponse?.current_level
                popupVC.prevChakraLevel = chakraResponse?.prev_level
//            } else {
//                popupVC.chakraName = chakraResponse?.prev_chakra
//                popupVC.chakraLevel = chakraResponse?.prev_level
//            }
        }
        
        popupVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(popupVC, animated: true)
    }
    
    
    //MARK: - Setup Chakra Accordingly
    func setupChakraAccordingly() {
        if chakraResponse != nil {
            let chakraLevel = chakraResponse?.current_level
            let prevChakraLevel = chakraResponse?.prev_level
            
            switch chakraLevel {
            case 0:
                imgViewChakra.isUserInteractionEnabled = true
                self.imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra0)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 1:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra1)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 2:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra2)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 3:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra3)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 4:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra4)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 5:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra5)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 6:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra6)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            case 7:
                //If chakra level 7 is open then both blocked chakra level & prev chakra level will be 7
                if chakraLevel == 7 && prevChakraLevel == 7 {
                    imgViewChakra.isUserInteractionEnabled = true
                    imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakraAllOpen)
                    UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                        self.imgViewChakra.alpha = 1.0
                    })
                } else {
                    imgViewChakra.isUserInteractionEnabled = true
                    imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra7)
                    UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                        self.imgViewChakra.alpha = 1.0
                    })
                }
                break
                
            default:
                imgViewChakra.isUserInteractionEnabled = true
                imgViewChakra.image = UIImage.init(named: ConstantChakraImageName.chakra0)
                UIImageView.animate(withDuration: ConstantAnimationDuration.duration, animations: {
                    self.imgViewChakra.alpha = 1.0
                })
                break
            }
        }
    }
    
    //MARK: - Get Chakra Status
    func getChakraStatus() {
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
}
