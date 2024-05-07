//
//  ContactUsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-18.
//

import UIKit

class ContactUsViewController: UIViewController, UITextFieldDelegate {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var imgSemiCircleBack: UIImageView!
    @IBOutlet var imgName: UIImageView!
    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet var imgPhone: UIImageView!
    @IBOutlet var imgMessage: UIImageView!
    @IBOutlet var imgCompanyEmail: UIImageView!
    @IBOutlet var imgCompanyPhone: UIImageView!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtViewMessage: UITextView!
    
    @IBOutlet var btnSend: UIBUtton_Designable!
    
    var contactViewModel = ContactUsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        contactViewModel.delegate = self
        
        setupUI()
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
    
    //MARK: -----SetupUI
    
    fileprivate func setupUI() {
        imgSemiCircleBack.tintColor = UIColor.colorSetup()
        imgName.tintColor = UIColor.colorSetup()
        imgEmail.tintColor = UIColor.colorSetup()
        imgPhone.tintColor = UIColor.colorSetup()
        imgMessage.tintColor = UIColor.colorSetup()
        imgCompanyEmail.tintColor = UIColor.colorSetup()
        imgCompanyPhone.tintColor = UIColor.colorSetup()
        btnSend.backgroundColor = UIColor.colorSetup()
    }
    
    //MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtPhone) {
            if (range.location == 0 && string == " ") {
                return false
            } else if (newString.count > 10) {
                return false
            } else {
                guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return false
                }
            }
        }
        return true
    }
    @IBAction func btnSend(_ sender: Any) {
        self.view.endEditing(true)
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
            
            if let name = txtName.text {
                if let email = txtEmail.text {
                    if let phoneNo = txtPhone.text {
                        if let msg = txtViewMessage.text {
                            if name.count > 0 && name != "" {
                                if ValidateEmail().isValidEmail(email) == true {
                                    if phoneNo.count < 10 {
                                        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.phoneValidation)
                                    } else {
                                        if ValidateTextView(textView: txtViewMessage) == true {
                                            let request = ContactUsRequest(name: name, email: email, phone: phoneNo, message: msg)
                                            
                                            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                                            contactViewModel.postContactUs(token: token, contactUsRequest: request)
                                        } else {
                                            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.msgEmpty)
                                        }
                                    }
                                } else {
                                    self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.emailValid)
                                }
                            } else {
                                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.nameEmpty)
                            }
                        } else {
                            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.msgEmpty)
                        }
                    } else {
                        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.userPhoneIsEmpty)
                    }
                } else {
                    self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.userEmailIsEmpty)
                }
            } else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantTextfieldAlertTitle.nameEmpty)
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

extension ContactUsViewController: ContactUsViewModelDelegate {
    func didReceiveContactUsResponse(contactUsResponse: ContactUsResponse?) {
        self.view.stopActivityIndicator()

        if(contactUsResponse?.status != nil && contactUsResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterStatDataResponse)
            
            if let msg = contactUsResponse?.message {
                showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: msg)
            }
            self.clearData()
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveContactUsError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    private func clearData() {
        self.txtName.text = nil
        self.txtEmail.text = nil
        self.txtPhone.text = nil
        self.txtViewMessage.text = nil
    }
}
