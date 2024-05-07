
//  AppDelegate.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 01/09/21.
//
import StripeApplePay
import HealthKit
import UIKit
import CoreData
import FBSDKCoreKit
import IQKeyboardManagerSwift
import HealthKit
import BackgroundTasks
import CoreMotion
import CoreLocation
import Firebase
import UserNotifications
import GoogleSignIn
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var vil : Int = 0
    var arrDistance = [String]()
    
    var arrayStepDta: [stepWatchData]?
    var StepData: stepWatchData?
   
    var stepWatchViewModel = StepWatchViewModel()
//    var step: String?
//    var distance: String?
    var bgStepViewModel = BackgroundStepUpdateViewModel()
    private var heartViewModel = HeartViewModel()
    var healthStore = HKHealthStore()
    
    private var countdownTimer: Timer?
    var motionActivityManager = CMMotionActivityManager()
    var pedometer = CMPedometer()
    var locationManager:CLLocationManager?
    var startLat, startLong, endLat, endLong: Double?
    
    var steps = 0
//    var totalSteps = 0
    var distance = 0.0
//    var totalDistance = 0.0
    
    var storeSteps = 0
    var storeDistance = 0.0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
      //  self.isAppAlreadyLaunchedOnce()
     //   UserDefaults.standard.set(false, forKey: ConstantUserDefaultTag.udFromBackGround)
        //IQKeyboardManager
        StripeAPI.defaultPublishableKey = "pk_live_51MR4HrLN2CBttmwhGRIByYVtk2OVquYLYeuUZwYStS6NN9DBSHWDIhoAelchfL94A2IKguWvfqPiYzW2wNcOO9Bp00REnQ6zvt"
        IQKeyboardManager.shared.enable = true
        //-------------------------------------
        
        //Facebook SDK Init (Note: The implementation was done on SceneDelegate.swift)
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        //--------------------------------------
        
//        //Background Task
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.luvo.fetchSteps",
//                                        using: nil) { (task) in
//            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
//        }
        //-----------------------------------------------
        
        //Firebase Push Notification
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        //-------------------------------------------------
        
        //AVAudioSession is defined here because to run audio playback in background.
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, policy: AVAudioSession.RouteSharingPolicy.default, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("AppDelegate--->\(error.localizedDescription)")
        }
        
        return true
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
            let defaults = UserDefaults.standard

            if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
                print("App already launched : \(String(describing: isAppAlreadyLaunchedOnce))")
                return true
            }else{
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
                print("App launched first time")
                return false
            }
        }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    //MARK: - Push Notification
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    //-----------------------------------

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Luvo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK: - BACKGROUND TASK
    func trackBGSteps() {
        setupLocationManager()
        setupCMActivity()
        
        //Start traking will be done after Login, Social Login and Signup response. Because after response we will get userToken
//        startTracking()
    }
    
    func setupLocationManager() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager?.distanceFilter = kCLDistanceFilterNone
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.requestAlwaysAuthorization()
            
            if let currentLocation = locationManager?.location {
//                print("First location----->",currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
                startLat = currentLocation.coordinate.latitude
                startLong = currentLocation.coordinate.longitude
            }
            
        } else {
            //Alert to enable location from settings
        }
    }
    
    ///Start tracking is called after normal login, social login, signup & from sceneDelegate when entering  BaseTabBarViwController
    func startTracking() {
        print("Exercise Start Background Tracking----------------------->")
        locationManager?.startUpdatingLocation()
//        locationManager?.startMonitoringSignificantLocationChanges()
        
        startPedometer()
        startTimer()
        
        
      //  self.stepcount()
    }
    
    //Call this to stop tracking
    func stopTracking(){
        print("Exercise Stop Background Tracking----------------------->")
//        locationManager?.stopUpdatingLocation()   ////Don't stop location fetch because it will not start as background service.
        pedometer.stopUpdates()
        
        if let timer = self.countdownTimer {
            timer.invalidate()
            self.countdownTimer = nil
        }
        
        //Store step & distance before resetting
        self.storeSteps = self.steps
        self.storeDistance = self.distance
        
        //Reset
//        self.steps = 0
//        self.totalSteps = 0
//        self.distance = 0.0
//        self.totalDistance = 0.0
//        globalStepCounter = 0
    }
    
    //MARK: - Pedometer Func
    func setupCMActivity() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (data) in
                DispatchQueue.main.async {
                    if let activity = data {
                        if activity.running == true {
                            print("AppDel---->Running")
                        }else if activity.walking == true {
                            print("AppDel---->Walking")
                        }else if activity.automotive == true {
                            print("AppDel---->Automative")
                        }
                    }
                }
            }
        }
    }
    
    func startPedometer() {
        self.pedometer.startUpdates(from: Date()) { (data, error) in
            if error == nil {
                if let response = data {
                    DispatchQueue.main.async {
                        print("APP DELE Number Of Steps == \(response.numberOfSteps)")
                        print("APP DELE Distance covered in meters = \(String(describing: response.distance))")
                        self.steps = response.numberOfSteps.intValue
                        if let distance = response.distance {
                            self.distance = distance.doubleValue
                            print("DISTANCE(meters)---->\(self.distance)")
                            print("STEP---->\(self.steps)")
//                            print("GLOBAL---->\(globalStepCounter)")
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Timer
    func startTimer() {
        
        countdownTimer?.invalidate() //cancels it if already running
        countdownTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(calculateStepsData), userInfo: nil, repeats: true) //1hr call
    }
    
    @objc func calculateStepsData() {
        
        guard let tokeen = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {

            return
        }

        
        let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                print(status)

                if status==true
        {
                //stopTracking()
                //  autorizeHealthKit()
                //  self.stepcount()
                    self.distancetravel()
        }

        else
        {
        
//        var globalStepCounter = 0
        
//        if steps > totalSteps {
//            totalSteps = steps - totalSteps
//            storeSteps = steps
//        } else {
//            totalSteps totalSteps - steps
//            storeSteps = steps
//        }
//
//        if totalSteps > 0 && totalSteps > globalStepCounter {
//            totalSteps = totalSteps - globalStepCounter //Global step count from exerciseStartVC so that it can be deducted here for no duplicate data.
//            storeSteps = storeSteps + globalStepCounter
//
//            let meterToMiles = distance * 0.0006213712
//            totalDistance = meterToMiles - totalDistance
//            storeDistance = totalDistance
//            print("Step---\(steps)   Total step---\(totalSteps)  Total Distance---\(totalDistance)")
//    //        UserDefaults.standard.setValue(totalSteps, forKey: ConstantUserDefaultTag.udStepsCount) //To show in ExerciseVC
//            updateStepsData(totalStep: totalSteps, distance: totalDistance)
//
//        } else {
//            totalSteps = globalStepCounter - totalSteps //Global step count from exerciseStartVC so that it can be deducted here for no duplicate data.
//            storeSteps = storeSteps + globalStepCounter
//
//            let meterToMiles = distance * 0.0006213712
//            totalDistance = meterToMiles - totalDistance
//            storeDistance = totalDistance
//            print("Step---\(steps)   Total step---\(totalSteps)  Total Distance---\(totalDistance)")
//    //        UserDefaults.standard.setValue(totalSteps, forKey: ConstantUserDefaultTag.udStepsCount) //To show in ExerciseVC
//            updateStepsData(totalStep: totalSteps, distance: totalDistance)
//        }
        
        //New updated - pk04feb2022
        ///Example:
        ///1st hr = 100 steps
        ///2nd hr = 200 steps (included 1st hr step)
        ///Thus we need to deduct previous step from current step as it has been already sent by API
        ///**We are getting step all the time unless we stop the pedometer, then it will count steps from 0. Thus we dont need to store previous total step for deduction from current total steps.
        if self.steps != 0 {
            
            let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                    print(status)
    
                   if status==true
            {
            
//            self.steps = 0
//            self.storeSteps = 0
//            self.distance = 0.0
//            self.storeDistance = 0.0
//
//
//
//
//            self.steps = self.steps + self.storeSteps
//            self.distance = self.distance + self.storeDistance
//
//            let meterToMiles = self.distance * 0.0006213712
//
//            //Stop Tracking (Start tracking after Step Update API call - bgStepViewModel.postBGStepUpdate)
//            //Make sure it is called after step & distance calculation
//            self.stopTracking()
//
//            var gpsDistance = 0.00
//            if let startLat = startLat, let startLong = startLong, let endLat = endLat, let endLong = endLong {
//                gpsDistance = calculateGPSDistance(startLocation: CLLocation(latitude: startLat, longitude: startLong), endLocation: CLLocation(latitude: endLat, longitude: endLong))
//            }
//
//            print("API DATA TO SEND---> Step--- \(self.steps) Total Distance--- \(meterToMiles) GPS Dist--- \(gpsDistance)")
          //  updateStepsData(totalStep: self.steps, distance: meterToMiles, gpsDistance: gpsDistance)
                       
                   }
            
            else
            {
                
 //               self.startTracking()
//                self.steps = 0
//                self.storeSteps = 0
//                self.distance = 0.0
//                self.storeDistance = 0.0
                
                self.steps = self.steps + self.storeSteps
                self.distance = self.distance + self.storeDistance
                
                let meterToMiles = self.distance * 0.0006213712
                
                //Stop Tracking (Start tracking after Step Update API call - bgStepViewModel.postBGStepUpdate)
                //Make sure it is called after step & distance calculation
                self.stopTracking()
                
                var gpsDistance = 0.00
                if let startLat = startLat, let startLong = startLong, let endLat = endLat, let endLong = endLong {
                    gpsDistance = calculateGPSDistance(startLocation: CLLocation(latitude: startLat, longitude: startLong), endLocation: CLLocation(latitude: endLat, longitude: endLong))
                }
                
                print("API DATA TO SEND---> Step--- \(self.steps) Total Distance--- \(meterToMiles) GPS Dist--- \(gpsDistance)")
                updateStepsData(totalStep: self.steps, distance: meterToMiles, gpsDistance: gpsDistance)
                           
            }
        }
     }
    }
    
    
    @objc func autorizeHealthKit()
        {
            let read = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!,HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning)!])
//            let share = Set([HKObjectType.quantityType(forIdentifier:.heartRate)!,HKObjectType.quantityType(forIdentifier:.stepCount)!,HKObjectType.categoryType(forIdentifier:.sleepAnalysis)!])
            healthStore.requestAuthorization(toShare: read, read: read) { (chk, err) in
                
                if chk
                {
                    print("Permission granted")
                    
    //                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
    //                    self.LatestHeartRate()
    //                })
                    
                    
                   // self.LatestHeartRate()
                  //  self.getAVGHeartRate()
                     self.stepcount()
                  //  self.retrieveSleepAnalysis()
                  //  self.readSleep(from: Date.yesterday, to: Date.tomorrow )
                  //  self.distancetravel()
                    
                   
                }
            }
        }
    
    /*
    
    func date()
    {
        
        guard let smaplequery = HKObjectType.quantityType(forIdentifier:.stepCount) else
        {
            return
        }
        
        let date = Date() // current date or replace with a specific date
        let calendar = Calendar.current
       
        let endTime = calendar.date(bySettingHour: 24, minute: 59, second: 59, of: date)
        let startdatee = calendar.date(bySettingHour: 00, minute: 00, second: 59, of: date)
        let startdate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startdate, end: Date() , options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let limit = 0
        
        let query = HKSampleQuery(
            sampleType: smaplequery,
            predicate: predicate,
            limit: limit,
            sortDescriptors: [ sortDescriptor ]) {(sample, results, error) in
                guard error == nil else
                {
                    return
                }
                
            // Process the results
                
                var workouts: [HKWorkout] = []

                if let results = results {
                    for result in results {
                        if let workout = result as? HKWorkout {
                            // Here's a HKWorkout object
                            workouts.append(workout)
                        }
                    }
                }
                else {
                    // No results were returned, check the error
                }
                
        }
        
        healthStore.execute(query)
        
        
       
        
//        DispatchQueue.main.async {
//
//
//
//            let date = Date() // save date, so all components use the same date
//            let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
//
//            let hour : Int = calendar.component(.hour, from: date)
//            debugPrint(hour)
//
//            for i in stride(from: 0, to: hour, by: 1) {
//                print(i)
//
//
//            }
//            self.test(hourval: 0)
//
//        }
        
       

    }
    
    
    func test(hourval:Int)
    {
        
        debugPrint(vil)
            //   above new implmentation of hart rate
            
            guard let smaplequery = HKObjectType.quantityType(forIdentifier:.stepCount) else
            {
                return
            }
            let date = Date() // current date or replace with a specific date
            let calendar = Calendar.current
           
            let endTime = calendar.date(bySettingHour: vil, minute: 59, second: 59, of: date)
            let startdatee = calendar.date(bySettingHour: 00, minute: 00, second: 59, of: date)
            
           
            let datee = calendar.date(byAdding: .minute, value: 59, to: Date())
            debugPrint(datee!)
            
            //let startdate =  Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let startdate = Calendar.current.startOfDay(for: Date())
            let predicate = HKQuery.predicateForSamples(withStart: startdatee, end: endTime, options: .strictEndDate)
            var interval = DateComponents()
            interval.hour = 1
            
            let querryy = HKStatisticsCollectionQuery(quantityType: smaplequery, quantitySamplePredicate: predicate, options:[ .cumulativeSum], anchorDate: startdate, intervalComponents: interval)
            
            querryy.initialResultsHandler = {
                
                query, result, error in
                
                if result != nil{
                    
                    result?.enumerateStatistics(from: startdate
                                                , to: Date()) {(statistic, value) in
                        
                        if let count = statistic.sumQuantity()
                        {
                            
                            let val = count.doubleValue(for: HKUnit.count())
                            print("total step count \(val)" )
                           
                            
                            DispatchQueue.main.async {
                                
                                self.vil+=1
                                self.stepcount()
                                
                                //self.stepsLabel.text = String(val)
                            }
                            
                            
                        }
                    }
                }
            }
            healthStore.execute(querryy)
            
           // self.distancetravel()
             
             
            
        
    }
    */

    
    @objc func stepcount()
    {
        /*
            
        var arardate = [String]()
        arardate.append("2022-08-01 01:13:07")
        arardate.append("2022-08-01 02:13:07")
        arardate.append("2022-08-01 03:13:07")
        arardate.append("2022-08-01 04:13:07")
        arardate.append("2022-08-01 05:13:07")
        arardate.append("2022-08-01 06:13:07")
        arardate.append("2022-08-01 07:13:07")
        arardate.append("2022-08-01 08:13:07")
        arardate.append("2022-08-01 09:13:07")
        arardate.append("2022-08-01 10:13:07")
        arardate.append("2022-08-01 11:23:07")
        arardate.append("2022-08-01 12:33:07")
        arardate.append("2022-08-01 13:43:07")
        arardate.append("2022-08-01 14:53:07")
        arardate.append("2022-08-01 15:43:07")
        arardate.append("2022-08-01 16:03:07")
        arardate.append("2022-08-01 17:07:07")
        arardate.append("2022-08-01 18:08:07")
        arardate.append("2022-08-01 19:08:07")
        arardate.append("2022-08-01 20:08:07")
        arardate.append("2022-08-01 21:08:07")
        arardate.append("2022-08-01 22:08:07")
        arardate.append("2022-08-01 23:08:07")
        arardate.append("2022-08-01 23:15:07")
        arardate.append("2022-08-01 23:20:07")
        arardate.append("2022-08-01 23:22:07")
        arardate.append("2022-08-01 23:27:07")
        arardate.append("2022-08-01 23:28:07")
        arardate.append("2022-08-01 23:30:07")
        arardate.append("2022-08-01 23:32:07")
        arardate.append("2022-08-01 23:33:07")
        arardate.append("2022-08-01 23:34:07")
        arardate.append("2022-08-01 23:35:07")
        arardate.append("2022-08-01 23:36:07")
        arardate.append("2022-08-01 23:37:07")
        arardate.append("2022-08-01 23:38:07")
       */
        var vil : Int = 0
        
        
      
        if arrayStepDta == nil {
            arrayStepDta = [stepWatchData]()//Storing selected answer
            print(arrayStepDta!)

      /*  guard let smaplequery = HKObjectType.quantityType(forIdentifier:.stepCount) else
        {
            return
        }


            let date = Date() // current date or replace with a specific date
                   let calendar = Calendar.current

                   let endTime = calendar.date(bySettingHour: vil, minute: 59, second: 59, of: date)
                   let startdatee = calendar.date(bySettingHour: 00, minute: 00, second: 59, of: date)

                
                   let datee = calendar.date(byAdding: .minute, value: 59, to: Date())
                   debugPrint(datee!)
            
            
            
            debugPrint(startdatee)
            debugPrint(endTime)



      //  let startdate =  Calendar.current.date( byAdding: .hour, value: -1, to: Date())
        let startdate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startdatee, end: endTime, options: .strictEndDate)
        var interval = DateComponents()
        interval.hour = 1

        let querryy = HKStatisticsCollectionQuery(quantityType: smaplequery, quantitySamplePredicate: predicate, options:[ .cumulativeSum], anchorDate: startdate, intervalComponents: interval)

        querryy.initialResultsHandler = {

            query, result, error in

            if result != nil{

              //  debugPrint(arardate[vil])

                result?.enumerateStatistics(from: startdate
                                            , to: Date()) {(statistic, value) in


                    if let count = statistic.sumQuantity()
                    {

                    //    debugPrint(arardate[vil])

                        let val = count.doubleValue(for: HKUnit.count())
                      //  print("total step count \(val)" )

                        let formatter: DateFormatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateTime: String = formatter.string(from: Date())

                     //   debugPrint(dateTime)

                        self.StepData = stepWatchData(completedTime: "", created_date: "", device_cat: "watch", device_type:
                                                        "Apple watch", miles: "", steps: String(val), targetTime: "", type: "")
                        self.arrayStepDta?.append(self.StepData!)

                 //       vil+=1

//                        let trt = stepWatchData(completedTime: "", created_date: dateTime, device_cat: "watch", device_type:
//                                                    "Apple watch", miles: "", steps: String(val), targetTime: "", type: "")
//                        debugPrint(trt)
                        DispatchQueue.main.async {



                            //self.stepsLabel.text = String(val)
                        }


                    }
                }
            }

          
            
            iasdfg@123f (self.arrayStepDta?.count==0)
            {
                self.vil+=1
                self.stepcount()
            }*/
            
         
            
            guard let smaplequery = HKObjectType.quantityType(forIdentifier:.stepCount) else
            {
                return
            }
           // let startdate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            let startdate = Calendar.current.startOfDay(for: Date())
            let predicate = HKQuery.predicateForSamples(withStart: startdate, end: Date(), options: .strictEndDate)
            let shortDescipto = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending:true)
                
            let queryy = HKSampleQuery(sampleType: smaplequery, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [shortDescipto]) {(sample, results, error) in
                guard error == nil else
                {
                    return
                }
                
                
             //   var workouts: [HKWorkout] = []

                if let results = results {
                    for result in results {
                        
                        
                        
                      
                        let data = result as! HKQuantitySample
                        let unit = HKUnit (from: "count")
                        let latestStep = data.quantity.doubleValue(for: unit)
                        print("Latest step\(latestStep)")
                        
                        debugPrint(data.endDate)
                        debugPrint(data.device)
                        debugPrint(data.device?.value(forKey: "name"))
                        
                       
                        
                        var date = Date()
                        let formatter = DateFormatter()
                       // formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
                        formatter.timeZone = TimeZone(abbreviation: "UTC")
                        let myString = formatter.string(from: data.endDate)
                        let yourDate: Date? = formatter.date(from: myString)
                       // formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let updatedString = formatter.string(from: yourDate!)
                        print(updatedString)


                            // UTC change according to reuiremnt to fix backend issue



                        
                        debugPrint(self.arrDistance.count)
                        debugPrint([vil])
                        
                        if self.arrDistance.count==vil || vil>self.arrDistance.count
                        {
                            self.StepData = stepWatchData(completedTime: "", created_date: updatedString, device_cat: "watch", device_type:"Apple watch", miles: "0.00", steps: String(latestStep), targetTime: "", type: "")
                            self.arrayStepDta?.append(self.StepData!)
                               
                           vil+=1
                        }
                        else
                        {
                        
                        self.StepData = stepWatchData(completedTime: "", created_date: updatedString, device_cat: "watch", device_type:"Apple watch", miles: self.arrDistance[vil], steps: String(latestStep), targetTime: "", type: "")
                        self.arrayStepDta?.append(self.StepData!)
                        
                       vil+=1
                        }
                       
                    }
                    
             //       debugPrint(workouts)
                }
                else {
                    // No results were returned, check the error
                }
                
                debugPrint(self.arrayStepDta!)
            
            guard let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as? String else {

                return
            }

            guard let tokeen = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {

                return
            }

            let request = stepWatchRequest(results: self.arrayStepDta, user_id: userId)
         self.stepWatchViewModel.saveStepWatch(request: request, token: tokeen)
                
                self.arrayStepDta?.removeAll()
        }
            
            self.healthStore.execute(queryy)
       // self.distancetravel()
        }
        
        else
        {
            
                arrayStepDta = [stepWatchData]()//Storing selected answer
                print(arrayStepDta!)

          /*  guard let smaplequery = HKObjectType.quantityType(forIdentifier:.stepCount) else
            {
                return
            }


                let date = Date() // current date or replace with a specific date
                       let calendar = Calendar.current

                       let endTime = calendar.date(bySettingHour: vil, minute: 59, second: 59, of: date)
                       let startdatee = calendar.date(bySettingHour: 00, minute: 00, second: 59, of: date)

                    
                       let datee = calendar.date(byAdding: .minute, value: 59, to: Date())
                       debugPrint(datee!)
                
                
                
                debugPrint(startdatee)
                debugPrint(endTime)



          //  let startdate =  Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let startdate = Calendar.current.startOfDay(for: Date())
            let predicate = HKQuery.predicateForSamples(withStart: startdatee, end: endTime, options: .strictEndDate)
            var interval = DateComponents()
            interval.hour = 1

            let querryy = HKStatisticsCollectionQuery(quantityType: smaplequery, quantitySamplePredicate: predicate, options:[ .cumulativeSum], anchorDate: startdate, intervalComponents: interval)

            querryy.initialResultsHandler = {

                query, result, error in

                if result != nil{

                  //  debugPrint(arardate[vil])

                    result?.enumerateStatistics(from: startdate
                                                , to: Date()) {(statistic, value) in


                        if let count = statistic.sumQuantity()
                        {

                        //    debugPrint(arardate[vil])

                            let val = count.doubleValue(for: HKUnit.count())
                          //  print("total step count \(val)" )

                            let formatter: DateFormatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let dateTime: String = formatter.string(from: Date())

                         //   debugPrint(dateTime)

                            self.StepData = stepWatchData(completedTime: "", created_date: "", device_cat: "watch", device_type:
                                                            "Apple watch", miles: "", steps: String(val), targetTime: "", type: "")
                            self.arrayStepDta?.append(self.StepData!)

                     //       vil+=1

    //                        let trt = stepWatchData(completedTime: "", created_date: dateTime, device_cat: "watch", device_type:
    //                                                    "Apple watch", miles: "", steps: String(val), targetTime: "", type: "")
    //                        debugPrint(trt)
                            DispatchQueue.main.async {



                                //self.stepsLabel.text = String(val)
                            }


                        }
                    }
                }

              
                
                if (self.arrayStepDta?.count==0)
                {
                    self.vil+=1
                    self.stepcount()
                }*/
                
             
                
                guard let smaplequery = HKObjectType.quantityType(forIdentifier:.stepCount) else
                {
                    return
                }
               // let startdate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                let startdate = Calendar.current.startOfDay(for: Date())
                let predicate = HKQuery.predicateForSamples(withStart: startdate, end: Date(), options: .strictEndDate)
                let shortDescipto = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending:true)
                    
                let queryy = HKSampleQuery(sampleType: smaplequery, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [shortDescipto]) {(sample, results, error) in
                    guard error == nil else
                    {
                        return
                    }
                    
                    
                 //   var workouts: [HKWorkout] = []

                    if let results = results {
                        for result in results {
                            
                            
                            
                          
                            let data = result as! HKQuantitySample
                            let unit = HKUnit (from: "count")
                            let latestStep = data.quantity.doubleValue(for: unit)
                            print("Latest step\(latestStep)")
                            
                            debugPrint(data.endDate)
                            
                            var date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
                            formatter.timeZone = TimeZone(abbreviation: "UTC")
                            let myString = formatter.string(from: data.endDate)
                            let yourDate: Date? = formatter.date(from: myString)
                           // formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let updatedString = formatter.string(from: yourDate!)
                            print(updatedString)


                            


                            
                            debugPrint(self.arrDistance.count)
                            debugPrint([vil])
                            
                            if self.arrDistance.count==vil || vil>self.arrDistance.count
                            {
                                self.StepData = stepWatchData(completedTime: "", created_date: updatedString, device_cat: "watch", device_type:"Apple watch", miles: "0.00", steps: String(latestStep), targetTime: "", type: "")
                                self.arrayStepDta?.append(self.StepData!)
                                
                               vil+=1
                            }
                            else
                            {
                                
                            
                            self.StepData = stepWatchData(completedTime: "", created_date: updatedString, device_cat: "watch", device_type:"Apple watch", miles: self.arrDistance[vil], steps: String(latestStep), targetTime: "", type: "")
                            self.arrayStepDta?.append(self.StepData!)
                            
                           vil+=1
                            }
                           
                        }
                        
                 //       debugPrint(workouts)
                    }
                    else {
                        // No results were returned, check the error
                    }
                    
                    debugPrint(self.arrayStepDta!)
                
                guard let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as? String else {

                    return
                }

                guard let tokeen = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {

                    return
                }

                let request = stepWatchRequest(results: self.arrayStepDta, user_id: userId)
             self.stepWatchViewModel.saveStepWatch(request: request, token: tokeen)
                    
                    self.arrayStepDta?.removeAll()
            }
                
                self.healthStore.execute(queryy)
           // self.distancetravel()
            self.WatchHeartrate()
            }
            
        
        
     
    }


    
    func WatchHeartrate ()
    {

             guard let smaplequery = HKObjectType.quantityType(forIdentifier:.heartRate) else
             {
                 return
             }
             let startdate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
             let predicate = HKQuery.predicateForSamples(withStart: startdate, end: Date(), options: .strictEndDate)
             let shortDescipto = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending:false)

             let queryy = HKSampleQuery(sampleType: smaplequery, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [shortDescipto]) {(sample, result, error) in
                 guard error == nil else
                 {
                     return
                 }
                
                 if result?.isEmpty == true
                 {
                     debugPrint("h")
                     return
                 }
                 else
                 {
                     

                 let data = result?[0] as! HKQuantitySample
               //  print(result!)
                 let unit = HKUnit (from: "count/min")
                 let latestHR = data.quantity.doubleValue(for: unit)
                 print("Latest HR\(latestHR) BPM")

                 let dateformatter = DateFormatter()
                 dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                 dateformatter.timeZone = TimeZone(abbreviation: "UTC")
                 let startdatee = dateformatter.string(from: data.startDate)
                // let enddatee = dateformatter.string(from: data.enddate)
                 print("StartDate \(startdatee)")

                 dateformatter.timeZone = TimeZone(abbreviation: "UTC")
                 if let dt = dateformatter.date(from: startdatee) {
                     dateformatter.timeZone = TimeZone.current
                     dateformatter.dateFormat = "yyyy-MM-dd h:mm a"
                    // convertedLocalTime = dateformatter.string(from: dt)
                     print("convertedLocalTime--",dateformatter.string(from: dt))
                     } else {
                         print("There was an error decoding the string")
                     }





                 guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    // self.view.stopActivityIndicator()
                     return
                 }
                 let request = HeartRateWatchStatRequest(min: "70", max: "170", avg: String(latestHR), device_cat: "watch", device_type: "apple watch", add_date: startdatee)
                 DispatchQueue.main.async {

                   //  self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                 }


                 //heartViewModel.postWatchHeartRateData(: request, token: token)
                 self.heartViewModel.postWatchHeartRateData(heartDataRequest: request, token: token)

             }
             }
             
             self.healthStore.execute(queryy)

             
    }

    func distancetravel()
    {
       
        
        /*let date = Date() // current date or replace with a specific date
               let calendar = Calendar.current

               let endTime = calendar.date(bySettingHour: 13, minute: 59, second: 59, of: date)
               let startdatee = calendar.date(bySettingHour: 00, minute: 00, second: 59, of: date)

        
        guard let smaplequery = HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning) else
        {
            return
        }
      //  let startdate =  Calendar.current.date( byAdding: .hour, value: -1, to: Date())
        let startdate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startdatee, end: endTime, options: .strictEndDate)
        var interval = DateComponents()
        interval.hour = 1
        
        let querryy = HKStatisticsCollectionQuery(quantityType: smaplequery, quantitySamplePredicate: predicate, options:[ .cumulativeSum], anchorDate: startdate, intervalComponents: interval)
        
        querryy.initialResultsHandler = {
            
            query, result, error in
            
            if result != nil{
                
                result?.enumerateStatistics(from: startdate
                                            , to: Date()) {(statistic, value) in
                    
                    if let count = statistic.sumQuantity()
                    {
                        
                        let val = count.doubleValue(for: HKUnit.mile())
                        let miles = String(format: "%.2f miles", val)
                        let KMS = String(format: "%.2f KMS", (Double(val) * 1.609))
                        print("total diatance travel today\(miles) -\(KMS)" )
                        
                        DispatchQueue.main.async {
                            
                          //  self.DistanceLabel.text = String(KMS)
                        }
                        
                        
                    }
                }
            }
        }
        healthStore.execute(querryy)*/
        
        
            guard let smaplequery = HKObjectType.quantityType(forIdentifier:.distanceWalkingRunning) else
            {
                return
            }
           // let startdate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            let startdate = Calendar.current.startOfDay(for: Date())
            let predicate = HKQuery.predicateForSamples(withStart: startdate, end: Date(), options: .strictEndDate)
            let shortDescipto = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending:true)
                
            let queryy = HKSampleQuery(sampleType: smaplequery, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [shortDescipto]) {(sample, results, error) in
                guard error == nil else
                {
                    return
                }
                self.arrDistance.removeAll()
                
             //   var workouts: [HKWorkout] = []

                if let results = results {
                    for result in results {
                        
                        let data = result as! HKQuantitySample
                        let unit = HKUnit (from: "m")
                        let distance = data.quantity.doubleValue(for: unit)
                       // print("Latest distance\(distance)")
                        
                        let x = 0.000621371192
                        let y = Double((distance * x))
                      //  print(y)
                        
                        self.arrDistance.append(String(format: "%.2f", y))
                       // debugPrint(self.arrDistance )
                        
                      /*
                        let data = result as! HKQuantitySample
                        let unit = HKUnit (from: "count")
                        let latestStep = data.quantity.doubleValue(for: unit)
                        print("Latest step\(latestStep)")
                        
                        debugPrint(data.endDate)
                        */
                       
                       
                    }
                    debugPrint(self.arrDistance )
                    self.stepcount()
                    
             //       debugPrint(workouts)
                }
                else {
                    // No results were returned, check the error
                }
    
            }
      
            self.healthStore.execute(queryy)
        // self.stepcount()
        
    }
    
    private func calculateGPSDistance(startLocation: CLLocation, endLocation: CLLocation) -> Double {
        //Measuring my distance to my buddy's (in meters)
        let distance = startLocation.distance(from: endLocation)

        //Display the result in meters
        print(String(format: "The distance to my buddy is %.01fmeters", distance))
        
        return distance
    }
    
    private func updateStepsData(totalStep: Int, distance: Double, gpsDistance: Double) {
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            debugPrint("User logged out. No token found")
            return
        }
        //New updated - pk04feb2022
        if totalStep > 0 {
            
            let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                    print(status)
    
                    if status==true
            {
//                        guard let userId = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserId) as? String else {
//
//                            return
//                        }
//                        let date = Date()
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        let myString = formatter.string(from: date)
//                        let yourDate: Date? = formatter.date(from: myString)
//                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        let updatedString = formatter.string(from: yourDate!)
//                        print(updatedString)
//
//                        if arrayStepDta == nil {
//                            arrayStepDta = [stepWatchData]()//Storing selected answer
//                            print(arrayStepDta!)
//
//                        self.StepData = stepWatchData(completedTime: "", created_date: updatedString, device_cat: "watch", device_type:"Apple watch", miles: "\(distance)", steps: "\(totalStep)", targetTime: "", type: "")
//                        self.arrayStepDta?.append(self.StepData!)
//                            print(arrayStepDta!)
//
//                        let request = stepWatchRequest(results: self.arrayStepDta, user_id: userId)
//                     self.stepWatchViewModel.saveStepWatch(request: request, token: token)
                        
                        let request = BGStepUpdateRequest(targetTime: "", completedTime: "", type: "walk", steps: "0", miles: "0", gpsDistance: "0",device_cat: "mobile",device_type:"iPhone")
                        self.bgStepViewModel.postBGStepUpdate(BGStepUpdateRequest: request, token: token)
                            
                       // }
            }
            else
            {
            
            //targetTime & completedTime will be blank in here. But send value when from ExerciseStartVC
            let request = BGStepUpdateRequest(targetTime: "", completedTime: "", type: "walk", steps: "\(totalStep)", miles: "\(distance)", gpsDistance: "\(gpsDistance)",device_cat: "mobile",device_type:"iPhone")
            self.bgStepViewModel.postBGStepUpdate(BGStepUpdateRequest: request, token: token)
                
            }
            
            //Reset here
            self.steps = 0
            self.storeSteps = 0
            self.distance = 0.0
            self.storeDistance = 0.0
        }
        
//        if totalStep > 0 {
//            //targetTime & completedTime will be blank in here. But send value when from ExerciseStartVC
//            let request = BGStepUpdateRequest(targetTime: "", completedTime: "", type: "walk", steps: "\(totalStep)", miles: "\(distance)")
//            self.bgStepViewModel.postBGStepUpdate(BGStepUpdateRequest: request, token: token)
//            //Reset here
//            self.steps = 0
////            self.totalSteps = storeSteps
//            self.distance = 0.0
////            self.totalDistance = 0.0
//            globalStepCounter = 0
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
//            print("Second Location----->",lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
            endLat = lastLocation.coordinate.latitude
            endLong = lastLocation.coordinate.longitude
        }
    }
}

//MARK: --------------FCM Func--------------
extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FIREBASE TOKEN : \(String(describing: fcmToken))")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        UserDefaults.standard.set(fcmToken, forKey: ConstantUserDefaultTag.udFCMToken)
    }
    // [END refresh_token]
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        //when app is foreground
        print("willPresent---------\(userInfo)")
        
        DecodeNotification(userInfo: userInfo)
        NotificationCenter.default.post(name: NSNotification.Name(ConstantLocalNotification.updateNotificationList), object: nil)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound, .badge]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        //when user tap notification
        print("didReceive---------\(userInfo)")
        
        let keyWindows = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first

        let VC = keyWindows?.rootViewController

        let vc = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        if let topVC = UIApplication.getTopViewController(base: VC) {
            topVC.navigationController?.pushViewController(vc, animated: false)
        }
        
        DecodeNotification(userInfo: userInfo)
        
        completionHandler()
    }
    
    fileprivate func DecodeNotification(userInfo: [AnyHashable : Any]) {
        // Get data decoded
        guard let push = try? Push(decoding: userInfo) else { return }
        
        print("App Delegate NOTIFICATION DATA---\(push.aps.badge)")
        
        //Store badge count and post local notification to update
        UserDefaults.standard.set(push.aps.badge, forKey: ConstantUserDefaultTag.udNotificationBadge)
        NotificationCenter.default.post(name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
}
// [END ios_10_message_handling]

public extension UIApplication {
//    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    class func getTopViewController(base: UIViewController?) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}


//Put this code inside appdelegate main class
//    ////////////////////////////////////
//    //MARK: - Background Task
//    ///////////////////////////////////
//
//    func handleAppRefreshTask(task: BGAppRefreshTask) {
//        task.expirationHandler = {
//            task.setTaskCompleted(success: true)
//            URLSession.shared.invalidateAndCancel()
//        }
//
////        setHealthKit()
//
//        HealthKitAssistant.shared.getHealthKitPermission { (response) in
//            guard let stepsdata = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
//
//            HealthKitAssistant.shared.getMostRecentStep(for: stepsdata) { (steps , stepsData) in
//                DispatchQueue.main.async {
//                    print(steps)
//                    self.step = "\(steps)"
//                    HealthKitAssistant.shared.getHealthKitPermission { (response) in
//                        guard let stepsDistance = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
//
//                        HealthKitAssistant.shared.activityDistance(for: stepsDistance) { (distance, arrayDistance, error) in
//                            if error == nil {
//                                let url = URL(string: Common.WebserviceAPI.postBGStepUpdate)!
//                                let httpUtility = HttpUtility()
//                                do {
//                                    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//                //                        self.view.stopActivityIndicator()
//                                        return
//                                    }
//                                    let request = BGStepUpdateRequest(type: "walk", steps: self.step, miles: "\(distance)")
//                                    let postBody = try JSONEncoder().encode(request)
//                                    httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: BGStepUpdateResponse.self) { (BGStepApiResponse, error) in
//                                        DispatchQueue.main.async {
//                                            if (error == nil) {
//                                                debugPrint(BGStepApiResponse as Any)
//                                            } else {
//                                                debugPrint(error!)
//                                            }
//                                        }
//                                        task.setTaskCompleted(success: true)
//                                    }
//                                } catch let error {
//                                    debugPrint(error.localizedDescription)
//                                }
//                                DispatchQueue.main.async {
//                                    debugPrint("---->",distance)
//                                }
//                            }
//                        }
//
//                    }
//                }
//            }
//        }
//
//
//
////          PokeManager.pokemon(id: randomPoke) { (pokemon) in
////            NotificationCenter.default.post(name: .newPokemonFetched,
////                                            object: self,
////                                            userInfo: ["pokemon": pokemon])
////            task.setTaskCompleted(success: true)
////          }
//
//        scheduleBackgroundStepUpdate()
//    }
//
//    func scheduleBackgroundStepUpdate() {
//        let bgTask = BGAppRefreshTaskRequest(identifier: "com.luvo.fetchSteps")
//        bgTask.earliestBeginDate = Date(timeIntervalSinceNow: 60) // App Refresh after 60 minute.
//        do {
//          try BGTaskScheduler.shared.submit(bgTask)
//        } catch {
//          print("Unable to submit task: \(error.localizedDescription)")
//        }
//    }
    
    //---------------------------------------------
    
//    ////////////////////////////////////
//    //MARK: - Healthkit step load
//    ////////////////////////////////////
//
//    func setHealthKit() {
//        //MARK: Get Healthkit permission
//        HealthKitAssistant.shared.getHealthKitPermission { (response) in
//            self.loadMostRecentSteps()
////            self.loadStepDistance()
//        }
//    }
//
//    func loadMostRecentSteps()  {
//        guard let stepsdata = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
//
//        HealthKitAssistant.shared.getMostRecentStep(for: stepsdata) { (steps , stepsData) in
//            DispatchQueue.main.async {
//                print(steps)
////                self.arrStepCountData = stepsData
//                self.step = "\(steps)"
//                HealthKitAssistant.shared.getHealthKitPermission { (response) in
//                    self.loadStepDistance()
//                }
//            }
//        }
//    }
//
//    func loadStepDistance()  {
//        guard let stepsDistance = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
//
//        HealthKitAssistant.shared.activityDistance(for: stepsDistance) { (distance, arrayDistance, error) in
//            if error == nil {
//                //api call here
//                let connectionStatus = ConnectionManager.shared.hasConnectivity()
//                if (connectionStatus == false) {
////                    DispatchQueue.main.async {
////                        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
////                        return
////                    }
//                } else {
//                    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
////                        self.view.stopActivityIndicator()
//                        return
//                    }
//                    let request = BGStepUpdateRequest(type: "walk", steps: self.step, miles: "\(distance)")
////                    self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
//                    self.bgStepViewModel.postBGStepUpdate(BGStepUpdateRequest: request, token: token)
//                }
////                var arrComposed = [StepCombined]()
//
////                for i in 0...self.arrStepCountData.count - 1 {
////                    arrComposed.append(StepCombined(steps: self.arrStepCountData[i]["steps"] as? String, distance: arrayDistance[i]["distance"] as? String, time: self.arrStepCountData[i]["enddate"] as? String))
////                }
//
//                DispatchQueue.main.async {
//                    debugPrint("---->",distance)
////                    debugPrint("---->",arrComposed)
//                }
//            }
//        }
//    }
