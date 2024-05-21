//
//  UserProfile.swift
//  HealthApp
//
//  Created by SOTSYS036 on 01/03/19.
//  Copyright © 2019 SOTSYS036. All rights reserved.
//

import Foundation
import HealthKit

//////////////////
//error enum
//////////////////

private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}


class HealthKitAssistant {
    
    ///////////////////////////
    //Shared Variable
    ///////////////////////////
    
    static let shared = HealthKitAssistant()
    
    
    ///////////////////////////
    //Healthkit store object
    ///////////////////////////
    
    let healthKitStore = HKHealthStore()
    
    ////////////////////////////////////
    //MARK: Permission block
    ////////////////////////////////////
    func getHealthKitPermission(completion: @escaping (Bool) -> Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        
        let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let stepsDistance = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        
        self.healthKitStore.requestAuthorization(toShare: [], read: [stepsCount, stepsDistance]) { (success, error) in
            if success {
                print("Permission accept.")
                completion(true)
                
            } else {
                if error != nil {
                    print(error ?? "")
                }
                DispatchQueue.main.async {
                    completion(false)
                }
                print("Permission denied.")
            }
        }
    }
    
    
    
    //////////////////////////////////////////////////////
    //MARK: - Get Recent step Data
    //////////////////////////////////////////////////////
    
    func getMostRecentStep(for sampleType: HKQuantityType, completion: @escaping (_ stepRetrieved: Int, _ stepAll : [[String : Any]]) -> Void) {
        
        //   Get the start of the day
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        //        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        //        let newDate = cal.startOfDay(for: now)
        
        // Use HKQuery to load the most recent samples.
        let mostRecentPredicate =  HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)  //withStart: Date.distantPast
        
        var interval = DateComponents()
        interval.hour = 1
        
        let stepQuery = HKStatisticsCollectionQuery(quantityType: sampleType,
                                                    quantitySamplePredicate: mostRecentPredicate,
                                                    options: .cumulativeSum,
                                                    anchorDate: startOfDay, //Date.distantPast,
                                                    intervalComponents: interval)
        
        stepQuery.initialResultsHandler = { query, results, error in
            
            if error != nil {
                //  Something went Wrong
                return
            }
            if let myResults = results {
                
                var stepsData : [[String:Any]] = [[:]]
                var steps : Int = Int()
                stepsData.removeAll()
                
                myResults.enumerateStatistics(from: startOfDay, to: now) { statistics, stop in
                    
                    //Take Local Variable
                    if let quantity = statistics.sumQuantity() {
                        
                        //                        let dateFormatter = DateFormatter()
                        //                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                        //                        dateFormatter.timeZone = TimeZone.current
                        
                        //                        var tempDic : [String : String]?
                        //                        let endDate : Date = statistics.endDate
                        
                        steps = Int(quantity.doubleValue(for: HKUnit.count()))
                        
                        let tempDic = [
                            "enddate" : "\(self.dateFormat().string(from: statistics.endDate))",
                            "steps"   : "\(steps)"
                        ] as [String : Any]
                        stepsData.append(tempDic)
                    }
                }
                completion(steps, stepsData.reversed())
            }
        }
        HKHealthStore().execute(stepQuery)
    }
    
    func activityDistance(for sampleType: HKQuantityType, completion: @escaping (_ distanceRetrieved: Double, _ distanceAll : [[String : Any]], NSError?) -> ()) {
        //   Get the start of the day
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        var interval = DateComponents()
        interval.hour = 1
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        let query = HKStatisticsCollectionQuery(quantityType: sampleType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startOfDay,
                                                intervalComponents:interval)
        
        query.initialResultsHandler = { query, results, error in
            if let myResults = results {
                var distanceArray: [[String : Any]] = [[:]]
                var distance : Double = Double()
                myResults.enumerateStatistics(from: startOfDay, to: now) { statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        distance = quantity.doubleValue(for: HKUnit.mile())
                        
                        let ret =  [
                            "distance": "\(distance)",
                            "endDate": "\(self.dateFormat().string(from: statistics.endDate))"
                        ] as [String : Any]
                        distanceArray.append(ret)
                    }
                }
                completion(distance, distanceArray.reversed(), error as NSError?)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func dateFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
        
        return dateFormatter
    }
}
