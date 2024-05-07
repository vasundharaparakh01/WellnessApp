//
//  SceneDelegate.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 01/09/21.
//

import UIKit
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: scene)
        
//        let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
//        let rootNC = UINavigationController(rootViewController: initialViewController)
//        rootNC.isNavigationBarHidden = true
//        self.window?.rootViewController = rootNC
//        self.window?.makeKeyAndVisible()
        
//        let initialViewController = ConstantStoryboard.exerciseStoryboard.instantiateViewController(withIdentifier: "ExerciseStatsViewController") as! ExerciseStatsViewController
//        let rootNC = UINavigationController(rootViewController: initialViewController)
//        rootNC.isNavigationBarHidden = true
//        self.window?.rootViewController = rootNC
//        self.window?.makeKeyAndVisible()
        
//
//                        let status = UserDefaults.standard.bool(forKey: "isFromWatch")
//                                print(status)
//
//                                if status==true
//                        {
//
//                                    ///Steps Tracking
//                                   // (UIApplication.shared.delegate as? AppDelegate)?.trackBGSteps()
//
//                                    //Remember me check and navigate accordingly
//                                    let boolrememberMe = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udRememberMe)
//                                    let boolQuestionCompleted = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udQuestions)
//                                    if boolrememberMe == true {
//                                        if boolQuestionCompleted == true {
//
//
//                                            //Start all time step tracking in app delegate
//                                          //  (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
//                                            //--------------------------------------
//                                            let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
//                                            let rootNC = UINavigationController(rootViewController: initialViewController)
//                                            rootNC.isNavigationBarHidden = true
//                                            self.window?.rootViewController = rootNC
//                                        } else {
//                                            let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//                                            let rootNC = UINavigationController(rootViewController: initialViewController)
//                                            rootNC.isNavigationBarHidden = true
//                                            self.window?.rootViewController = rootNC
//                                        }
//                                    } else if boolrememberMe == false {
//                                            let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//                                            let rootNC = UINavigationController(rootViewController: initialViewController)
//                                            rootNC.isNavigationBarHidden = true
//                                            self.window?.rootViewController = rootNC
//                                    } else {
//                                        let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//                                        let rootNC = UINavigationController(rootViewController: initialViewController)
//                                        rootNC.isNavigationBarHidden = true
//                                        self.window?.rootViewController = rootNC
//                                    }
//                                    self.window?.makeKeyAndVisible()
//
//
//                    }
//                        else
//                        {
                            ///Steps Tracking
                            (UIApplication.shared.delegate as? AppDelegate)?.trackBGSteps()
                            
                            //Remember me check and navigate accordingly
                            let boolrememberMe = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udRememberMe)
                            let boolQuestionCompleted = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udQuestions)
                            let boolCoachVC = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromCoachVC)
                            if boolrememberMe == true {
                                if boolQuestionCompleted == true {
                                    
                                    
                                    //Start all time step tracking in app delegate
                                    (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
                                    //--------------------------------------
                                    let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                                    let rootNC = UINavigationController(rootViewController: initialViewController)
                                    rootNC.isNavigationBarHidden = true
                                    self.window?.rootViewController = rootNC
                                } else {
                                    if boolCoachVC == true
                                    {
                                        
                                        debugPrint("Hello")
                                        let initialViewController = ConstantStoryboard.Coach.instantiateViewController(withIdentifier: "CoachViewController") as! CoachViewController
                                        let rootNC = UINavigationController(rootViewController: initialViewController)
                                        rootNC.isNavigationBarHidden = true
                                        self.window?.rootViewController = rootNC
                                        
                                    }
                                    else
                                    {
                                    let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                                    let rootNC = UINavigationController(rootViewController: initialViewController)
                                    rootNC.isNavigationBarHidden = true
                                    self.window?.rootViewController = rootNC
                                    }
                                }
                            } else if boolrememberMe == false {
                                    let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                                    let rootNC = UINavigationController(rootViewController: initialViewController)
                                    rootNC.isNavigationBarHidden = true
                                    self.window?.rootViewController = rootNC
                            } else {
                                let initialViewController = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                                let rootNC = UINavigationController(rootViewController: initialViewController)
                                rootNC.isNavigationBarHidden = true
                                self.window?.rootViewController = rootNC
                            }
                            self.window?.makeKeyAndVisible()
                    //    }
        
        
        
       
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        let status = UserDefaults.standard.bool(forKey: "isDenied")
        print(status)
        
        if status == false
        {
//            UserDefaults.standard.set(true, forKey: "isFromBackfround")
            UserDefaults.standard.set(true, forKey: ConstantUserDefaultTag.udFromBackGround)
        }

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        //Background Task
//        (UIApplication.shared.delegate as? AppDelegate)?.scheduleBackgroundStepUpdate()
//        (UIApplication.shared.delegate as? AppDelegate)?.trackBGSteps()
    }


}

