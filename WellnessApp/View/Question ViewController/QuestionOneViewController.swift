//
//  QuestionOneViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/09/21.
//

import UIKit

class question1Cell: UITableViewCell {
    
    @IBOutlet var viewAnswerCell: UIView!
    @IBOutlet var lblAnswerCell: UILabel!
    @IBOutlet var imgLeftCell: UIImageView!
}

class QuestionOneViewController: UIViewController {

    @IBOutlet var imgBanner: UIImageView!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var tblAnswer: UITableView!
    @IBOutlet var lblQuestionNo: UILabel!
    
    var chakraQuestionViewModel = ChakraQuestionViewModel()
    var arrayChakraQuestion: [ChakraResult]?
    var arrayChakraAnswer: [ChakraAnswer]?
    var arrayStoreAnswer: [AnswerData]?
    var answerData: AnswerData?
    var arrayRetakeQuestion: [RetakeResultdata]?
    var arrayRetakeAnswer: [RetakeAnswer]?
    
    var tableconter: Int = 0
    var counter: Int = 0
    var questionIndex: Int = 0
    var selectedCellIndex: [[String: Any]]?
    var flag: Int?
    var boolBackPressed = false
    
    var values: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chakraQuestionViewModel.delegate = self
        
        getQuestionData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        values = false
       // UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udFromTableviewSelected)
        
        guard let arrayData1 =  arrayChakraQuestion else {return}
                print(arrayData1)
    }

    //MARK: - Button Functions
    @IBAction func btnBack(_ sender: Any) {
        //De-advance the counter to match visible index
        print(counter)
        print(flag)
        
        if counter == flag {
            counter -= 1
        }
        if counter > 0 {
            setQuestionIndexBottom(pageIndex: counter)
            counter -= 1
            setQuestionData(questionAtIndex: counter)
        }
        
        if boolBackPressed == false {
            boolBackPressed = true
        }
        
        if counter == 0 {
            
            counter -= 1
            return
//            self.navigationController?.popViewController(animated: true)
        }
        
        if counter < 0
        {
            
            self.navigationController?.popViewController(animated: true)
        }
  //Logic is not cleared that's why blocked. developer Nilanjan
        
        
//        if counter == flag {
//            counter -= 1
//            print(counter)
//        }
//        if counter > 0 {
//            setQuestionIndexBottom(pageIndex: counter)
//            counter -= 1
//            print(counter)
//            setQuestionData(questionAtIndex: counter)
//        }
//
//        if boolBackPressed == false {
//            boolBackPressed = true
//        }
//
//        if UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFromsideMenu) != nil
//        {
//            print(counter)
////            if values != nil{
////
////                self.navigationController?.popViewController(animated: true)
////            }
////
////           if counter == 0
////            {
////               values = true
////
////
////           }
//
//
//        }
//        else
//        {
//            if counter == 0 {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//
//
    }
    
    @IBAction func btnNext(_ sender: Any) {
        guard let arrayData =  arrayChakraQuestion else { return }
        debugPrint(counter, arrayData.count)
        
        print(counter)
        print(arrayData.count)
        
        //Advance the counter to match visible index
        if boolBackPressed == true {
            boolBackPressed = false
            if counter == -1
              {
                counter += 2
            }
            else
            {
            counter += 1
                }
        }
        
//        if counter == 0 {
//            counter += 1
//            setQuestionIndexBottom(pageIndex: counter)
//        }
        
        //Check if last array data if no then next button will work as API call button
        if counter < arrayData.count {
            
 
            if arrayStoreAnswer?[counter - 1].answerId != nil { //If last answer is not selected then alert!!!
                setQuestionData(questionAtIndex: counter)
                setQuestionIndexBottom(pageIndex: counter + 1)
                counter += 1
                flag = counter
            } else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Please select a option")
            }
        } else {    //Check last array index answer then call API or show alert!!!
            if arrayStoreAnswer?[counter - 1].answerId != nil {
                debugPrint("API CALLLLLLLLL")
                saveAnswerAPICall()
            } else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Please select a option")
            }
        }
    }
}
