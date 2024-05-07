//
//  LoginViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 08/09/21.
//
import HealthKit
import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet var txtEmail: UITextField_Designable!
    @IBOutlet var txtPassword: UITextField_Designable!
    @IBOutlet var btnRememberMe: UIButton!
    @IBOutlet var btnEye: UIButton!
    
    var loginViewModel = LoginViewModel()
    var healthStore = HKHealthStore()
    var instagramApi = InstagramApi.shared
    var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    var instagramUser: InstagramUser?
    var signedIn = false
    
    var boolRememberMe = true
    var boolShowPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel.delegate = self
    }
    
    //MARK: - Button Func
    @IBAction func btnShowPassword(_ sender: Any) {
        if (boolShowPassword == false) {
            boolShowPassword = true
            txtPassword.isSecureTextEntry = false
            btnEye.setImage(UIImage.init(named: ConstantImageSet.hidePassword), for: .normal)
        } else {
            boolShowPassword = false
            txtPassword.isSecureTextEntry = true
            btnEye.setImage(UIImage.init(named: ConstantImageSet.showPassword), for: .normal)
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let forgotVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @IBAction func btnRememberMe(_ sender: Any) {
        if (boolRememberMe == false) {
            boolRememberMe = true
            btnRememberMe.setImage(UIImage.init(named: "check"), for: .normal)
        } else {
            boolRememberMe = false
            btnRememberMe.setImage(UIImage.init(named: "uncheck"), for: .normal)
        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udSocialLoginBool)  //To check andset profile image accordingly on SideMenu & ProfileVC
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let FCMToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            
            let request = LoginRequest(userId: txtEmail.text, password: txtPassword.text, FCMToken: FCMToken)
            loginViewModel.loginUser(loginRequest: request)
        }
    }
    
    @IBAction func btnFacebookLogin(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udSocialLoginBool)   //To check and set profile image accordingly on SideMenu & ProfileVC
        FacebookInit()
    }
    
    @IBAction func btnGoogleLogin(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udSocialLoginBool)   //To check and set profile image accordingly on SideMenu & ProfileVC
        GoogleInit()
    }
    
    @IBAction func btnInstagramLogin(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udSocialLoginBool)   //To check and set profile image accordingly on SideMenu & ProfileVC
        InstagramInit()
    }
    
    @IBAction func btnAppleLogin(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udSocialLoginBool)   //To check and set profile image accordingly on SideMenu & ProfileVC
        AppleInit()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udSocialLoginBool)  //To check and set profile image accordingly on SideMenu & ProfileVC
        let signupVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
       self.navigationController?.pushViewController(signupVC, animated: true)


        
              
    }
    
}

extension LoginViewController: WebviewDelegate, LoginViewModelDelegate {
    
    //MARK: - Social Login Delegate
    func didReceiveSocialLoginResponse(loginResponse: LoginResponse?) {
        self.view.stopActivityIndicator()
        
        if(loginResponse?.status != nil && loginResponse?.status?.lowercased() == ConstantStatusAPI.success && loginResponse?.userDetail != nil) {


            //            dump(loginResponse?.userDetail)
            
            let userDetails = LoginUserDetails(_id: loginResponse?.userDetail?._id, userId: loginResponse?.userDetail?.userId, userName: loginResponse?.userDetail?.userName, userEmail: loginResponse?.userDetail?.userEmail, mobileNo: loginResponse?.userDetail?.mobileNo, profileImg: loginResponse?.userDetail?.profileImg, otp: loginResponse?.userDetail?.otp, status: loginResponse?.userDetail?.status, chakraRes: loginResponse?.userDetail?.chakraRes, socialId: loginResponse?.userDetail?.socialId, socialType: loginResponse?.userDetail?.socialType, timeZone: loginResponse?.userDetail?.timeZone, location: loginResponse?.userDetail?.location)
            
            do {
                //Check Readme doc to extract data and Decode from userDefault
                let dataEncode = try JSONEncoder().encode(userDetails)
                UserDefaults.standard.set(dataEncode, forKey: ConstantUserDefaultTag.udUserDetails)
                UserDefaults.standard.set(loginResponse?.userDetail?.userId, forKey: ConstantUserDefaultTag.udUserId)
                UserDefaults.standard.set(loginResponse?.userDetail?.userName, forKey: ConstantUserDefaultTag.udUserName)
                UserDefaults.standard.set(loginResponse?.userDetail?.userEmail, forKey: ConstantUserDefaultTag.udUserEmail)
                UserDefaults.standard.set(loginResponse?.tokenValidate, forKey: ConstantUserDefaultTag.udToken)

                
            } catch let error {
                print(error.localizedDescription)
            }
            
            //            //Need to check Question answer flag API, if success then HomeVC (rememberMe = true) other wise QuestionOneVC (rememberMe = false, set true in Chakra screen) udUserEmail
            if loginResponse?.userDetail?.chakraRes == 0 {
                
                UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udTempRememberMe)
                UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udQuestions) //Bool
                
                let welcomeVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "Welcome2ViewController") as! Welcome2ViewController
                self.navigationController?.pushViewController(welcomeVC, animated: true)
            } else {
//                UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udRememberMe) //Bool always true for social login
//                UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udQuestions) //Bool
//
//                let homeVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "BaseTabBarViewController") as! BaseTabBarViewController
//                self.navigationController?.pushViewController(homeVC, animated: true)
                
                let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to measure your regular activities through", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "iPhone", style: .default, handler: { (action: UIAlertAction!) in
                      print("Handle Ok logic here")
                                    UserDefaults.standard.set(false, forKey: "isFromWatch")
                                     UserDefaults.standard.set(false, forKey: "isPermissiongranted")
                                     UserDefaults.standard.set(false, forKey: "isFromRecordedSession")
                                    UserDefaults.standard.set(false, forKey: "isFromCoachRecordedSession")
               
                                    UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udRememberMe) //Bool always true for social login
                                    UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udQuestions) //Bool
                    
                                    let homeVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "BaseTabBarViewController") as! BaseTabBarViewController
                                    self.navigationController?.pushViewController(homeVC, animated: true)
                    
                            
                    
                }))

                refreshAlert.addAction(UIAlertAction(title: "Apple Watch", style: .cancel, handler: { (action: UIAlertAction!) in
                      print("Handle Cancel Logic here")
                    
                   
                    self.autorizeHealthKit()
                    
                }))

                present(refreshAlert, animated: true, completion: nil)
                
            }
            
            //Remove stored Apple login data
            UserDefaults.standard.removeObject(forKey: ConstantUserDefaultTag.udAppleSignInData)
            
            //Start all time step tracking in app delegate
            (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: loginResponse?.message ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    func didReceiveSocialLoginError(statusCode: String?) {
        self.view.stopActivityIndicator()
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    func autorizeHealthKit()
    {
        let read = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!,HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning)!])
//        let share = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!,HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning)!])
        healthStore.requestAuthorization(toShare: read, read: read) { (chk, err) in
                                                                     
        if chk{
                print("Permission granted")
                                                                        // self.LatestHeartRate()
                                                                        //  self.stepcount()
                                                                        // self.retrieveSleepAnalysis()
                                                                       //  self.readSleep(from: Date.yesterday, to: Date.tomorrow )
                                                                         
                DispatchQueue.main.async {
                    
                    UserDefaults.standard.set(true, forKey: "isFromWatch")
                    UserDefaults.standard.set(true, forKey: "isPermissiongranted")
                                                                         
                    UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udQuestions) //Bool
                    UserDefaults.standard.set(self.boolRememberMe, forKey: ConstantUserDefaultTag.udRememberMe) //Bool
 
                     let homeVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "BaseTabBarViewController") as! BaseTabBarViewController
                     self.navigationController?.pushViewController(homeVC, animated: true)
                                                                            
                }
            }
        }
    }
                                                                
    //MARK: - Login Delegate
    func didReceiveLoginResponse(loginResponse: LoginResponse?) {
        self.view.stopActivityIndicator()
        
        if(loginResponse?.status != nil && loginResponse?.status?.lowercased() == ConstantStatusAPI.success && loginResponse?.userDetail != nil) {
            //            dump(loginResponse?.userDetail)
            
            let userDetails = LoginUserDetails(_id: loginResponse?.userDetail?._id, userId: loginResponse?.userDetail?.userId, userName: loginResponse?.userDetail?.userName, userEmail: loginResponse?.userDetail?.userEmail, mobileNo: loginResponse?.userDetail?.mobileNo, profileImg: loginResponse?.userDetail?.profileImg, otp: loginResponse?.userDetail?.otp, status: loginResponse?.userDetail?.status, chakraRes: loginResponse?.userDetail?.chakraRes, socialId: loginResponse?.userDetail?.socialId, socialType: loginResponse?.userDetail?.socialType, timeZone: loginResponse?.userDetail?.timeZone, location: loginResponse?.userDetail?.location,type: loginResponse?.userDetail?.type)
            
            do {
                //Check Readme doc to extract data and Decode from userDefault
                let dataEncode = try JSONEncoder().encode(userDetails)
                UserDefaults.standard.set(dataEncode, forKey: ConstantUserDefaultTag.udUserDetails)
                UserDefaults.standard.set(loginResponse?.userDetail?.userId, forKey: ConstantUserDefaultTag.udUserId)
                UserDefaults.standard.set(loginResponse?.userDetail?.userName, forKey: ConstantUserDefaultTag.udUserName)
                UserDefaults.standard.set(loginResponse?.userDetail?.userEmail, forKey: ConstantUserDefaultTag.udUserEmail)
                UserDefaults.standard.set(loginResponse?.tokenValidate, forKey: ConstantUserDefaultTag.udToken)
            } catch let error {
                print(error.localizedDescription)
            }

            print(loginResponse?.userDetail?.deleted ?? "")
            if loginResponse?.userDetail?.deleted == true
            {

                let refreshAlert = UIAlertController(title: "Luvo", message: "Your acount is permanently deleted", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                      print("Handle Ok logic here")

                }))



                present(refreshAlert, animated: true, completion: nil)
            }
            else
            {
            
            if (loginResponse?.userDetail?.status == "Active") {
                //Need to check Question answer flag (chakraRes) API, if success then HomeVC (rememberMe = true) other wise QuestionOneVC (rememberMe = false, set true in Chakra screen)
                if loginResponse?.userDetail?.chakraRes == 0 {
                    UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udQuestions) //Bool
                    UserDefaults.standard.set(boolRememberMe, forKey: ConstantUserDefaultTag.udTempRememberMe)
                    let welcomeVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "Welcome2ViewController") as! Welcome2ViewController
                    self.navigationController?.pushViewController(welcomeVC, animated: true)
                    //                    let quesVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "QuestionOneViewController") as! QuestionOneViewController
                    //                    self.navigationController?.pushViewController(quesVC, animated: true)
                    
                } else {
                    
                    if loginResponse?.userDetail?.type == "Coach"
                    {
                        //boolRememberMe = true
                        UserDefaults.standard.set(loginResponse?.userDetail?.chakraRes, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)
                        UserDefaults.standard.set(loginResponse?.userDetail?.location, forKey: "CoachProfileImage")
                        UserDefaults.standard.set(loginResponse?.userDetail?.userId, forKey: "CoachID")
                        debugPrint(UserDefaults.standard.value(forKey: "CoachProfileImage") ?? "Test")
                        
                       // UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udQuestions) //Bool
                        UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udRememberMe)
                        UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udFromCoachVC)
                        let signupVC = ConstantStoryboard.Coach.instantiateViewController(identifier: "CoachViewController") as! CoachViewController
                        self.navigationController?.pushViewController(signupVC, animated: true)
                        
                    }
                    else
                    {
                    let refreshAlert = UIAlertController(title: "Luvo", message: "Do you want to measure your regular activities through", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "iPhone", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                        
                        UserDefaults.standard.set(false, forKey: "isFromWatch")
                                           UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udQuestions) //Bool
                        UserDefaults.standard.set(self.boolRememberMe, forKey: ConstantUserDefaultTag.udRememberMe) //Bool
                        
                                            let homeVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "BaseTabBarViewController") as! BaseTabBarViewController
                                            self.navigationController?.pushViewController(homeVC, animated: true)
                        
                              
                        
                    }))

                    refreshAlert.addAction(UIAlertAction(title: "Apple Watch", style: .cancel, handler: { (action: UIAlertAction!) in
                          print("Handle Cancel Logic here")
                        
                       
                        self.autorizeHealthKit()
                        
                    }))

                    present(refreshAlert, animated: true, completion: nil)
                    
                    }
                }
            }
                else {
                UserDefaults.standard.set(boolRememberMe, forKey: ConstantUserDefaultTag.udTempRememberMe)
                let otpVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                otpVC.fromVC = "loginVC"
                otpVC.tempOTP = loginResponse?.userDetail?.otp
                self.navigationController?.pushViewController(otpVC, animated: true)
            }
            
            //Start all time step tracking in app delegate
            (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
            }
        } else if (loginResponse?.status == nil) {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: loginResponse?.message ?? ConstantAlertMessage.TryAgainLater)
        }
    }

    
    func didReceiveLoginError(statusCode: String?) {
        self.view.stopActivityIndicator()
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
                                                         
 
extension LoginViewController: ASAuthorizationControllerDelegate {
    //MARK: - Facebook Init ---------------
    private func FacebookInit() {
        if let fbToken = AccessToken.current {
            if (!(fbToken.isExpired)) {
                self.getUserProfile(token: fbToken, userId: fbToken.userID)
            }
        } else {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { [weak self] result, error in    //{ result, error in
                if error != nil {
                    print("ERROR: Trying to get login results")
                } else if result?.isCancelled != nil {
                    print("The token is \(result?.token?.tokenString ?? "")")
                    if result?.token?.tokenString != nil {
                        print("Logged in")
                        self?.getUserProfile(token: result?.token, userId: result?.token?.userID)
                    } else {
                        print("Cancelled")
                    }
                }
            })
        }
    }
    
    //MARK: - Facebook Func --------------
    private func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                var fbName, fbEmail, fbId: String?
                
                let data: [String: AnyObject] = result as! [String: AnyObject]
                
                // Facebook Id
                if let facebookId = data["id"] as? String {
                    print("Facebook Id: \(facebookId)")
                    fbId = facebookId
                } else {
                    print("Facebook Id: Not exists")
                }
                
                // Facebook First Name
                if let facebookFirstName = data["first_name"] as? String {
                    print("Facebook First Name: \(facebookFirstName)")
                } else {
                    print("Facebook First Name: Not exists")
                }
                
                // Facebook Middle Name
                if let facebookMiddleName = data["middle_name"] as? String {
                    print("Facebook Middle Name: \(facebookMiddleName)")
                } else {
                    print("Facebook Middle Name: Not exists")
                }
                
                // Facebook Last Name
                if let facebookLastName = data["last_name"] as? String {
                    print("Facebook Last Name: \(facebookLastName)")
                } else {
                    print("Facebook Last Name: Not exists")
                }
                
                // Facebook Name
                if let facebookName = data["name"] as? String {
                    print("Facebook Name: \(facebookName)")
                    fbName = facebookName
                } else {
                    print("Facebook Name: Not exists")
                }
                
                // Facebook Profile Pic URL
                let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                
                // Facebook Email
                if let facebookEmail = data["email"] as? String {
                    print("Facebook Email: \(facebookEmail)")
                    fbEmail = facebookEmail
                } else {
                    print("Facebook Email: Not exists")
                }
                
                print("Facebook Access Token: \(token?.tokenString ?? "")")
                
                //------------------------------------------
                guard let FCMToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }
                
                let request = SocialLoginRequest(name: fbName, userEmail: fbEmail, socialId: fbId, socialType: ConstantSocialType.facebook, profileImg: facebookProfilePicURL, FCMToken: FCMToken)
                self.postSocialLogin(request: request)
                
            } else {
                print("Error: Trying to get user's info")
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Failed to get user infos. Try again")
            }
        }
    }
    
    //MARK: - Instagram Init --------------
    private func InstagramInit() {
        presentWebViewController()
    }
    
    //MARK: - Instagram Func --------------
    private func presentWebViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "webView") as! WebViewController
        webVC.instagramApi = self.instagramApi
        webVC.mainVC = self
        webVC.delegate = self
        self.present(webVC, animated:true)
    }
    
    //Delegate Func
    func GetUserData() {
        self.instagramApi.getInstagramUser(testUserData: self.testUserData) { [weak self] (user, error) in
            debugPrint(user as Any)
            
            if (error == nil) {
                self?.instagramUser = user
                self?.signedIn = true
                DispatchQueue.main.async {
                    self?.presentAlert()
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: error ?? ConstantAlertTitle.ErrorAlertTitle)
                }
            }
            
        }
    }
    
    private func presentAlert() {
        self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                     message: "Signed with account: @\(self.instagramUser?.username ?? "")",
                                     alertStyle: .alert, actionTitles: [ConstantAlertTitle.OkAlertTitle],
                                     actionStyles: [.default],
                                     actions: [
                                        { _ in
                                            
                                            //------------------------------------------
                                            guard let FCMToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
                                                self.view.stopActivityIndicator()
                                                return
                                            }
                                            
                                            let request = SocialLoginRequest(name: self.instagramUser?.username, userEmail: nil, socialId: self.instagramUser?.id, socialType: ConstantSocialType.instagram, profileImg: ConstantDefaultImage.defaultImage, FCMToken: FCMToken)
                                            self.postSocialLogin(request: request)
                                        }])
    }
    
    //MARK: - Google Login --------------
    private func GoogleInit() {
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkPleaseWait, color: UIColor.white)
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            //handle sign-in errors
            if let error = error {
                print("error signing into Google \(error.localizedDescription)")
                self.view.stopActivityIndicator()
                return
            }
            
            // Get credential object using Google ID token and Google access token
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                self.view.stopActivityIndicator()
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // Authenticate with Firebase using the credential object
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.view.stopActivityIndicator()
                    print("google authentication error \(error.localizedDescription)")
                } else {
                    let user = authResult?.user
                    if let user = user {
                        var g_email, g_profileImg, g_userName, g_phoneNo: String?
                        // The user's ID, unique to the Firebase project.
                        // Do NOT use this value to authenticate with your backend server,
                        // if you have one. Use getTokenWithCompletion:completion: instead.
                        let uid = user.uid
                        print("GoogleLogin UID -------> \(uid)")
                        if let email = user.email {
                            g_email = email
                        } else {
                            print("google email not available")
                        }
                        if let photoURL = user.photoURL {
                            g_profileImg = "\(photoURL)"
                        } else {
                            print("google profile image not available")
                        }
                        if let userName = user.displayName {
                            g_userName = userName
                        } else {
                            print("google user name not available")
                        }
                        if let phoneNo = user.phoneNumber {
                            g_phoneNo = phoneNo
                        } else {
                            print("google phone number not available")
                        }
                        
                        print("Google ----> \(uid)\n\(g_email)\n\(g_profileImg)\n\(g_userName)\n\(String(describing: g_phoneNo))")
                        
                        //------------------------------------------
                        guard let FCMToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
                            self.view.stopActivityIndicator()
                            return
                        }
                        let request = SocialLoginRequest(name: g_userName, userEmail: g_email, socialId: uid, socialType: ConstantSocialType.google, profileImg: g_profileImg, FCMToken: FCMToken)
                        self.postSocialLogin(request: request)
                    }
                }
            }
        }
    }
    
    //MARK: - Apple Login -------------
    ///https://stackoverflow.com/questions/57545635/cannot-get-name-email-with-sign-in-with-apple-on-real-device
    ///First time apple login will give user info. But on second time it will only return userID only. For better explanation visit the above link
    ///Apple executive response:-
    ///This behaves correctly, user info is only sent in the ASAuthorizationAppleIDCredential upon initial user sign up. Subsequent logins to your app using Sign In with Apple with the same account do not share any user info and will only return a user identifier in the ASAuthorizationAppleIDCredential. It is recommened that you securely cache the initial ASAuthorizationAppleIDCredential containing the user info until you can validate that an account has succesfully been created on your server.
    
    private func AppleInit() {
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkPleaseWait, color: UIColor.white)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.view.stopActivityIndicator()
        
        do {
            if let data = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udAppleSignInData) {
                let storedData = try JSONDecoder().decode(SocialLoginRequest.self, from: data as! Data)
                
                if let sleepData = storedData.socialId {
                    if !sleepData.isEmpty {
                        syncAppleData(storedData: storedData)
                    }
                }
            } else {
                if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
                    let userID = appleIDCredential.user
                    let fullName = appleIDCredential.fullName
                    let firstName = appleIDCredential.fullName?.givenName
                    let lastName = appleIDCredential.fullName?.familyName
                    let email = appleIDCredential.email
                    
                    print("User ID: \(userID) \n Full Name: \(fullName) \n First Name: \(firstName ?? "") \n Last Name: \(lastName ?? "") \n Email id: \(email)")
                    
                    ///On successful authorization, we get User Info which has User Identifier.
                    ///We can use that identifier to check the user’s credential state by calling the below method
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    appleIDProvider.getCredentialState(forUserID: userID) {  (credentialState, error) in
                        switch credentialState {
                        case .authorized:
                            // The Apple ID credential is valid.
                          //  self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Apple Sign In successful")
                            
                            //------------------------------------------
                            guard let FCMToken = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udFCMToken) as? String else {
                                self.view.stopActivityIndicator()
                                return
                            }
                            
                            //Concat first & last name together
                            var name: String? = nil
                            if let firstName = firstName, let lastName = lastName {
                                name = String(format: "%@ %@", firstName, lastName)
                            }
                            
                            do{
                                let request = SocialLoginRequest(name: name,
                                                                 userEmail: email,
                                                                 socialId: userID,
                                                                 socialType: ConstantSocialType.apple,
                                                                 profileImg: ConstantDefaultImage.defaultImage,
                                                                 FCMToken: FCMToken)
                                
                                print("APPLE LOGIN ------> \(request)")
                                
                                ///Need to store apple login data for the first time because if social login API failed then it will get the apple login data for next try. Apple doesn't provide user info on second login retry.
                                let storeAppleSignInData = try JSONEncoder().encode(request)
                                UserDefaults.standard.set(storeAppleSignInData, forKey: ConstantUserDefaultTag.udAppleSignInData)
                                
                                self.postSocialLogin(request: request)
                            } catch let error {
                                print("apple login Error----->",error)
                            }
                            break
                        case .revoked:
                            // The Apple ID credential is revoked.
                            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Apple ID revoked. Please try again later")
                            break
                        case .notFound:
                            // No credential was found, so show the sign-in UI.
                            self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Apple ID not found. Please try again later")
                        default:
                            break
                        }
                    }
                }
            }
        } catch let error {
            print("apple authorizationController--->\(error.localizedDescription)")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.view.stopActivityIndicator()
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: "Apple Sign In failed. Please try again later")
    }
    
    //MARK: - Sync Apple Data
    private func syncAppleData(storedData: SocialLoginRequest) {
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        
        guard let name = storedData.name,
              let userEmail = storedData.userEmail,
              let userID = storedData.socialId,
              let socialType = storedData.socialType,
              let profileImage = storedData.profileImg,
              let FCMToken = storedData.FCMToken else {
            
            self.view.stopActivityIndicator()
            return
        }
        
        let request = SocialLoginRequest(name: name,
                                         userEmail: userEmail,
                                         socialId: userID,
                                         socialType: socialType,
                                         profileImg: profileImage,
                                         FCMToken: FCMToken)
        
        //API call
        self.postSocialLogin(request: request)
    }
    
    //MARK: - Social Login API Call--------------
    private func postSocialLogin(request: SocialLoginRequest) {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            DispatchQueue.main.async {
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            }
            loginViewModel.socialLoginUser(loginRequest: request)
        }
    }
}
