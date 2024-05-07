//
//  ChakraPopupViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/09/21.
//

import UIKit

protocol ChakraPopupViewControllerDelegate {
    func refreshViewController()
}

class ChakraPopupViewController: UIViewController {
    
    var delegate: ChakraPopupViewControllerDelegate?

    @IBOutlet var txtViewDesc: UITextView!
    
    var chakraName: String?
    var chakraLevel: Int?
    var prevChakraLevel: Int?
    private var chakraColor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setColorNameAndText()
    }
    
    func setColorNameAndText() {
        
        let chakraColour = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udChakraColorchange) as? Int ?? 0
        print("coloris ...--->>>",chakraColour)
        if chakraLevel != nil {
            print(Int(chakraLevel ?? 0))
            print(chakraColour)
            if chakraColour==0
                 {
            switch chakraLevel {
            case 1:
                chakraColor = ConstantChakraColorTitle.redRootChakra
                break
            case 2:
                chakraColor = ConstantChakraColorTitle.orangeSacralChakra
                break
            case 3:
                chakraColor = ConstantChakraColorTitle.yellowSolarChakra
                break
            case 4:
                chakraColor = ConstantChakraColorTitle.greenHeartChakra
                break
            case 5:
                chakraColor = ConstantChakraColorTitle.blueThroatChakra
                break
            case 6:
                chakraColor = ConstantChakraColorTitle.violetThirdEyeChakra
                break
            case 7:
                chakraColor = ConstantChakraColorTitle.purpleCrownChakra
                break
                
            default:
                chakraColor = ConstantChakraColorTitle.redRootChakra
                break
                }
            }
            
            else
            {
                switch chakraColour {
                case 1:
                    chakraColor = ConstantChakraColorTitle.redRootChakra
                    break
                case 2:
                    chakraColor = ConstantChakraColorTitle.orangeSacralChakra
                    break
                case 3:
                    chakraColor = ConstantChakraColorTitle.yellowSolarChakra
                    break
                case 4:
                    chakraColor = ConstantChakraColorTitle.greenHeartChakra
                    break
                case 5:
                    chakraColor = ConstantChakraColorTitle.blueThroatChakra
                    break
                case 6:
                    chakraColor = ConstantChakraColorTitle.violetThirdEyeChakra
                    break
                case 7:
                    chakraColor = ConstantChakraColorTitle.purpleCrownChakra
                    break

                default:
                    chakraColor = ConstantChakraColorTitle.redRootChakra
                    break
                    }
                }
            }
        

        if chakraLevel == 7 && prevChakraLevel == 7 {
            txtViewDesc.text = "Thank You For Your Responses. Based On Your Answers, All Of Your Chakras Are Open. Your Screen Will Now Be Changed To \(chakraColor ?? "Respective Color")."
        } else {
            txtViewDesc.text = "Thank You For Your Responses. Based On Your Answers, Your \(chakraName ?? "Chakra") Is Blocked. Your Screen Will Now Be Changed To \(chakraColor ?? "Respective Color"). To Jumpstart Your Healing & Regular Meditation Will Help You Open Up This Chakra."
        }
        txtViewDesc.textColor = UIColor.colorSetup()
        
    }

    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.refreshViewController()
        }
    }
}
