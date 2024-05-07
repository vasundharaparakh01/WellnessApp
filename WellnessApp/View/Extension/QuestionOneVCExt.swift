//
//  QuestionOneVCExt.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/09/21.
//

import Foundation
import UIKit

extension QuestionOneViewController: ChakraQuestionViewModelDelegate {
    func didReceiveRetakeAnswerResponse(retakeAnswerResponse: RetakeResult?) {
        
        if(retakeAnswerResponse?.status != nil && retakeAnswerResponse?.status?.lowercased() == ConstantStatusAPI.success) {
        }
        else
        {
            
        }
    }
    
    func didReceiveRetakeAnswerError(statusCode: String?) {
        
    }
    
    //MARK: - Delegate
    func didReceiveChakraAnswerResponse(chakraAnswerResponse: ChakraAnswerResponse?) {
        self.view.stopActivityIndicator()
        
        if(chakraAnswerResponse?.status != nil && chakraAnswerResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(chakraAnswerResponse)
            
           
            let status = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromsideMenu)
            print(status)
            if status == false
            {
            
            self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                         message: chakraAnswerResponse?.message ?? ConstantStatusAPI.success,
                                         alertStyle: .alert,
                                         actionTitles: [ConstantAlertTitle.OkAlertTitle],
                                         actionStyles: [.default], actions: [
                                            {_ in
                                                let chakraVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ChakraViewController") as! ChakraViewController
                                                self.navigationController?.pushViewController(chakraVC, animated: true)
                                            }
                                         ])
            }
            else
            {
              
                let str = chakraAnswerResponse?.chakra ?? ConstantStatusAPI.success
               
                self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                             message: "Your " + str + " is blocked. Meditating regularly on the " + str + " audios will enable you to open this chakra.",
                                             alertStyle: .alert,
                                             actionTitles: [ConstantAlertTitle.OkAlertTitle],
                                             actionStyles: [.default], actions: [
                                                {_ in
                                                    
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                             ])
            }
                        
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveChakraAnswerError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func didReceiveChakraQuestionResponse(chakraResponse: ChakraQuestionResponse?) {
        self.view.stopActivityIndicator()
        
        if(chakraResponse?.status != nil && chakraResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(chakraResponse)
            
            arrayChakraQuestion = chakraResponse?.result
            
            setupDataHolder()
            
            //Setup a default question from response at index 0
            setQuestionData(questionAtIndex: 0)
            counter = 1
                        
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveChakraQuestionError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    //MARK: - Setup Dataholder
    //Create object according to number of array data count and store in arrayStoreAnswer
    func setupDataHolder() {
        if arrayStoreAnswer == nil {
            arrayStoreAnswer = [AnswerData]()//Storing selected answer
            print(arrayStoreAnswer)
            
            selectedCellIndex = [[String: Int]]()   //Storing selected question & answer index to highlight answer view border color
            
            for _ in 0...arrayChakraQuestion!.count - 1 {
                answerData = AnswerData(chakraId: nil, questionId: nil, answerId: nil)
                arrayStoreAnswer?.append(answerData!)
                
                //Also create predifined nil selectedCellIndex array of dictionary
                let dict = ["questionIndex": nil, "answerIndex":nil] as [String : Any?]
                selectedCellIndex?.append(dict as [String : Any])
            }
        }
    }
    
    //MARK: - Get Question Data
    func getQuestionData() {
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
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            chakraQuestionViewModel.getChakraQuestion(token: token)
        }
    }
    
    //MARK: - Set Question Data
    func setQuestionData(questionAtIndex: Int) {
        
        if UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFromsideMenu) != nil
                {
            
       //     Logic for previous cell selected, was implemented but changed due to client requieements. DEveloper - Nilanjan
            
            
            
   /*         print(questionAtIndex)
        
        guard let arrayQuestion =  arrayChakraQuestion?[questionAtIndex].question else { return }
        guard let arrayAnswer =  arrayChakraQuestion?[questionAtIndex].options else { return }
        guard let arrayRetake =  arrayChakraQuestion?[questionAtIndex].userAnsId else { return }
            
//            guard let arrayQuestion =  arrayRetakeQuestion?[questionAtIndex].question else { return }
//        //    guard let arrayAnswer =  arrayRetakeAnswer?[questionAtIndex].options else { return }
//            guard let arrayRetake =  arrayRetakeAnswer?[questionAtIndex].userAnsId else { return }
       
             print(arrayQuestion)
            print(arrayAnswer)
             print(arrayRetake)
            

           
         
            
            let bob_pos = arrayAnswer.firstIndex(where: {$0.answerId == arrayRetake})
            print("Bob is at position \(bob_pos!).")
                    
        
       
        
      lblQuestion.text = arrayQuestion
        arrayChakraAnswer = arrayAnswer
        tblAnswer.reloadData()
        setBannerImage(index: questionAtIndex)
        questionIndex = questionAtIndex
            
           
           
                let indexPath = IndexPath(row: bob_pos ?? 10, section: 0)
                tblAnswer.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                tblAnswer.delegate?.tableView!(tblAnswer, didSelectRowAt: indexPath)
                
          
            */
            
            
            guard let arrayQuestion =  arrayChakraQuestion?[questionAtIndex].question else { return }
            guard let arrayAnswer =  arrayChakraQuestion?[questionAtIndex].options else { return }
           // guard let arrayRetake =  arrayChakraQuestion?[questionAtIndex].userAnsId else { return }
            
            print(arrayAnswer)
          //  print(arrayRetake)
            
           
            
            lblQuestion.text = arrayQuestion
            arrayChakraAnswer = arrayAnswer
            tblAnswer.reloadData()
            setBannerImage(index: questionAtIndex)
            questionIndex = questionAtIndex
        }
        else
        {
            
            
            guard let arrayQuestion =  arrayChakraQuestion?[questionAtIndex].question else { return }
            guard let arrayAnswer =  arrayChakraQuestion?[questionAtIndex].options else { return }
           // guard let arrayRetake =  arrayChakraQuestion?[questionAtIndex].userAnsId else { return }
            
            print(arrayAnswer)
          //  print(arrayRetake)
            
           
            
            lblQuestion.text = arrayQuestion
            arrayChakraAnswer = arrayAnswer
            tblAnswer.reloadData()
            setBannerImage(index: questionAtIndex)
            questionIndex = questionAtIndex
        }
    }
    //MARK: - Set bottom page number
    func setQuestionIndexBottom(pageIndex: Int) {
        if let quesCount = arrayChakraQuestion?.count {
            lblQuestionNo.text = "\(pageIndex) of \(quesCount)"
        }
    }
    
    //MARK: - Set Banner Image
    func setBannerImage(index: Int) {
        switch index {
        case 0:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner1)
            break
        case 1:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner2)
            break
        case 2:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner3)
            break
        case 3:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner4)
            break
        case 4:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner5)
            break
        case 5:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner6)
            break
        case 6:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner7)
            break
        case 7:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner8)
            break
        case 8:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner9)
            break
        default:
            imgBanner.image = UIImage(named: ConstantBannerImage.banner9)
            break
        }
    }
    
    func saveAnswerAPICall() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            
            guard let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            if arrayStoreAnswer!.count > 0 {
                let request = ChakraAnswerRequest(user_id: userId, answers: arrayStoreAnswer)
                chakraQuestionViewModel.saveChakraAnswer(request: request, token: token)
            }
            
        }
    }
}

//MARK: - TableView Delegate
extension QuestionOneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayAnswer =  arrayChakraAnswer else { return 0 }
        
        return arrayAnswer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "question1Cell", for: indexPath) as! question1Cell
        
        
        
        switch indexPath.row {
        case 0:
            cell.imgLeftCell.image = UIImage(named: ConstantSmileyImage.smiley1)
            break
        case 1:
            cell.imgLeftCell.image = UIImage(named: ConstantSmileyImage.smiley2)
            break
        case 2:
            cell.imgLeftCell.image = UIImage(named: ConstantSmileyImage.smiley3)
            break
        case 3:
            cell.imgLeftCell.image = UIImage(named: ConstantSmileyImage.smiley4)
            break
        case 4:
            cell.imgLeftCell.image = UIImage(named: ConstantSmileyImage.smiley5)
            break
        default:
            cell.imgLeftCell.image = UIImage(named: ConstantSmileyImage.smiley5)
            break
        }
        
        cell.viewAnswerCell.backgroundColor = UIColor(hexString: ConstantBackgroundHexColor.offWhite)
        cell.viewAnswerCell.layer.borderColor = UIColor.gray.cgColor
        cell.viewAnswerCell.layer.masksToBounds = false
        cell.viewAnswerCell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.viewAnswerCell.layer.shadowRadius = 2.0
        cell.viewAnswerCell.layer.shadowOpacity = 0.35
        
        
        
        //Check current question index and answerIndex is equal to indexPath.row then change color accordingly
    if let answerIndex = selectedCellIndex?[questionIndex]["answerIndex"] as? Int {
            
            print(answerIndex)
            print(indexPath.row)
            if UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFromsideMenu) != nil
                    {
     
                
                
                if answerIndex == indexPath.row {
                    switch answerIndex {
                    case 0:
                        cell.viewAnswerCell.backgroundColor = .white
                        cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row1).cgColor
                        cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row1).cgColor
                        break
                    case 1:
                        cell.viewAnswerCell.backgroundColor = .white
                        cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row2).cgColor
                        cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row3).cgColor
                        break
                    case 2:
                        cell.viewAnswerCell.backgroundColor = .white
                        cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row3).cgColor
                        cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row3).cgColor
                        break
                    case 3:
                        cell.viewAnswerCell.backgroundColor = .white
                        cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row4).cgColor
                        cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row4).cgColor
                        break
                    case 4:
                        cell.viewAnswerCell.backgroundColor = .white
                        cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row5).cgColor
                        cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row5).cgColor
                        break
                    default:
                        cell.viewAnswerCell.backgroundColor = .white
                        cell.viewAnswerCell.layer.borderColor = UIColor.gray.cgColor
                        cell.viewAnswerCell.layer.shadowColor = UIColor.gray.cgColor
                        break
                    }
                }
                
            }
            else{
            
            if answerIndex == indexPath.row {
                switch answerIndex {
                case 0:
                    cell.viewAnswerCell.backgroundColor = .white
                    cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row1).cgColor
                    cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row1).cgColor
                    break
                case 1:
                    cell.viewAnswerCell.backgroundColor = .white
                    cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row2).cgColor
                    cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row3).cgColor
                    break
                case 2:
                    cell.viewAnswerCell.backgroundColor = .white
                    cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row3).cgColor
                    cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row3).cgColor
                    break
                case 3:
                    cell.viewAnswerCell.backgroundColor = .white
                    cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row4).cgColor
                    cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row4).cgColor
                    break
                case 4:
                    cell.viewAnswerCell.backgroundColor = .white
                    cell.viewAnswerCell.layer.borderColor = UIColor(hexString: ConstantQuestionBorderColor.row5).cgColor
                    cell.viewAnswerCell.layer.shadowColor = UIColor(hexString: ConstantQuestionBorderColor.row5).cgColor
                    break
                default:
                    cell.viewAnswerCell.backgroundColor = .white
                    cell.viewAnswerCell.layer.borderColor = UIColor.gray.cgColor
                    cell.viewAnswerCell.layer.shadowColor = UIColor.gray.cgColor
                    break
                }
            }
        }
        }
        
        
//        print(arrayChakraAnswer?[indexPath.row].answer ?? 90)
        cell.lblAnswerCell.text = arrayChakraAnswer?[indexPath.row].answer
        
        
        return cell
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint(indexPath.row)
//        selectedCellIndex = indexPath.row
        //Store selected answer index according to the respective question to show selected answer and highlight them when going back to previous answer
        
        selectedCellIndex?[questionIndex] = ["questionIndex": questionIndex, "answerIndex":indexPath.row]
        
        print(questionIndex)
        print(indexPath.row)
        print(tableconter)
        
       
        //Store selected answer with question into the model and inside array to send via API
        if let chakraid = arrayChakraQuestion?[questionIndex].chakraId,
           let questionid = arrayChakraQuestion?[questionIndex].questionId,
           let answerid = arrayChakraQuestion?[questionIndex].options?[indexPath.row].answerId {
            
            arrayStoreAnswer?[questionIndex] = AnswerData(chakraId: chakraid, questionId: questionid, answerId: answerid)
        }
        
        tblAnswer.reloadData()
    }
    
}
