//
//  ExerciseStartViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 10/11/21.
//
import HealthKit
import UIKit
import CoreMotion
import CoreLocation

//var globalStepCounter = 0   //Global step count for deduction in appDelegate step count so that same double data don't get save

class ExerciseStartViewController: UIViewController {
  
    
    
    

    
    var stepWatchViewModel = StepWatchViewModel()
    var vil : Int = 0
    var arrDistance = [String]()
    
    var arrayStepDta: [stepWatchData]?
    var StepData: stepWatchData?
    
    
    var healthStore = HKHealthStore()
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var imgStepTrackerBackground: UIImageView!
    @IBOutlet var imgRipple: UIImageView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var lblTotalSteps: UILabel!
    @IBOutlet var lblCurrentSteps: UILabel!
    @IBOutlet var lblGoalSteps: UILabel!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var btnPause: UIButton!
    
    var exerciseFinishRequest: ExerciseFinishRequest?
    private var countdownTimer: Timer?
    private var second: Int = 0
    private var totalStep = 0
    private var totalDistance = 0.0
    private var totalDistancePause = 0.0
//    private var completedTime = 0
    var stepGoal: String?
    var counter=0
    var isPause: String?
    var exerciseViewModel = ExerciseViewModel()
    //var stepWatchModel = StepWatchViewModel()
    
    var motionActivityManager = CMMotionActivityManager()
    var pedometer = CMPedometer()
    var locationManager:CLLocationManager?
    var startLat, startLong, endLat, endLong: Double?
    var a: Int?
    var b: Int?
    var result: Int?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        exerciseViewModel.stepFinishDelegate = self
        stepWatchViewModel.StepWatchdelegate = self
        
        
        setupGUI()
        setupData()
        
        debugPrint(exerciseFinishRequest)
        
        //Stop background step tracking
        (UIApplication.shared.delegate as? AppDelegate)?.stopTracking()
        
        setupLocationManager()
        setupCMActivity()
        
        startTracking()
      //  startPedometer()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPause="NO"
        startPedometer()
        
        UserDefaults.standard.set(false, forKey: "isPause")
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(ExerciseStartViewController.setupNotificationBadge),
//                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
//                                               object: nil)
//
//        setupNotificationBadge()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        tabBarController?.tabBar.isHidden = false
        
        locationManager?.stopUpdatingLocation()
        pedometer.stopUpdates()
        countdownTimer?.invalidate()
        motionActivityManager.stopActivityUpdates()
        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
        
        //Stop background step tracking
        (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
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
    //-----------------------------
    
    func setupGUI() {        
        imgRipple.tintColor = UIColor.lightGray
        imgStepTrackerBackground.tintColor = UIColor.colorSetup()
        lblTime.textColor = UIColor.colorSetup()
        lblTotalSteps.textColor = UIColor.colorSetup()
        btnStop.setTitleColor(UIColor.colorSetup(), for: UIControl.State.normal)
        btnPause.setTitleColor(UIColor.colorSetup(), for: UIControl.State.normal)
    }
    
    func setupData() {
//        if let step = exerciseFinishRequest?.targetSteps {
//            lblGoalSteps.text = "/\(step)"
//        }
        if let step = stepGoal {
            lblGoalSteps.text = "/\(step)"
        }
    }
    
    //MARK: - Timer-------------------------
    func startTimer() {
        if let sec = exerciseFinishRequest?.targetTime {
            second = Int(sec)! * 60
        }
        countdownTimer?.invalidate() //cancels it if already running
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        self.lblTimer.text = self.timeFormatted(second) // will show timer
        if second != 0 {
            second -= 1  // decrease counter timer
        } else {
//            if let timer = self.countdownTimer {
//                timer.invalidate()
//                self.countdownTimer = nil
//            }
//            self.completedTime = second
            stopTracking()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    //-----------------------
    @IBAction func btnPause(_ sender: Any) {
        print(counter)
        if (counter==0)
        {
            btnPause.setTitle("RESUME", for:.normal)
        print("working")
            isPause="YES"
            UserDefaults.standard.set(true, forKey: "isPause")
           
        if let timer = self.countdownTimer {
            timer.invalidate()
            self.countdownTimer = nil
            
            counter=1
            
            self.pedometer.stopUpdates()
            
           
        }
           
        }
        
       else if (counter==1)
      {
           UserDefaults.standard.set(false, forKey: "isPause")
           countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
           UserDefaults.standard.set(false, forKey: "isPause")
           isPause="NO"
           rstartPedo()
            btnPause.setTitle("PAUSE", for:.normal)
            counter=0
            print(counter)
          
           
        }
       
    }
    //MARK: Button Func---------------
    @IBAction func btnStop(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        
        openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle, message: "Do you want to finish the exercise?", alertStyle: .alert, actionTitles: ["OK", "Cancel"], actionStyles: [.default, .default], actions: [
            { _ in
                print("OK")
                self.locationManager?.stopUpdatingLocation()
                self.pedometer.stopUpdates()
                if let timer = self.countdownTimer {
                    timer.invalidate()
                    self.countdownTimer = nil
                }
                self.stepFinishUpdate()
            },
            { _ in
                print("Cancel")
            }])
    }
    
//    //MARK: -----Notification Setup
//    @objc func setupNotificationBadge() {
//        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }
//        
//        if badgeCount != 0 {
//            viewNotificationCount.isHidden = false
//            lblNotificationLabel.text = "\(badgeCount)"
//        } else {
//            viewNotificationCount.isHidden = true
//            lblNotificationLabel.text = "0"
//        }
//        print("BADGE COUNT-----\(badgeCount)")
//    }
}

extension ExerciseStartViewController: CLLocationManagerDelegate {
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
    
    //Call this to start tracking
    func startTracking() {
        locationManager?.startUpdatingLocation()
       
//        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    //Call this to stop tracking
    func stopTracking(){
        locationManager?.stopUpdatingLocation()
        pedometer.stopUpdates()
        
        if let timer = self.countdownTimer {
            timer.invalidate()
            self.countdownTimer = nil
        }
        openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle, message: "Hurray! Exercise time is completed", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [
            { _ in
                print("OK")
                self.stepFinishUpdate()
            }])
    }
    
    func stepFinishUpdate() {
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
            if totalStep > 0 {
//
                
                let status = UserDefaults.standard.bool(forKey: "isFromWatch")
                       
                        
                        if status==true
                {
                            
                            
                            print(status)
                            self.distancetravel()
                        
                }
                else{
                
                var gpsDistance = 0.00
                if let startLat = startLat, let startLong = startLong, let endLat = endLat, let endLong = endLong {
                    gpsDistance = calculateGPSDistance(startLocation: CLLocation(latitude: startLat, longitude: startLong), endLocation: CLLocation(latitude: endLat, longitude: endLong))
                }
                
                let request = ExerciseFinishRequest(targetTime: exerciseFinishRequest?.targetTime,
                                                    completedTime: exerciseFinishRequest?.targetTime,
                                                    type: exerciseFinishRequest?.type,
                                                    steps: "\(totalStep)",
                                                    miles: "\(totalDistance)",
                                                    add_date: formatCurrentDate(date: Date()),
                                                    gpsDistance: "\(gpsDistance)", device_cat: "mobile")
                        
                print(request)
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                exerciseViewModel.postStepFinishUpdate(stepUpdateRequest: request, token: token)
                    
                }
            } else {
                openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle, message: "Oops! No exercise done", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [
                    { _ in
                        print("OK")
                        self.navigationController?.popViewController(animated: true)
                    }])
            }
        }
    }
    
    
    func distancetravel()
    {
        self.arrDistance.removeAll()
        
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
                
                
             //   var workouts: [HKWorkout] = []

                if let results = results {
                    for result in results {
                        
                        let data = result as! HKQuantitySample
                        let unit = HKUnit (from: "m")
                        let distance = data.quantity.doubleValue(for: unit)
                        print("Latest distance\(distance)")
                        
                        let x = 0.000621371192
                        let y = Double((distance * x))
                        print(y)
                        
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
        
    }
    
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
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let myString = formatter.string(from: data.endDate)
                        let yourDate: Date? = formatter.date(from: myString)
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let myString = formatter.string(from: data.endDate)
                            let yourDate: Date? = formatter.date(from: myString)
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let updatedString = formatter.string(from: yourDate!)
                            print(updatedString)
                            
                            debugPrint(self.arrDistance)
                            
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
                           
                            
                         //  vil+=1
                           
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
            
        
        
     
    }
    
    private func calculateGPSDistance(startLocation: CLLocation, endLocation: CLLocation) -> Double {
        //Measuring my distance to my buddy's (in meters)
        let distance = startLocation.distance(from: endLocation)

        //Display the result in meters
        print(String(format: "The distance to my buddy is %.01fmeters", distance))
        
        return distance
    }
    
    fileprivate func formatCurrentDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let formatDate = dateFormatter.string(from: date)
        debugPrint("Format Date--->",formatDate)
        return formatDate
    }
    
    //MARK: - Pedometer Func--------------------
    func setupCMActivity() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (data) in
                DispatchQueue.main.async {
                    if let activity = data {
                        if activity.running == true {
                            print("Running")
                        }else if activity.walking == true {
                            print("Walking")
                        }else if activity.automotive == true {
                            print("Automative")
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
                            print("Number Of Steps == \(response.numberOfSteps)")
                            print("Distance covered in meters = \(String(describing: response.distance))")
                            
    //                        if let step = self.exerciseFinishRequest?.targetSteps {
    //                            self.lblCurrentSteps.text = "\(response.numberOfSteps)"
    //                        }
                         
                            self.lblCurrentSteps.text = "\(response.numberOfSteps)"
                            self.a = Int(self.lblCurrentSteps.text!) ?? 0
                            self.totalStep = response.numberOfSteps.intValue
                            if let distance = response.distance {
                                self.totalDistance = distance.doubleValue * 0.0006213712 //Converted to miles
                                self.totalDistancePause = self.totalDistance
                            }
                            
                            
                            
    //                        if let targetStep = self.exerciseFinishRequest?.targetSteps {
    //                            if response.numberOfSteps.intValue >= Int(targetStep)! {
    //                                self.completedTime = self.second
    //                            }
    //                        }
                        }
                        
                        
                    }
                }
        }
       

        }
    
    
    func rstartPedo(){
        
        self.pedometer.startUpdates(from: Date()) { (data, error) in
            if error == nil {
                if let response = data {
                    DispatchQueue.main.async {
                    
                    print("Number Of Steps == \(response.numberOfSteps)")
                    print("Distance covered in meters = \(String(describing: response.distance))")
                        
                       
                        
                       // self.lblCurrentSteps.text = "\(response.numberOfSteps)"
                        self.b = Int(self.lblCurrentSteps.text!) ?? 0
                        
                        //print(self.a ?? 0 + self.b ?? 0)
                        
                        print(self.b)
                        
                        var new = (Int(self.a ?? 0)) + (Int(self.b ?? 0))
                        print(new)
                        self.lblCurrentSteps.text = (String(new))
                        
                     
                        self.totalStep = response.numberOfSteps.intValue
                       
                        
                        if let distance = response.distance {
                            self.totalDistance = distance.doubleValue * 0.0006213712
                            print(self.totalDistance)
                            self.totalDistance = self.totalDistance + self.totalDistancePause
                            //Converted to miles
                            print(self.totalDistance)
                            print(self.totalDistancePause)
                            
                            print(self.totalDistance + self.totalDistancePause)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
//            print("Second Location----->",lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
            endLat = lastLocation.coordinate.latitude
            endLong = lastLocation.coordinate.longitude
        }
    }
}
extension ExerciseStartViewController: StepWatchViewModelDelegate
{
    func didReceiveStepWatchResponse(stepWatchResponse: stepWatchRespone?) {
       self.view.stopActivityIndicator()

        if(stepWatchResponse?.status != nil && stepWatchResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            //            dump(stepFinishDataResponse)
//
////            //Reset Global Steps Counter for Appdelegate
////            globalStepCounter = 0
            ///
        

            openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                    message: "Your step data successfully updated.",
                                    alertStyle: .alert,
                                    actionTitles: ["OK"],
                                   actionStyles: [.default],
                                    actions: [
                                        { _ in

                                            let exerciseStatVC = ConstantStoryboard.exerciseStoryboard.instantiateViewController(withIdentifier: "ExerciseStatsViewController") as! ExerciseStatsViewController
                                            exerciseStatVC.stepsGoal = self.stepGoal
                                            self.navigationController?.pushViewController(exerciseStatVC, animated: true)
                                        }
                                    ])
    }
    }
    
    func didReceiveStepWatchError(statusCode: String?) {
        
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
        
    }
    
    
    
}


extension ExerciseStartViewController: StepFinishDelegate {
    func didReceiveStepFinishDataResponse(stepFinishDataResponse: ExerciseFinishResponse?) {
        self.view.stopActivityIndicator()
        
        if(stepFinishDataResponse?.status != nil && stepFinishDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
            //            dump(stepFinishDataResponse)
            
//            //Reset Global Steps Counter for Appdelegate
//            globalStepCounter = 0
            
            openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                    message: stepFinishDataResponse?.message ?? "Success",
                                    alertStyle: .alert,
                                    actionTitles: ["OK"],
                                    actionStyles: [.default],
                                    actions: [
                                        { _ in
                                            
                                            let exerciseStatVC = ConstantStoryboard.exerciseStoryboard.instantiateViewController(withIdentifier: "ExerciseStatsViewController") as! ExerciseStatsViewController
                                            exerciseStatVC.stepsGoal = self.stepGoal
                                            self.navigationController?.pushViewController(exerciseStatVC, animated: true)
                                        }
                                    ])
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: stepFinishDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveStepFinishDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
        
//        //Reset Global Steps Counter for Appdelegate
//        globalStepCounter = 0
    }
    
    
}
